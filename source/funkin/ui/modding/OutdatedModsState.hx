package funkin.ui.modding;

import funkin.ui.debug.modding.components.ModBox;
import funkin.ui.mainmenu.MainMenuState;
import funkin.graphics.FunkinCamera;
import funkin.audio.FunkinSound;
import funkin.input.Cursor;
import funkin.modding.PolymodHandler;
import funkin.save.Save;
import haxe.ui.backend.flixel.UIState;
import polymod.Polymod.ModMetadata;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxRect;
import flixel.FlxG;
import openfl.display.BitmapData;

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

    Cursor.show();

    uiCamera = new FunkinCamera('outdatedModsStateUI');
    FlxG.cameras.reset(uiCamera);
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    // if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.Q)
    // {
    //   quitModState();
    // }
  }

  override function destroy():Void
  {
    super.destroy();

    Cursor.hide();
  }
}
