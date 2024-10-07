package funkin.ui.debug.charting.handlers;

import funkin.ui.debug.charting.ChartEditorState;
import funkin.data.song.SongData;
import funkin.util.SortUtil;
import funkin.util.FileUtil;
import grig.midi.file.event.MidiFileEventType;
import grig.midi.MessageType;
import grig.midi.MidiFile;
import flixel.util.FlxSort;

/**
 * Helper class for generating charts
 */
@:access(funkin.ui.debug.charting.ChartEditorState)
class ChartEditorChartGeneratorHandler
{
  static final CHUNK_INTERVAL_MS:Float = 2500;

  static final NOTE_DIFF_THRESHOLD_MS:Float = 1;

  /**
   * Generate Hints (and Notes)
   * @param state The Chart Editor State
   * @param params The Params
   */
  public static function generateChartFromMidi(state:ChartEditorState, params:ChartGeneratorHintParams):Void
  {
    state.noteDisplayDirty = true;
    state.noteHints = [];

    var bpm:Float = 0;
    for (track in params.midi.tracks)
    {
      var channelIndex:Int = -1;
      switch (track.midiEvents[0].type) // get track name
      {
        case Text(event):
          channelIndex = getChannelIndex(event.bytes.getString(0, event.bytes.length), params.channels);
          if (channelIndex == -1)
          {
            continue;
          }
        default:
          // do nothing
      }

      var channel:ChartGeneratorChannel = params.channels[channelIndex];

      for (event in track.midiEvents)
      {
        switch (event.type)
        {
          case TempoChange(e):
            // bpm = e.tempo; // e.tempo returns a wrong value
            // it happens because of the use of Std.int
            // for now we'll just do it ourselves
            // maybe we should create a fork, which fixes that issue
            bpm = 60000000.0 / e.microsecondsPerQuarterNote;
          case MidiMessage(e):
            if (e.midiMessage.messageType == MessageType.NoteOn)
            {
              // byte 2 = note
              var data:Int = (e.midiMessage.byte2 % 4) + (channel.isPlayerTrack ? 0 : 4);
              var time:Float = translateToMS(event.absoluteTime, bpm, params.midi.timeDivision);
              state.noteHints.push(new SongNoteData(time, data, 0));
            }
            else if (e.midiMessage.messageType == MessageType.NoteOff)
            {
              if (state.noteHints.length == 0)
              {
                continue;
              }

              var currentHint:SongNoteData = state.noteHints[state.noteHints.length - 1];
              var threshold:Float = (60.0 / bpm) * 1000.0 * 0.25;
              var sustainLength:Float = translateToMS(event.absoluteTime, bpm, params.midi.timeDivision);
              sustainLength -= currentHint.time;
              sustainLength -= threshold;
              if (sustainLength > 0.001)
              {
                currentHint.length = sustainLength;
              }
            }
          default:
            // do nothing
        }
      }
    }

    state.noteHints.sort(SortUtil.noteDataByTime.bind(FlxSort.ASCENDING));

    if (params.onlyHints)
    {
      return;
    }

    // NOTE GENERATION

    var noteIndex:Int = 0;

    for (hint in state.noteHints)
    {
      var noteAlreadyPlaced:Bool = false;
      for (i in noteIndex...state.currentSongChartNoteData.length)
      {
        var note:SongNoteData = state.currentSongChartNoteData[i];

        if (note.getStrumlineIndex() != hint.getStrumlineIndex())
        {
          continue;
        }

        if (note.time - hint.time <= NOTE_DIFF_THRESHOLD_MS)
        {
          noteIndex = i;
        }
        else
        {
          break;
        }

        if (Math.abs(note.time - hint.time) <= NOTE_DIFF_THRESHOLD_MS)
        {
          noteAlreadyPlaced = true;
          break;
        }
      }

      if (noteAlreadyPlaced)
      {
        continue;
      }

      state.currentSongChartNoteData.insert(noteIndex + 1, hint);
    }
  }

