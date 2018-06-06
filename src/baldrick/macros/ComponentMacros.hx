package baldrick.macros;

import haxe.macro.Expr;
import haxe.macro.Context;

class ComponentMacros {
    macro public static function ensureConstructor():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        for(field in fields) {
            if(field.name == 'new') {
                return fields;
            }
        }

        fields.push({
            name: 'new',
            access: [Access.APublic],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated constructor',
            kind: FieldType.FFun({
                args: [],
                params: null,
                ret: null,
                expr: macro {}
            })
        });

        return fields;
    }
}