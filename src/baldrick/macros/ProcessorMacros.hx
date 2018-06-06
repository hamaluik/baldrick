package baldrick.macros;

import haxe.macro.Expr;
import haxe.macro.Context;

class ProcessorMacros {
    macro public static function process():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        var hasMatchField:Bool = false;
        var hasUnmatch:Bool = false;
        var hasConstructor:Bool = false;
        for(field in fields) {
            if(field.name == 'match') {
                hasMatchField = true;
            }
            else if(field.name == 'unmatch') {
                hasUnmatch = true;
            }
            else if(field.name == 'new') {
                hasConstructor = true;
            }
        }

        if(!hasMatchField) {
            fields = injectMatch(fields);
        }

        if(!hasUnmatch) {
            fields = injectUnmatch(fields);
        }

        if(!hasConstructor) {
            fields = injectConstructor(fields);
        }

        #if profiling
        fields = injectProfiling(fields);
        #end

        return fields;
    }

    #if !display
    private static function getVarFieldTypeName(field:Field):String {
        return switch(field.kind) {
            case FieldType.FVar(t, e): {
                switch(t) {
                    case ComplexType.TPath(p): p.name;
                    default: null;
                }
            }
            default: null;
        }
    }

    private static function getVarFieldComplexType(field:Field):ComplexType {
        return switch(field.kind) {
            case FieldType.FVar(t, e): t;
            default: null;
        };
    }

    private static function addBinopCheck(binop:Binop, exprs:Array<Expr>):Expr {
        if(exprs.length == 0) {
            return macro false;
        }
        if(exprs.length == 1) {
            return exprs[0];
        }

        var firstExpr:Expr = exprs[0];
        exprs.remove(firstExpr);
        return {
            expr: EBinop(binop, firstExpr, addBinopCheck(binop, exprs)),
            pos: Context.currentPos()
        };
    }
    #end

    private static function injectMatch(fields:Array<Field>):Array<Field> {
        var body:Array<Expr> = [];
        // BEGIN INDENT HELL
        #if !display
        for(field in fields) {
            switch(field.kind) {
                case FieldType.FVar(t, e): {
                    switch(t) {
                        case ComplexType.TPath(p): {
                            if(p.name == 'View') {
                                for(param in p.params) {
                                    switch(param) {
                                        case TypeParam.TPType(ct): {
                                            switch(ct) {
                                                case TAnonymous(tFields): {
                                                    // figure out the anonymous type of the object
                                                    var ifNotHasExprs:Array<Expr> = [];
                                                    var ifHasExprs:Array<Expr> = [];
                                                    var objExprs:Array<ObjectField> = [];
                                                    for(tField in tFields) {
                                                        var compClassName:String = getVarFieldTypeName(tField);
                                                        var compClassID:Int = ComponentMacros.getTypeID(compClassName);
                                                        ifNotHasExprs.push(macro !entity.has($v{compClassID}));
                                                        ifHasExprs.push(macro entity.has($v{compClassID}));
                                                        objExprs.push({
                                                            field: tField.name,
                                                            expr: {
                                                                expr: ECast(macro entity.get($v{compClassID}), getVarFieldComplexType(tField)),
                                                                pos: Context.currentPos()
                                                            }
                                                        });
                                                    }

                                                    // build an expression that looks like:
                                                    //      if(!entity.has(CompA.HashCode()) || !entity.has(CompB.HashCode())) {
                                                    //          ents.matches.remove(entity);
                                                    //      }
                                                    var ifNotTest:Expr = addBinopCheck(Binop.OpBoolOr, ifNotHasExprs);
                                                    var ifNotExpr:Expr = {
                                                        expr: EIf(ifNotTest, macro {
                                                            $i{field.name}.remove(entity);
                                                        }, null),
                                                        pos: Context.currentPos()
                                                    };
                                                    body.push(ifNotExpr);

                                                    // build an expression that looks like:
                                                    //      if(entity.has(CompA.HashCode()) && entity.has(CompB.HashCode())) {
                                                    //          ents.matches.set(entity, new ViewData(entity, { a: entity.get(CompA.HashCode(), b: entity.get(CompB.HashCode()) }));
                                                    //      }
                                                    var ifAndTest:Expr = addBinopCheck(Binop.OpBoolAnd, ifHasExprs);
                                                    var objDecl:Expr = {
                                                        expr: EObjectDecl(objExprs),
                                                        pos: Context.currentPos()
                                                    };
                                                    var ifExpr:Expr = {
                                                        expr: EIf(ifAndTest, macro {
                                                            $i{field.name}.set(entity, ${objDecl});
                                                        }, null),
                                                        pos: Context.currentPos()
                                                    };
                                                    body.push(ifExpr);
                                                }
                                                default: {}
                                            }
                                        }
                                        default: {}
                                    }
                                }
                            }
                        }
                        default: {}
                    }
                }
                default: {}
            };
        }
        #end

        var matchField:Field = {
            name: 'match',
            access: [Access.APrivate, Access.AInline],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated function responsible for matching entities',
            kind: FieldType.FFun({
                args: [{
                    name: 'entity',
                    meta: null,
                    opt: false,
                    value: null,
                    type: ComplexType.TPath({
                        name: 'Entity',
                        pack: ['baldrick'],
                        params: null,
                        sub: null
                    })
                }],
                params: null,
                expr: macro $b{body},
                ret: ComplexType.TPath({
                    name: 'Void',
                    pack: [],
                    params: null,
                    sub: null
                })
            })
        };
        fields.push(matchField);
        
        return fields;
    }

    private static function injectUnmatch(fields:Array<Field>):Array<Field> {
        var viewRemoves:Array<Expr> = [];
        #if !display
        for(field in fields) {
            switch(field.kind) {
                case FieldType.FVar(t, e): {
                    switch(t) {
                        case ComplexType.TPath(p): {
                            if(p.name == 'View') {
                                viewRemoves.push(macro $i{field.name}.remove(entity));
                            }
                        }
                        default: {}
                    }
                }
                default: {}
            }
        }
        #end

        fields.push({
            name: 'unmatch',
            access: [Access.APrivate],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated method to forcibly remove an entity',
            kind: FieldType.FFun({
                args: [{
                    name: 'entity',
                    meta: null,
                    opt: false,
                    value: null,
                    type: ComplexType.TPath({
                        name: 'Entity',
                        pack: ['baldrick'],
                        params: null,
                        sub: null
                    })
                }],
                params: null,
                expr: macro $b{viewRemoves},
                ret: ComplexType.TPath({
                    name: 'Void',
                    pack: [],
                    params: null,
                    sub: null
                })
            })
        });

        return fields;
    }

    private static function injectConstructor(fields:Array<Field>):Array<Field> {
        var initializers:Array<Expr> = [];
        #if !display
        for(field in fields) {
            switch(field.kind) {
                case FieldType.FVar(t, e): {
                    switch(t) {
                        case ComplexType.TPath(p): {
                            if(p.name == 'View') {
                                initializers.push(macro $i{field.name} = new View());
                            }
                        }
                        default: {}
                    }
                }
                default: {}
            }
        }
        #end

        fields.push({
            name: 'new',
            access: [Access.APublic],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated constructor, initialized all views',
            kind: FieldType.FFun({
                args: [],
                params: null,
                ret: null,
                expr: macro $b{initializers}
            })
        });

        return fields;
    }

    #if profiling
    private static function injectProfiling(fields:Array<Field>):Array<Field> {
        fields.push({
            name: 'profileName',
            access: [Access.APublic],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated variable holding the class name of this processor',
            kind: FieldType.FProp("default", "null", macro:String, macro $v{Context.getLocalClass().get().pack.join(".") + "." + Context.getLocalClass().get().name})
        });

        fields.push({
            name: 'profileTime',
            access: [Access.APublic],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated variable holding the timing information',
            kind: FieldType.FProp("default", "null", macro:Float)
        });

        var profileFunc:Function = {
            expr: macro {
                var fStart:Float = haxe.Timer.stamp();
                process();
                profileTime = haxe.Timer.stamp() - fStart;
            },
            ret: macro:Void,
            args:[]
        };

        fields.push({
            name: 'profileProcess',
            access: [Access.APublic, Access.AInline],
            meta: null,
            pos: Context.currentPos(),
            doc: 'Auto-generated function for profiling the process function',
            kind: FieldType.FFun(profileFunc)
        });

        return fields;
    }
    #end
}
