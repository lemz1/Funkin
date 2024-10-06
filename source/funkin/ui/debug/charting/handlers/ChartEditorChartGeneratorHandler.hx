package funkin.ui.debug.charting.handlers;

import funkin.ui.debug.charting.ChartEditorState;
import funkin.data.song.SongData;
import funkin.util.SortUtil;
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
  /**
   * Generate Hints (and Notes)
   * @param state The Chart Editor State
   * @param params The Params
   */
  public static function generateChartFromMidi(state:ChartEditorState, params:ChartGeneratorParams):Void
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
              var time:Float = (event.absoluteTime / params.midi.timeDivision) * (60.0 / bpm) * 1000.0;
              state.noteHints.push(new SongNoteData(time, data, 0));
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

    for (note in state.noteHints)
    {
      // creates note stuff
    }
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
}

typedef ChartGeneratorParams =
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
