package funkin.ui.modding;

import flixel.FlxG;
import funkin.ui.title.TitleState;
import funkin.modding.PolymodHandler;
import funkin.graphics.FunkinCamera;
import funkin.audio.FunkinSound;
import funkin.save.Save;
import funkin.input.Cursor;
import haxe.ui.backend.flixel.UIState;
import haxe.ui.components.Label;

/**
 * A state for enabling and reordering mods.
 */
@:build(haxe.ui.ComponentBuilder.build("assets/exclude/data/ui/outdated-mods/main-view.xml"))
class OutdatedModsState extends UIState // UIState derives from MusicBeatState
{
  var uiCamera:FunkinCamera;

  public function new()
  {
    super();
  }

  override function create():Void
  {
    super.create();

    for (mod in PolymodHandler.getNewOutdatedMods())
    {
      var label:Label = new Label();
      label.value = '${mod.title} (v${mod.apiVersion}, id: ${mod.id})';
      outdatedMods.addComponent(label);

      Save.instance.outdatedModIds.push(mod.id);
    }

    Cursor.show();

    uiCamera = new FunkinCamera('outdatedModsStateUI');
    FlxG.cameras.reset(uiCamera);
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if ((FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.Q) || controls.ACCEPT || controls.BACK)
    {
      FlxG.switchState(() -> new TitleState());
    }
  }

  override function destroy():Void
  {
    super.destroy();

    Cursor.hide();
  }
}
