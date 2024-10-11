package funkin.util.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import funkin.util.macro.MacroUtil;

class ClassRegistryMacro
{
  public static macro function build(?scriptedClsExpr:Expr):Array<Field>
  {
    var fields = Context.getBuildFields();

    var clsType = Context.getLocalClass().get();
    var clsPackage = clsType.module.substr(0, clsType.module.lastIndexOf('.'));
    var clsName = '${clsPackage}.${clsType.name}';
    var cls = Type.resolveClass(clsName);

    var scriptedClsType = MacroUtil.getClassTypeFromExpr(scriptedClsExpr);
    var scriptedClsPackage = scriptedClsType.module.substr(0, scriptedClsType.module.lastIndexOf('.'));
    var scriptedClsName = '${scriptedClsPackage}.${scriptedClsType.name}';
    var scriptedCls = Type.resolveClass(scriptedClsName);

    fields.push(
      {
        name: "getBuiltInEntries",
        access: [Access.APrivate],
        kind: FFun(
          {
            args: [],
            expr: macro
            {return ClassMacro.listSubclassesOf(funkin.data.charting.ClassEntry);},
            params: [],
            ret: (macro :List<Class<Dynamic>>)
          }),
        pos: Context.currentPos()
      });

    fields.push(
      {
        name: "createScriptedEntry",
        access: [Access.APrivate],
        kind: FFun(
          {
            args: [
              {name: 'id', type: (macro :String)}],
            expr: macro
            {
              return $v{scriptedCls}.init('LOL'); // i dont think this works
            },
            params: [],
            ret: (macro :Null<Dynamic>)
          }),
        pos: Context.currentPos()
      });

    return fields;
  }
}
