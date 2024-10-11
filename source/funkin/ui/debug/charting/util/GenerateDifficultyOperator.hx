package funkin.ui.debug.charting.util;

import funkin.data.song.SongData.SongNoteData;
import haxe.ui.containers.VBox;

/**
 * Scriptable difficulty generation operator
 */
class GenerateDifficultyOperator
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
   * Creates the chart for the difficulty
   * @param data The original notes
   * @return The notes to generate
   */
  public function execute(data:Array<SongNoteData>):Array<SongNoteData>
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
    return 'GenerateDifficultyOperator ($name)';
  }
}
