package funkin.ui.debug.charting.handlers;

import funkin.ui.debug.charting.ChartEditorState;
import grig.midi.file.event.MidiFileEventType;
import grig.midi.MidiFile;
import grig.midi.MidiTrack;

/**
 * Helper class for generating charts
 */
class ChartEditorChartGeneratorHandler
{
  /**
   * TODO: Make this return something
   * @param state The Chart Editor State
   * @param params The Params
   */
  public static function generateChartFromMidi(state:ChartEditorState, params:ChartGeneratorParams):Void
  {
    var validTracks:Array<MidiTrack> = getValidTracks(params.midi.tracks, params.channels);
    trace(validTracks);
  }

  static function getValidTracks(tracks:Array<MidiTrack>, channels:Array<ChartGeneratorChannel>):Array<MidiTrack>
  {
    var validTracks:Array<MidiTrack> = [];
    for (track in tracks)
    {
      switch (track.midiEvents[0].type) // get track name
      {
        case Text(event):
          if (isNameInChannels(event.bytes.getString(0, event.bytes.length), channels))
          {
            validTracks.push(track);
          }
        default:
          // do nothing
      }
    }

    return validTracks;
  }

  static function isNameInChannels(name:String, channels:Array<ChartGeneratorChannel>):Bool
  {
    for (channel in channels)
    {
      if (channel.name == name)
      {
        return true;
      }
    }

    return false;
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
