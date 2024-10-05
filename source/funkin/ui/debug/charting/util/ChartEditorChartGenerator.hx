package funkin.ui.debug.charting.util;

import grig.midi.MidiFile;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.Path;

/**
 * Helper class for generating charts
 */
class ChartEditorChartGenerator
{
  /**
   * TODO: Make this return something
   * @param midi The Midi File
   * @param onlyHints Whether to only generate hints or notes as well
   */
  public static function generateChart(midi:MidiFile, onlyHints:Bool):Void {}

  /**
   * Get Midi File
   * @param path Path with extension
   * @return MidiFile
   */
  public static function loadMidiFromPath(path:Path):MidiFile
  {
    var bytes:Bytes = sys.io.File.getBytes(path.toString());
    return loadMidiFromBytes(bytes);
  }

  /**
   * Get Midi File
   * @param bytes Bytes
   * @return MidiFile
   */
  public static function loadMidiFromBytes(bytes:Bytes):MidiFile
  {
    var input:BytesInput = new BytesInput(bytes);
    return MidiFile.fromInput(input);
  }
}
