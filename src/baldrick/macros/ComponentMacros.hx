package baldrick.macros;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.ds.StringMap;

import baldrick.ComponentTypeID;

@:allow(baldrick.macros.ProcessorMacros)
class ComponentMacros {
    private static var nextComponentTypeID:ComponentTypeID = 0;
    private static var componentTypeMap:StringMap<ComponentTypeID> = new StringMap<ComponentTypeID>();

    macro public static function process():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        var typeID:ComponentTypeID = getTypeID(Context.getLocalClass().get().name);
        var kind:FieldType = FieldType.FFun({
            args: [],
            params: null,
            expr: macro { return $v{typeID}; },
            ret: ComplexType.TPath({
                name: 'ComponentTypeID',
                pack: ['baldrick'],
                params: null,
                sub: null
            })
        });

        var hashCodeField:Field = {
            name: 'hashCode',
            access: [Access.APublic, Access.AInline],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated component type ID',
            kind: kind
        };
        fields.push(hashCodeField);

        var staticHashCodeField:Field = {
            name: 'HashCode',
            access: [Access.APublic, Access.AStatic, Access.AInline],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated component type ID',
            kind: kind
        };
        fields.push(staticHashCodeField);

        return fields;
    }

    private static function getTypeID(className:String):ComponentTypeID {
        #if display
        return 0;
        #else
        if(componentTypeMap.exists(className)) {
            return componentTypeMap.get(className);
        }

        componentTypeMap.set(className, nextComponentTypeID);
        nextComponentTypeID++;
        return nextComponentTypeID - 1;
        #end
    }
}