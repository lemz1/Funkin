package funkin.ui.debug.charting.util;

import funkin.data.song.SongData.SongNoteData;
import haxe.ui.containers.VBox;

/**
 * Scriptable chart generation operator
 */
class GenerateChartOperator
{
  /**
   * Internal ID
   */
  public var id:String;

  /**
   * Displayed Name in Chart Editor dropdown
   */
  public var name:String;

  public function new(id:String, name:String)
  {
    this.id = id;
    this.name = name;
  }

  /**
   * Creates the chart
   * @param data The note data
   * @return The notes to generate
   */
  public function execute(data:Array<NoteMidiData>):Array<SongNoteData>
  {
    return [];
  }

  /**
   * Builds the haxe ui
   * @param root The root to add the components to
   */
  public function buildUI(root:VBox):Void {}

  public function toString():String
  {
    return 'GenerateChartOperator ($name)';
  }
}
