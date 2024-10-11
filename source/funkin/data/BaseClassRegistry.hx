package funkin.data;

import haxe.Constraints.Constructible;
import flixel.FlxG;

using StringTools;

@:generic
abstract class BaseClassRegistry<T:(IClassRegistryEntry)>
{
  /**
   * This registry's id
   */
  public var registryId(default, null):String;

  final entries:Map<String, T>;
  final scriptedEntries:Map<String, String>;

  public function new(registryId:String)
  {
    this.registryId = registryId;
    this.entries = new Map<String, T>();
    this.scriptedEntries = new Map<String, String>();

    // Lazy initialization of singletons should let this get called,
    // but we have this check just in case.
    if (FlxG.game != null)
    {
      FlxG.console.registerObject('registry$registryId', this);
    }
  }

  /**
   * Retrieve all registered Entries
   * @return Entries
   */
  public function fetchEntries():Array<T>
  {
    return entries.values();
  }

  /**
   * Retrieve all registered Entries' ids
   * @return Ids
   */
  public function fetchEntryIds():Array<String>
  {
    return entries.keys().array();
  }

  /**
   * Retrieve only registered scripted Entries
   * @return Scripted Entries
   */
  public function fetchScriptedEntries():Array<String>
  {
    return scriptedEntries.values();
  }

  /**
   * Retrieve only registered scripted Entries' ids
   * @return Scripted Ids
   */
  public function fetchScriptedEntryIds():Array<String>
  {
    return scriptedEntries.keys().array();
  }

  function registerBuiltInClasses():Void
  {
    final registryName:String = registryTraceName();

    trace('Instantiating ${getBuiltInEntries().length} built-in${registryName}s...');
    for (entryCls in getBuiltInEntries())
    {
      var entryClsName:String = Type.getClassName(entryCls);
      if (entryClsName == 'funkin.ui.debug.charting.util.GenerateDifficultyOperator'
        || entryClsName == 'funkin.ui.debug.charting.util.ScriptedGenerateDifficultyOperator')
      {
        continue;
      }

      var entry:T = Type.createInstance(entryCls, []);

      if (entry != null)
      {
        trace('  Loaded built-in${registryName}: ${entry.id}');
        entries.set(entry.id, entry);
      }
      else
      {
        trace('  Failed to load built-in${registryName}: ${Type.getClassName(entryCls)}');
      }
    }
  }

  function registerScriptedClasses():Void
  {
    final registryName:String = registryTraceName();

    // var scriptedEntryClsNames:Array<String> = ScriptedGenerateDifficultyOperator.listScriptClasses();
    var scriptedEntryClsNames:Array<String> = [];
    trace('Instantiating ${scriptedEntryClsNames.length} scripted${registryName}s...');
    if (scriptedEntryClsNames == null || scriptedEntryClsNames.length == 0) return;

    for (entryCls in scriptedEntryClsNames)
    {
      var entry:Null<T> = createScriptedEntry(entryCls);

      if (entry != null)
      {
        trace('  Loaded scripted${registryName}: ${entry.id}');
        entries.set(entry.id, entry);
        scriptedEntries.set(entry.id, entryCls);
      }
      else
      {
        trace('  Failed to instantiate scripted${registryName} class: ${entryCls}');
      }
    }
  }

  function registryTraceName():String
  {
    var registryName:String = '';
    var str:String = Type.getClassName(BaseClassRegistry);
    return str;
    // for (c in Type.getClassName(BaseClassRegistry))
    // {
    //   if ('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(c))
    //   {
    //     registryName += '';
    //   }
    //   registryName += c;
    // }
    // return registryName.toLowerCase();
  }

  abstract function getBuiltInEntries():List<Class<Dynamic>>;

  abstract function createScriptedEntry(id:String):Null<Dynamic>;
}
