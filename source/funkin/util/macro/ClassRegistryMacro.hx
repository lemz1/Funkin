package funkin.util.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import funkin.util.macro.MacroUtil;

using StringTools;

class ClassRegistryMacro
{
  public static macro function build(entryExpr:ExprOf<Class<Dynamic>>, scriptedEntryExpr:ExprOf<Class<Dynamic>>):Array<Field>
  {
    var fields = Context.getBuildFields();

    var clsType = Context.getLocalClass().get();
    var clsTypeName = clsType.pack.join('.') + '.' + clsType.name;

    var entryClsType = MacroUtil.getClassTypeFromExpr(entryExpr);
    var entryClsTypeName = entryClsType.pack.join('.') + '.' + entryClsType.name;

    var scriptedEntryClsType = MacroUtil.getClassTypeFromExpr(scriptedEntryExpr);
    var scriptedEntryClsTypeName = scriptedEntryClsType.pack.join('.') + '.' + scriptedEntryClsType.name;

    fields.push(
      {
        name: '_instance',
        access: [
          Access.APublic,
          Access.AStatic
        ],
        kind: FieldType.FVar(
          ComplexType.TPath(
            {
              pack: [],
              name: 'Null',
              params: [
                TypeParam.TPType(
                  ComplexType.TPath(
                    {
                      pack: clsType.pack,
                      name: clsType.name,
                      params: []
                    }
                  )
                )
              ]
            }
          )
        ),
        pos: Context.currentPos()
      });

    fields.push(
      {
        name: 'instance',
        access: [
          Access.APublic,
          Access.AStatic
        ],
        kind: FieldType.FProp(
          "get",
          "never",
          ComplexType.TPath(
            {
              pack: clsType.pack,
              name: clsType.name,
              params: []
            }
          )
        ),
        pos: Context.currentPos()
      });

    fields.push(
      {
        name: 'get_instance',
        access: [
          Access.APrivate,
          Access.AStatic
        ],
        kind: FFun(
          {
            args: [],
            expr: macro
            {
              if (_instance == null) {
                _instance = Type.createInstance(Type.resolveClass($v{clsTypeName}), []);
              }
              return _instance;
            },
            params: [],
            ret: ComplexType.TPath(
              {
                pack: clsType.pack,
                name: clsType.name,
                params: []
              }
            )
          }),
        pos: Context.currentPos()
      });

    fields.push(
      {
        name: 'entryTraceName',
        access: [Access.APrivate],
        kind: FieldType.FFun(
          {
            args: [],
            expr: macro
            {
              var traceName:String = '';
              for (i in 0...$v{entryClsType.name.length}) {
                var c = $v{entryClsType.name}.charAt(i);
                if ('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(c)) {
                  traceName += ' ';
                }
                traceName += c.toLowerCase();
              }
              return traceName;
            },
            params: [],
            ret: (macro :String)
          }),
        pos: Context.currentPos()
      });

    fields.push(
      {
        name: 'ignoreBuiltInEntry',
        access: [Access.APrivate],
        kind: FieldType.FFun(
          {
            args: [
              {
                name: 'builtInEntryName',
                type: (macro :String)
              }
            ],
            expr: macro
            {
              return
                 builtInEntryName == $v{entryClsTypeName}
              || builtInEntryName == $v{scriptedEntryClsTypeName};
            },
            params: [],
            ret: (macro :Bool)
          }),
        pos: Context.currentPos()
      });

    fields.push(
    {
      name: 'listScriptedClasses',
      access: [Access.APrivate],
      kind: FieldType.FFun(
        {
          args: [],
          expr: macro
          {
            return [];
            // return ${scriptedEntryExpr}.listScriptClasses();
          },
          params: [],
          ret: (macro :Array<String>)
        }),
      pos: Context.currentPos()
    });

    fields.push(
      {
        name: 'getBuiltInEntries',
        access: [Access.APrivate],
        kind: FieldType.FFun(
          {
            args: [],
            expr: macro
            {
              return ClassMacro.listSubclassesOf($entryExpr);
            },
            params: [],
            ret: ComplexType.TPath(
              {
                pack: [],
                name: 'List',
                params: [
                  TypeParam.TPType(
                    ComplexType.TPath(
                      {
                        pack: [],
                        name: 'Class',
                        params: [
                          TypeParam.TPType(
                            ComplexType.TPath(
                              {
                                pack: entryClsType.pack,
                                name: entryClsType.name
                              }
                            )
                          )
                        ]
                      }
                    )
                  )
                ]
              }
            )
          }),
        pos: Context.currentPos()
      });

    fields.push(
      {
        name: 'createScriptedEntry',
        access: [Access.APrivate],
        kind: FieldType.FFun(
          {
            args: [
              {
                name: 'id',
                type: (macro :String)
              }
            ],
            expr: macro
            {
              return null;
              // return ${scriptedEntryExpr}.init(id, 'UNKNOWN', 'UNKNOWN');
            },
            params: [],
            ret: ComplexType.TPath(
              {
                pack: [],
                name:'Null',
                params: [
                  TypeParam.TPType(
                    ComplexType.TPath(
                      {
                        pack: entryClsType.pack,
                        name: entryClsType.name
                      }
                    )
                  )
                ]
              }
            )
          }),
        pos: Context.currentPos()
      });

    return fields;
  }
}
