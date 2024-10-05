package funkin.ui.debug.charting.dialogs;

import funkin.ui.debug.charting.dialogs.ChartEditorBaseDialog.DialogParams;
import funkin.ui.debug.charting.dialogs.ChartEditorBaseDialog.DialogDropTarget;
import funkin.ui.debug.charting.components.ChartEditorChannelItem;
import funkin.ui.debug.charting.util.ChartEditorChartGenerator;
import funkin.input.Cursor;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.Dialog.DialogEvent;
import haxe.ui.containers.Box;
import haxe.io.Path;
import grig.midi.MidiFile;

// @:nullSafety // TODO: Fix null safety when used with HaxeUI build macros.

@:build(haxe.ui.ComponentBuilder.build("assets/exclude/data/ui/chart-editor/dialogs/generate-chart.xml"))
@:access(funkin.ui.debug.charting.ChartEditorState)
class ChartEditorGenerateChartDialog extends ChartEditorBaseDialog
{
  var midiFile:Null<MidiFile>;
  var dropHandler:DialogDropTarget;

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

    buildDropHandler();
  }

  function buildDropHandler():Void
  {
    var midiEntry:ChartEditorGenerateChartMidiEntry = new ChartEditorGenerateChartMidiEntry();

    dropHandler = {component: midiEntry, handler: null};

    var onDropFile:String->Void = function(pathStr:String) {
      trace('Selected file: $pathStr');
      var path:Path = new Path(pathStr);

      try
      {
        midiFile = ChartEditorChartGenerator.loadMidiFromPath(path);

        chartEditorState.success('Loaded Midi File', 'Loaded Midi File (${path.file}.${path.ext})');
        #if FILE_DROP_SUPPORTED
        midiEntry.midiEntryLabel.text = 'Midi File (drag and drop, or click to browse)\nSelected file: ${path.file}.${path.ext}';
        #else
        midiEntry.midiEntryLabel.text = 'Midi File (click to browse)\n${path.file}.${path.ext}';
        #end

        chartEditorState.removeDropHandler(dropHandler);
      }
      catch (e)
      {
        trace('Failed to load Midi File (${path.file}.${path.ext})');

        chartEditorState.error('Failed to Load Midi File', 'Failed to load Midi File (${path.file}.${path.ext})');

        #if FILE_DROP_SUPPORTED
        midiEntry.midiEntryLabel.text = 'Drag and drop the Midi File here, or click to browse.';
        #else
        midiEntry.midiEntryLabel.text = 'Click to browse for Midi Files.';
        #end
      }
    };

    midiEntry.onClick = function(_event) {
      Dialogs.openBinaryFile('Open Midi File', [
        {label: 'Midi File (.mid)', extension: 'mid'},
        {label: 'Midi File (.midi)', extension: 'midi'}
      ], function(selectedFile) {
        if (selectedFile != null && selectedFile.bytes != null)
        {
          trace('Selected file: ' + selectedFile.name);

          try
          {
            midiFile = ChartEditorChartGenerator.loadMidiFromBytes(selectedFile.bytes);

            chartEditorState.success('Loaded Midi File', 'Loaded Midi File (${selectedFile.name})');

            #if FILE_DROP_SUPPORTED
            midiEntry.midiEntryLabel.text = 'Midi File (drag and drop, or click to browse)\nSelected file: ${selectedFile.name}';
            #else
            midiEntry.midiEntryLabel.text = 'Midi File (click to browse)\n${selectedFile.name}';
            #end
          }
          catch (e)
          {
            trace('Failed to load Midi File (${selectedFile.fullPath})');

            chartEditorState.error('Failed to Load Midi File', 'Failed to load Midi File (${selectedFile.name})');

            #if FILE_DROP_SUPPORTED
            midiEntry.midiEntryLabel.text = 'Drag and drop the Midi File here, or click to browse.';
            #else
            midiEntry.midiEntryLabel.text = 'Click to browse for Midi Files.';
            #end
          }
        }
      });
    }

    dropHandler.handler = onDropFile;

    midiEntryContainer.addComponent(midiEntry);
  }

  public override function onClose(event:DialogEvent):Void
  {
    super.onClose(event);

    chartEditorState.removeDropHandler(dropHandler);
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

    #if FILE_DROP_SUPPORTED
    state.addDropHandler(dialog.dropHandler);
    #end

    dialog.showDialog(modal ?? true);

    return dialog;
  }
}

@:build(haxe.ui.ComponentBuilder.build("assets/exclude/data/ui/chart-editor/dialogs/generate-chart-midi-entry.xml"))
class ChartEditorGenerateChartMidiEntry extends Box
{
  public function new()
  {
    super();

    #if FILE_DROP_SUPPORTED
    midiEntryLabel.text = 'Drag and drop the Midi File here, or click to browse.';
    #else
    midiEntryLabel.text = 'Click to browse for Midi Files.';
    #end

    this.onMouseOver = function(_) {
      // if (this.locked) return;
      this.swapClass('upload-bg', 'upload-bg-hover');
      Cursor.cursorMode = Pointer;
    }

    this.onMouseOut = function(_) {
      this.swapClass('upload-bg-hover', 'upload-bg');
      Cursor.cursorMode = Default;
    }
  }
}
