package funkin.ui.debug.charting.util;

import funkin.data.song.SongData;
import haxe.ui.containers.VBox;

class DefaultGenerateChartOperator extends GenerateChartOperator
{
  public function new()
  {
    super('defaultGenerateChartOperator', 'Default Algorithm');
  }

  /**
   * Creates the chart
   * @param data The note data
   * @return The notes to generate
   */
  override public function execute(data:Array<NoteMidiData>):Array<SongNoteData>
  {
    var notes:Array<SongNoteData> = [];
    for (d in data)
    {
      notes.push(new SongNoteData(d.time, d.note % 4 + (d.isPlayerNote ? 0 : 4), d.length));
    }
    return notes;
  }

  /**
   * Builds the haxe ui
   * @param root The root to add the components to
   */
  override public function buildUI(root:VBox):Void {}
}
