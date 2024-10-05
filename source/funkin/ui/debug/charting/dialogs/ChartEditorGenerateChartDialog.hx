package funkin.ui.debug.charting.dialogs;

import funkin.ui.debug.charting.dialogs.ChartEditorBaseDialog.DialogParams;
import funkin.ui.debug.charting.components.ChartEditorChannelItem;
import haxe.ui.containers.dialogs.Dialog.DialogButton;

// @:nullSafety // TODO: Fix null safety when used with HaxeUI build macros.
@:build(haxe.ui.ComponentBuilder.build("assets/exclude/data/ui/chart-editor/dialogs/generate-chart.xml"))
@:access(funkin.ui.debug.charting.ChartEditorState)
class ChartEditorGenerateChartDialog extends ChartEditorBaseDialog
{
  public function new(state2:ChartEditorState, params2:DialogParams)
  {
    super(state2, params2);

    dialogCancel.onClick = function(_) {
      hideDialog(DialogButton.CANCEL);
    }

    dialogEmptyChart.onClick = function(_) {
      // Dismiss
      hideDialog(DialogButton.APPLY);
    };

    dialogContinue.onClick = function(_) {
      // Dismiss
      hideDialog(DialogButton.APPLY);
    };

    channelView.addComponent(new ChartEditorChannelItem(channelView));
  }

  public override function lock():Void
  {
    super.lock();
    this.dialogCancel.disabled = true;
  }

  public override function unlock():Void
  {
    super.unlock();
    this.dialogCancel.disabled = false;
  }

  public static function build(state:ChartEditorState, ?closable:Bool, ?modal:Bool):ChartEditorGenerateChartDialog
  {
    var dialog = new ChartEditorGenerateChartDialog(state,
      {
        closable: closable ?? false,
        modal: modal ?? true
      });

    dialog.showDialog(modal ?? true);

    return dialog;
  }
}
