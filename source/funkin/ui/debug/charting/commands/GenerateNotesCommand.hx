package funkin.ui.debug.charting.commands;

import funkin.data.song.SongData.SongNoteData;
import funkin.data.song.SongDataUtils;

/**
 * Adds the given notes to the current chart in the chart editor.
 */
@:nullSafety
@:access(funkin.ui.debug.charting.ChartEditorState)
class GenerateNotesCommand implements ChartEditorCommand
{
  var previousNotes:Null<Array<SongNoteData>>;
  var previousHints:Null<Array<SongNoteData>>;
  var previousDifficultyId:Null<String>;
  var notes:Array<SongNoteData>;
  var hints:Null<Array<SongNoteData>>;
  var difficultyId:Null<String>;

  public function new(notes:Array<SongNoteData>, ?hints:Array<SongNoteData>, ?difficultyId:String)
  {
    this.previousNotes = null;
    this.previousHints = null;
    this.previousDifficultyId = null;
    this.notes = notes;
    this.hints = hints;
    this.difficultyId = difficultyId;
  }

  public function execute(state:ChartEditorState):Void
  {
    if (previousNotes != null || previousHints != null || previousDifficultyId != null)
    {
      return;
    }

    previousDifficultyId = difficultyId ?? state.selectedDifficulty;
    state.selectedDifficulty = difficultyId ?? state.selectedDifficulty;

    previousNotes = state.currentSongChartNoteData.copy(); // should this be a deep copy?
    previousHints = state.noteHints.copy();

    state.currentSongChartNoteData = notes;

    if (hints != null)
    {
      state.noteHints = hints;
    }

    state.playSound(Paths.sound('chartingSounds/noteLay'));

    state.saveDataDirty = true;
    state.noteDisplayDirty = true;
    state.notePreviewDirty = true;

    state.sortChartData();
  }

  public function undo(state:ChartEditorState):Void
  {
    if (previousNotes == null || previousHints == null || previousDifficultyId == null)
    {
      return;
    }

    var previousDifficulty:String = state.selectedDifficulty;

    state.selectedDifficulty = previousDifficultyId;

    state.currentSongChartNoteData = previousNotes;
    state.noteHints = previousHints;
    state.playSound(Paths.sound('chartingSounds/undo'));

    state.saveDataDirty = true;
    state.noteDisplayDirty = true;
    state.notePreviewDirty = true;

    state.sortChartData();

    state.selectedDifficulty = previousDifficulty;

    previousNotes = null;
    previousHints = null;
    previousDifficultyId = null;
  }

  public function shouldAddToHistory(state:ChartEditorState):Bool
  {
    // This command is undoable. Add to the history if we actually performed an action.
    return previousNotes != null;
  }

  public function toString():String
  {
    if (notes.length == 1)
    {
      var dir:String = notes[0].getDirectionName();
      return 'Generate $dir Note';
    }

    return 'Generate ${notes.length} Notes';
  }
}
