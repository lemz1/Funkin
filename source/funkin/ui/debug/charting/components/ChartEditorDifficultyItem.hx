package funkin.ui.debug.charting.components;

import haxe.ui.containers.HBox;
import haxe.ui.containers.ScrollView;
import haxe.ui.components.TextField;
import haxe.ui.components.NumberStepper;

/**
 * The component which contains the difficulty data item for the difficulty generator.
 * This is in a separate component so it can be positioned independently.
 */
@:build(haxe.ui.ComponentBuilder.build("assets/exclude/data/ui/chart-editor/components/difficulty-item.xml"))
class ChartEditorDifficultyItem extends HBox
{
  var view:ScrollView;

  public function new(view:ScrollView)
  {
    super();

    this.view = view;

    createButton.onClick = function(_) {
      plusBox.hidden = true;
      difficultyFrame.hidden = false;
      this.view.addComponent(new ChartEditorDifficultyItem(this.view));
    }

    destroyButton.onClick = function(_) {
      plusBox.hidden = false;
      difficultyFrame.hidden = true;
      this.view.removeComponent(this);
    }
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (difficultyTextField.value != null && difficultyTextField.value.length != 0)
    {
      difficultyFrame.text = difficultyTextField.value;
    }
    else
    {
      difficultyFrame.text = "Difficulty";
    }
  }
}
