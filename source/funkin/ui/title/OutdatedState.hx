package funkin.ui.title;

import lime.app.Application;
import haxe.Http;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import funkin.graphics.FunkinSprite;
import funkin.ui.MusicBeatState;
import funkin.util.Constants;
import funkin.util.VersionUtil;
import funkin.input.Controls;

/**
 * Class that notifies the player that there is an update
 */
class OutdatedState extends MusicBeatState
{
  static final URL:String = "https://raw.githubusercontent.com/FunkinCrew/Funkin/refs/heads/main/project.hxp";

  public static var outdated(get, never):Bool;

  static var currentVersion:Null<String> = null;
  static var newVersion:Null<String> = null;

  var leftState:Bool = false;

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
    super.update(elapsed);

    if (leftState)
    {
      return;
    }

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

      FlxG.switchState(() -> new TitleState());
    }
  }

  static function testItch():Void
  {
    var url = "https://ninja-muffin24.itch.io/funkin";

    var html:Null<String> = null;

    var http = new Http(url);
    http.onData = function(data) {
      html = data;
    };
    http.request(false);

    if (html == null)
    {
      return;
    }

    trace(html);
  }

  static function retrieveVersions():Void
  {
    testItch();

    var http:Http = new Http(URL);

    http.onData = function(data:String) {
      // we love our regexes
      var regex = ~/static\s+final\s+VERSION:String\s*=\s*"([^"]+)"/;
      newVersion = regex.match(data) ? regex.matched(1) : Constants.VERSION;
    };

    http.request(false);

    newVersion = newVersion ?? Constants.VERSION; // if http request failed use current version
    currentVersion = Constants.VERSION;
  }

  public static function build():MusicBeatState
  {
    // #if debug
    // return new TitleState();
    // #else
    return outdated ? new OutdatedState() : new TitleState();
    // #end
  }
}