  /**
   * Generate an easier version of a given chart
   * @param state The Chart Editor State
   * @param params The Params
   */
  public static function generateChartDifficulty(state:ChartEditorState, params:ChartGeneratorDifficultyParams):Void
  {
    var notes:Array<SongNoteData> = state.currentSongChartData.notes.get(params.refDifficultyId) ?? [];

    if (notes.length == 0)
    {
      trace("No Notes (ChartEditorChartGeneratorHandler.generateChartDifficulty)");
      return;
    }

    var difficultyNotes:Array<SongNoteData> = switch (params.algorithm)
    {
      case RemoveNthTooClose(n):
        removeNthTooCloseAlgorithm(notes, n);
    };

    state.currentSongChartData.notes.set(params.difficultyId, difficultyNotes);

    state.currentSongChartData.scrollSpeed.set(params.difficultyId, params.scrollSpeed);
  }

  /**
   * Create a list of ZIP file entries from the current loaded vocal tracks in the chart eidtor.
   * @param state The chart editor state.
   * @return `haxe.zip.Entry`
   */
  public static function makeZIPEntryFromMidi(state:ChartEditorState):haxe.zip.Entry
  {
    return FileUtil.makeZIPEntryFromBytes('hintMidi.mid', state.midiData);
  }

  static function getChannelIndex(name:String, channels:Array<ChartGeneratorChannel>):Int
  {
    for (i in 0...channels.length)
    {
      if (channels[i].name == name)
      {
        return i;
      }
    }

    return -1;
  }

  static function translateToMS(time:Float, bpm:Float, timeDivision:Float):Float
  {
    return (time / timeDivision) * (60.0 / bpm) * 1000.0;
  }

  static function removeNthTooCloseAlgorithm(notes:Array<SongNoteData>, n:Int):Array<SongNoteData>
  {
    var difficultyNotes:Array<SongNoteData> = notes.copy();
    // difficultyNotes.insertionSort(SortUtil.noteDataByTime.bind(FlxSort.ASCENDING));

    var threshold:Float = Conductor.instance.stepLengthMs * 1.5;
    var notesToRemove:Array<SongNoteData> = [];
    var curNPlayer:Int = 0;
    var curNOpponent:Int = 0;
    for (i in 0...(difficultyNotes.length - 1))
    {
      var noteI:SongNoteData = difficultyNotes[i];
      if (noteI == null || notesToRemove.contains(noteI))
      {
        continue;
      }

      for (j in (i + 1)...difficultyNotes.length)
      {
        var noteJ:SongNoteData = difficultyNotes[j];
        if (noteJ == null
          || noteJ.length != 0
          || noteJ.getStrumlineIndex() != noteI.getStrumlineIndex()
          || notesToRemove.contains(noteJ))
        {
          continue;
        }

        var curN:Float = noteJ.getStrumlineIndex() == 0 ? curNPlayer : curNOpponent;

        if (Math.abs(noteJ.time - noteI.time) <= threshold)
        {
          if (curN % n == 0)
          {
            notesToRemove.push(noteJ);
          }

          if (noteJ.getStrumlineIndex() == 0)
          {
            curNPlayer++;
          }
          else
          {
            curNOpponent++;
          }
        }
      }
    }

    for (note in notesToRemove)
    {
      difficultyNotes.remove(note);
    }

    return difficultyNotes;
  }
}

typedef ChartGeneratorHintParams =
{
  var midi:MidiFile;
  var channels:Array<ChartGeneratorChannel>;
  var onlyHints:Bool;
}

typedef ChartGeneratorChannel =
{
  var name:String;
  var isPlayerTrack:Bool;
}

typedef ChartGeneratorDifficultyParams =
{
  var refDifficultyId:String;
  var difficultyId:String;
  var algorithm:ChartGeneratorDifficultyAlgorithm;
  var scrollSpeed:Float;
}

enum ChartGeneratorDifficultyAlgorithm
{
  RemoveNthTooClose(n:Int);
}
