using buddy.Should;
using Lambda;
import baldrick.Universe;
import baldrick.Phase;
import baldrick.Component;
import baldrick.Entity;
import baldrick.Processor;
import baldrick.View;

class CompA implements Component {
    public var a:Float;
    public function new(a:Float) { this.a = a; }
}

class CompB implements Component {
    public var b:Int;
    public function new(b:Int) { this.b = b; }
}

class CompC implements Component {
    public var c:String;
    public function new(c:String) { this.c = c; }
}

class ABProcessor implements Processor {
    var ents:View<{a:CompA, b:CompB}>;
    var otherEnts:View<{c:CompC}>;

    public function process():Void {
        for(ent in ents) {
            ent.data.b.b = Math.floor(ent.data.a.a * ent.data.a.a);
        }
    }
}

@:access(baldrick.View)
@:access(ABProcessor)
class TestMain extends buddy.SingleSuite {
    public function new() {
        describe('Using components', {
            it("should auto-generate unique-per-type component IDs", {
                var a:CompA = new CompA(4.2);
                var b:CompB = new CompB(42);
                a.hashCode().should.not.be(b.hashCode());
            });

            it("should generate the same ID between instances of the same component", {
                var a:CompA = new CompA(4.2);
                var aa:CompA = new CompA(42.42);
                aa.hashCode().should.be(a.hashCode());
            });
        });

        describe("using processors", {
            it("should build a match function", {
                var p:ABProcessor = new ABProcessor();
                var e:Entity = new Entity(new Universe(), [
                    new CompA(4.2),
                    new CompB(42)
                ]);

                p.match(e);
            });
            
            it("its match function should remove component views", {
                var p:ABProcessor = new ABProcessor();
                var e1:Entity = new Entity(new Universe(), [
                    new CompA(4.2),
                    new CompB(42)
                ]);
                p.match(e1);
                p.ents.count().should.be(1);
                e1.removeByType(CompA.HashCode());
                p.match(e1);
                p.ents.count().should.be(0);
            });

            it("its match function should add component views", {
                var p:ABProcessor = new ABProcessor();
                var Universe:Universe = new Universe();
                var e1:Entity = new Entity(Universe, [
                    new CompA(4.2),
                    new CompB(42)
                ]);
                var e2:Entity = new Entity(Universe, [
                    new CompC('derp')
                ]);
                p.match(e1);
                p.match(e2);
                
                p.ents.count().should.be(1);
            });

            it("its match function should work with multiple dinstinct views", {
                var p:ABProcessor = new ABProcessor();
                var Universe:Universe = new Universe();
                var e1:Entity = new Entity(Universe, [
                    new CompA(4.2),
                    new CompB(42)
                ]);
                var e2:Entity = new Entity(Universe, [
                    new CompC('derp')
                ]);
                p.match(e1);
                p.match(e2);
                p.ents.count().should.be(1);
                p.otherEnts.count().should.be(1);
            });
        });

        describe("using an Universe", {
            it("should auto-match on entity creation/addition", {
                var Universe:Universe = new Universe();
                var phase1:Phase = Universe.createPhase();
                var p:ABProcessor = new ABProcessor();
                phase1.addProcessor(p);
                var compA:CompA = new CompA(4.2);
                var compB:CompB = new CompB(42);
                var e:Entity = Universe.createEntity([compA, compB]);
                phase1.process();
                compB.b.should.be(17);
            });
        });

        describe("using turnip", {
            it("should generate the turnip.json file", {
                #if sys
                sys.FileSystem.exists('turnip.json').should.be(true);
                #end
            });

            it("should write an array of the processors to the file", {
                #if sys
                var turnip:Dynamic = haxe.Json.parse(sys.io.File.getContent('turnip.json'));
                var processors:Array<String> = turnip.processors;
                processors.should.not.be(null);
                processors.length.should.be(1);
                processors[0].should.be("ABProcessor");
                #end
            });

            it("should write components to the file", {
                #if sys
                var turnip:Dynamic = haxe.Json.parse(sys.io.File.getContent('turnip.json'));
                var components:Array<{
                    name:String,
                    properties: {
                        name:String,
                        type:String,
                        def:Dynamic
                    }
                }> = turnip.components;
                components.should.not.be(null);
                components.length.should.be(3);
                Lambda.exists(components, function(c) {
                    return c.name == "CompA";
                }).should.be(true);
                #end
            });
        });
    }
}