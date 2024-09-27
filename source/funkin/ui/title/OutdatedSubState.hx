package funkin.ui.title;

import lime.app.Application;
import haxe.Http;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import funkin.graphics.FunkinSprite;
import funkin.ui.MusicBeatSubState;
import funkin.util.Constants;
import funkin.util.VersionUtil;
import funkin.input.Controls;

@:access(funkin.input.Controls)
class OutdatedSubState extends MusicBeatSubState
{
  public static var leftState:Bool = false;

  static final URL:String = "https://raw.githubusercontent.com/FunkinCrew/Funkin/refs/heads/main/project.hxp";

  static var currentVersion:Null<String> = null;
  static var newVersion:Null<String> = null;

  public static var outdated(get, never):Bool;

  static function get_outdated():Bool
  {
    if (currentVersion == null || newVersion == null)
    {
      retrieveVersions();
    }

    return VersionUtil.validateVersionStr(currentVersion, "<" + newVersion);
  }

  override function create():Void
  {
    super.create();

    var bg:FunkinSprite = new FunkinSprite().makeSolidColor(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(bg);

    var txt:FlxText = new FlxText(0, 0, FlxG.width,
      "HEY! You're running an outdated version of the game!\nCurrent version is "
      + currentVersion
      + " while the most recent version is "
      + newVersion
      + '!\n Press ACCEPT-Button to go to itch.io, '
      + '\nor BACK-Button to ignore this!!',
      32);
    txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
    txt.screenCenter();
    add(txt);

    if (FlxG.sound.music != null)
    {
      FlxG.sound.music.pause();
    }
  }

  override function update(elapsed:Float):Void
  {
    if (controls.ACCEPT)
    {
      FlxG.openURL("https://ninja-muffin24.itch.io/funkin");
    }
    if (controls.BACK)
    {
      leftState = true;

      if (FlxG.sound.music != null)
      {
        FlxG.sound.music.resume();
      }

      this.close();
    }
    super.update(elapsed);
  }

  static function retrieveVersions():Void
  {
    var http:Http = new Http(URL);

    http.onData = function(data:String) {
      // we love our regexes
      var regex = ~/static\s+final\s+VERSION:String\s*=\s*"([^"]+)"/;
      newVersion = regex.match(data) ? regex.matched(1) : Constants.VERSION;
    };

    http.request(false);

    newVersion = newVersion ?? Constants.VERSION; // if http request failed use current version
    currentVersion = "0.4.1";
  }
}
