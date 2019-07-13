package baldrick.macros;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.ds.StringMap;

import baldrick.ResourceTypeID;

@:allow(baldrick.macros.ProcessorMacros)
class ResourceMacros {
    private static var nextResourceTypeID:ResourceTypeID = 0;
    private static var resourceTypeMap:StringMap<ResourceTypeID> = new StringMap<ResourceTypeID>();

    macro public static function process():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        var typeID:ResourceTypeID = getTypeID(Context.getLocalClass().get().name);
        var kind:FieldType = FieldType.FFun({
            args: [],
            params: null,
            expr: macro { return $v{typeID}; },
            ret: ComplexType.TPath({
                name: 'ResourceTypeID',
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
            doc: 'Auto-generated resource type ID',
            kind: kind
        };
        fields.push(hashCodeField);

        var staticHashCodeField:Field = {
            name: 'HashCode',
            access: [Access.APublic, Access.AStatic, Access.AInline],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated resource type ID',
            kind: kind
        };
        fields.push(staticHashCodeField);

        return fields;
    }

    private static function getTypeID(className:String):ResourceTypeID {
        #if display
        return 0;
        #else
        if(resourceTypeMap.exists(className)) {
            return resourceTypeMap.get(className);
        }

        resourceTypeMap.set(className, nextResourceTypeID);
        nextResourceTypeID++;
        return nextResourceTypeID - 1;
        #end
    }
}