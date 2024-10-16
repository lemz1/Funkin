package funkin.util.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using StringTools;

class ClassEntryMacro
{
  public static macro function build():Array<Field>
  {
    var fields = Context.getBuildFields();

    var cls = Context.getLocalClass().get();

    buildIdField(fields);

    buildDestroyField(cls, fields);

    buildToStringField(cls, fields);

    return fields;
  }

  #if macro
  static function shouldBuildField(name:String, fields:Array<Dynamic>):Bool // fields can be Array<Field> or Array<ClassField>
  {
    for (field in fields)
    {
      if (field.name == name)
      {
        return false;
      }
    }
    return true;
  }

  static function buildIdField(fields:Array<Field>):Void
  {
    if (!shouldBuildField('id', fields))
    {
      return;
    }

    fields.push(
      {
        name: 'id',
        access: [Access.AFinal, Access.APublic],
        kind: FieldType.FVar((macro :String)),
        pos: Context.currentPos()
      });
  }

  static function buildDestroyField(cls:ClassType, fields:Array<Field>):Void
  {
    if (!shouldBuildField('destroy', fields))
    {
      return;
    }

    fields.push(
      {
        name: 'destroy',
        access: [Access.APublic],
        kind: FieldType.FFun(
          {
            args: [],
            expr: macro
            {
              return;
            }
          }),
        pos: Context.currentPos()
      });
  }

  static function buildToStringField(cls:ClassType, fields:Array<Field>):Void
  {
    if (!shouldBuildField('toString', fields))
    {
      return;
    }

    fields.push(
      {
        name: 'toString',
        access: [Access.APublic],
        kind: FieldType.FFun(
          {
            args: [],
            expr: macro
            {
              return $v{cls.name} + '(' + id + ')';
            }
          }),
        pos: Context.currentPos()
      });
  }
  #end
}
