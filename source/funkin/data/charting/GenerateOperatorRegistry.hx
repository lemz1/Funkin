package funkin.data.charting;

import funkin.util.macro.ClassMacro;
import funkin.data.song.SongData;
import funkin.data.BaseClassRegistry;
import funkin.data.IClassRegistryEntry;
import funkin.ui.debug.charting.handlers.ChartEditorChartGeneratorHandler;
import funkin.ui.debug.charting.util.GenerateChartOperator;
import funkin.ui.debug.charting.util.ScriptedGenerateChartOperator;
import funkin.ui.debug.charting.util.GenerateDifficultyOperator;
import funkin.ui.debug.charting.util.ScriptedGenerateDifficultyOperator;

@:build(funkin.util.macro.ClassRegistryMacro.build(funkin.data.charting.ClassEntry, funkin.ui.debug.charting.util.ScriptedGenerateChartOperator))
class TestMacro extends BaseClassRegistry<ClassEntry>
{
  public function new()
  {
    super('testMacro');
  }
}
// /**
//  * This class statically handles the parsing of internal and scripted generate chart operators.
//  */
// class GenerateChartOperatorRegistry
// {
//   /**
//    * Every built-in op class must be added to this list.
//    * Thankfully, with the power of `GenerateChartOperatorMacro`, this is done automatically.
//    */
//   static final BUILTIN_OPERATORS:List<Class<GenerateChartOperator>> = ClassMacro.listSubclassesOf(GenerateChartOperator);
//   /**
//    * Map of internal handlers for generate chart operators.
//    * These may be either `ScriptedGenerateChartOperator` or built-in classes extending `GenerateChartOperator`.
//    */
//   static final operatorCache:Map<String, GenerateChartOperator> = new Map<String, GenerateChartOperator>();
//   public static function loadOperatorCache():Void
//   {
//     clearOperatorCache();
//     registerBaseOperators();
//     registerScriptedOperators();
//   }
//   static function registerBaseOperators():Void
//   {
//     trace('Instantiating ${BUILTIN_OPERATORS.length} built-in generate chart operators...');
//     for (operatorCls in BUILTIN_OPERATORS)
//     {
//       var operatorClsName:String = Type.getClassName(operatorCls);
//       if (operatorClsName == 'funkin.ui.debug.charting.util.GenerateChartOperator'
//         || operatorClsName == 'funkin.ui.debug.charting.util.ScriptedGenerateChartOperator')
//       {
//         continue;
//       }
//       var op:GenerateChartOperator = Type.createInstance(operatorCls, ['UNKNOWN', 'UNKNOWN']);
//       if (op != null)
//       {
//         trace('  Loaded built-in generate chart operator: ${op.id}');
//         operatorCache.set(op.id, op);
//       }
//       else
//       {
//         trace('  Failed to load built-in generate chart operator: ${Type.getClassName(operatorCls)}');
//       }
//     }
//   }
//   static function registerScriptedOperators():Void
//   {
//     var scriptedOperatorClassNames:Array<String> = ScriptedGenerateChartOperator.listScriptClasses();
//     trace('Instantiating ${scriptedOperatorClassNames.length} scripted generate chart operators...');
//     if (scriptedOperatorClassNames == null || scriptedOperatorClassNames.length == 0) return;
//     for (operatorCls in scriptedOperatorClassNames)
//     {
//       var op:GenerateChartOperator = ScriptedGenerateChartOperator.init(operatorCls, 'UNKNOWN', 'UNKNOWN');
//       if (op != null)
//       {
//         trace('  Loaded scripted generate chart operator: ${op.id}');
//         operatorCache.set(op.id, op);
//       }
//       else
//       {
//         trace('  Failed to instantiate scripted generate chart operator class: ${operatorCls}');
//       }
//     }
//   }
//   public static function listOperatorIds():Array<String>
//   {
//     return operatorCache.keys().array();
//   }
//   public static function listOperators():Array<GenerateChartOperator>
//   {
//     return operatorCache.values();
//   }
//   public static function getOperator(id:String):Null<GenerateChartOperator>
//   {
//     return operatorCache.get(id);
//   }
//   public static function executeOperator(id:String, data:Array<NoteMidiData>):Null<Array<SongNoteData>>
//   {
//     return operatorCache.get(id)?.execute(data);
//   }
//   public static function buildOperatorUI(id:String, root:VBox):Void
//   {
//     operatorCache.get(id)?.buildUI(root);
//   }
//   static function clearoperatorCache():Void
//   {
//     operatorCache.clear();
//   }
// }
// /**
//  * This class statically handles the parsing of internal and scripted generate difficulty operators.
//  */
// class GenerateDifficultyOperatorRegistry
// {
//   /**
//    * Every built-in op class must be added to this list.
//    * Thankfully, with the power of `GenerateDifficultyOperatorMacro`, this is done automatically.
//    */
//   static final BUILTIN_OPERATORS:List<Class<GenerateDifficultyOperator>> = ClassMacro.listSubclassesOf(GenerateDifficultyOperator);
//   /**
//    * Map of internal handlers for generate chart operators.
//    * These may be either `ScriptedGenerateDifficultyOperator` or built-in classes extending `GenerateDifficultyOperator`.
//    */
//   static final operatorCache:Map<String, GenerateDifficultyOperator> = new Map<String, GenerateDifficultyOperator>();
//   public static function loadOperatorCache():Void
//   {
//     clearOperatorCache();
//     registerBaseOperators();
//     registerScriptedOperators();
//   }
//   static function registerBaseOperators():Void
//   {
//     trace('Instantiating ${BUILTIN_OPERATORS.length} built-in generate difficulty operators...');
//     for (operatorCls in BUILTIN_OPERATORS)
//     {
//       var operatorClsName:String = Type.getClassName(operatorCls);
//       if (operatorClsName == 'funkin.ui.debug.charting.util.GenerateDifficultyOperator'
//         || operatorClsName == 'funkin.ui.debug.charting.util.ScriptedGenerateDifficultyOperator')
//       {
//         continue;
//       }
//       var op:GenerateChartOperator = Type.createInstance(operatorCls, ['UNKNOWN', 'UNKNOWN']);
//       if (op != null)
//       {
//         trace('  Loaded built-in generate difficulty operator: ${op.id}');
//         operatorCache.set(op.id, op);
//       }
//       else
//       {
//         trace('  Failed to load built-in generate difficulty operator: ${Type.getClassName(operatorCls)}');
//       }
//     }
//   }
//   static function registerScriptedOperators():Void
//   {
//     var scriptedOperatorClassNames:Array<String> = ScriptedGenerateDifficultyOperator.listScriptClasses();
//     trace('Instantiating ${scriptedOperatorClassNames.length} scripted generate difficulty operators...');
//     if (scriptedOperatorClassNames == null || scriptedOperatorClassNames.length == 0) return;
//     for (operatorCls in scriptedOperatorClassNames)
//     {
//       var op:GenerateDifficultyOperator = ScriptedGenerateDifficultyOperator.init(operatorCls, 'UNKNOWN', 'UNKNOWN');
//       if (op != null)
//       {
//         trace('  Loaded scripted generate difficulty operator: ${op.id}');
//         operatorCache.set(op.id, op);
//       }
//       else
//       {
//         trace('  Failed to instantiate scripted generate difficulty operator class: ${operatorCls}');
//       }
//     }
//   }
//   public static function listOperatorIds():Array<String>
//   {
//     return operatorCache.keys().array();
//   }
//   public static function listOperators():Array<GenerateDifficultyOperator>
//   {
//     return operatorCache.values();
//   }
//   public static function getOperator(id:String):Null<GenerateDifficultyOperator>
//   {
//     return operatorCache.get(id);
//   }
//   public static function executeOperator(id:String, data:Array<SongNoteData>):Null<Array<SongNoteData>>
//   {
//     return operatorCache.get(id)?.execute(data);
//   }
//   public static function buildOperatorUI(id:String, root:VBox):Void
//   {
//     operatorCache.get(id)?.buildUI(root);
//   }
//   static function clearoperatorCache():Void
//   {
//     operatorCache.clear();
//   }
// }
