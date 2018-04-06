package baldrick.macros;

#if (turnip && !display)
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.ExprTools;

typedef ComponentProperty = {
    name:String,
    type:String,
    def:String
};

class Turnip {
    private static var firstRun:Bool = true;

    macro public static function dumpComponent():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        var turnip:Dynamic = getDumpFile();
        if(!Reflect.hasField(turnip, 'components')) {
            turnip.components = {};
        }

        var properties:Array<ComponentProperty> = new Array<ComponentProperty>();
        for(field in fields) {
            if(!isPublic(field) || hasSkipMeta(field) || !isVariable(field)) {
                continue;
            }

            var type:Null<String> = varType(field);
            if(type == null) {
                continue;
            }

            var def:Dynamic = defaultValue(field);

            properties.push({
                name: field.name,
                type: type,
                def: def
            });
        }

        var pack:String = Context.getLocalClass().get().pack.join(".");
        var fqn:String = pack + (pack.length > 0 ? "." : "") + Context.getLocalClass().get().name;
        Reflect.setField(turnip.components, fqn, properties);
        ensureVersion(turnip);
        sys.io.File.saveContent('turnip.json', haxe.Json.stringify(turnip, null, "  "));

        return fields;
    }

    macro public static function dumpProcessor():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        var turnip:Dynamic = getDumpFile();
        if(!Reflect.hasField(turnip, 'processors')) {
            turnip.processors = new Array<String>();
        }

        var pack:String = Context.getLocalClass().get().pack.join(".");
        var fqn:String = pack + (pack.length > 0 ? "." : "") + Context.getLocalClass().get().name;
        if(!Lambda.exists(turnip.processors, function(efqn:String):Bool return fqn == efqn)) {
            turnip.processors.push(fqn);
        }
        ensureVersion(turnip);
        sys.io.File.saveContent('turnip.json', haxe.Json.stringify(turnip, null, "  "));
        
        return fields;
    }

    private static function isPublic(field:Field):Bool {
        for(access in field.access) {
            switch(access) {
                case Access.APublic: return true;
                default:
            }
        }
        return false;
    }

    private static function hasSkipMeta(field:Field):Bool {
        if(field.meta == null) {
            return false;
        }
        for(meta in field.meta) {
            if(meta.name == 'internal') {
                return true;
            }
        }
        return false;
    }

    private static function isVariable(field:Field):Bool {
        return switch(field.kind) {
            case FieldType.FVar(_): true;
            default: false;
        }
    }

    private static function varType(field:Field):Null<String> {
        switch(field.kind) {
            case FieldType.FVar(t, e): {
                switch(t) {
                    case ComplexType.TPath(p): {
                        return switch(p.name) {
                            case 'Float': 'float';
                            case 'String': 'string';
                            case 'Int': 'int';
                            case 'Bool': 'bool';
                            case 'Vec2': 'vec2';
                            case 'Vec3': 'vec3';
                            case 'Vec4': 'vec4';
                            case 'Quat': 'quat';
                            case 'Mat2': 'mat3';
                            case 'Mat3': 'mat3';
                            case 'Mat4': 'mat4';
                            case 'Colour', 'Color': 'colour';
                            // TODO: more types: component references, etc
                            default: null;
                        }
                    }

                    default: {
                        return null;
                    }
                }
            }
            default: {
                return null;
            }
        }
        return null;
    }

    private static function defaultValue(field:Field):Dynamic {
        return switch(field.kind) {
            case FieldType.FVar(t, e): if(e != null) e.getValue(); else null;
            default: null;
        }
    }

    private static function ensureVersion(turnip:Dynamic):Dynamic {
        if(Reflect.hasField(turnip, 'version')) {
            return turnip;
        }
        turnip.version = {};
        
        var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
        if(process.exitCode() != 0) {
            // not a git repo!
            turnip.version.githash = null;
        }
        else {
            var commitHash:String = process.stdout.readLine();
            turnip.version.githash = commitHash;
        }

        turnip.version.timestamp = DateTools.format(Date.now(), '%FT%TZ');
        turnip.version.turnip = 1;

        return turnip;
    }

    private static function getDumpFile():Dynamic {
        if(firstRun) {
            firstRun = false;
            if(sys.FileSystem.exists('turnip.json')) {
                sys.FileSystem.deleteFile('turnip.json');
            }
            return {};
        }
        
        if(sys.FileSystem.exists('turnip.json')) {
            return haxe.Json.parse(sys.io.File.getContent('turnip.json'));
        }
        return {};
    }
}
#end