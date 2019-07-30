using buddy.Should;
using Lambda;
import baldrick.Universe;
import baldrick.Phase;
import baldrick.Component;
import baldrick.Resource;
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

class ResA implements Resource {
    public var i: Int;
    public function new(i: Int) { this.i = i; }
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

class CProcessor implements Processor {
    var cs:View<{c:CompC}>;

    public function process():Void {
        for(c in cs) {
            c.data.c.c += ".";
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
            it("should auto-generate unique-per-type processor IDs", {
                var ab:ABProcessor = new ABProcessor();
                var c:CProcessor = new CProcessor();
                ab.hashCode().should.not.be(c.hashCode());
            });

            it("should generate the same ID between instances of the same processor", {
                var ab:ABProcessor = new ABProcessor();
                var ab2:ABProcessor = new ABProcessor();
                ab.hashCode().should.be(ab2.hashCode());
            });

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
                var universe:Universe = new Universe();
                var e1:Entity = new Entity(universe, [
                    new CompA(4.2),
                    new CompB(42)
                ]);
                var e2:Entity = new Entity(universe, [
                    new CompC('derp')
                ]);
                p.match(e1);
                p.match(e2);
                
                p.ents.count().should.be(1);
            });

            it("its match function should work with multiple dinstinct views", {
                var p:ABProcessor = new ABProcessor();
                var universe:Universe = new Universe();
                var e1:Entity = new Entity(universe, [
                    new CompA(4.2),
                    new CompB(42)
                ]);
                var e2:Entity = new Entity(universe, [
                    new CompC('derp')
                ]);
                p.match(e1);
                p.match(e2);
                p.ents.count().should.be(1);
                p.otherEnts.count().should.be(1);
            });
        });

        describe("using an universe", {
            it("should auto-match on entity creation/addition", {
                var universe:Universe = new Universe();
                var phase1:Phase = universe.createPhase();
                var p:ABProcessor = new ABProcessor();
                phase1.addProcessor(p);
                var compA:CompA = new CompA(4.2);
                var compB:CompB = new CompB(42);
                var e:Entity = universe.createEntity([compA, compB]);
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
                processors.length.should.be(2);
                processors.indexOf("ABProcessor").should.not.be(-1);
                processors.indexOf("CProcessor").should.not.be(-1);
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

        describe("saving and loading entity states", {
            var universe:Universe;

            beforeAll({
                universe = new Universe();
                var phase1:Phase = universe.createPhase();
                var p:ABProcessor = new ABProcessor();
                phase1.addProcessor(p);
                var compA:CompA = new CompA(4.2);
                var compB:CompB = new CompB(42);
                var e:Entity = universe.createEntity([compA, compB]);
            });

            it("should serialize the entities into a string", {
                var state:String = universe.saveEntities();
                state.should.not.be(null);
                (state.length > 0).should.be(true);
            });

            it("should unserialize from a string", {
                var state:String = universe.saveEntities();
                universe.destroyAllEntities();
                universe.entities.length.should.be(0);
                universe.loadEntities(state);
                universe.entities.length.should.be(1);
                var ca:CompA = universe.entities[0].get(CompA.HashCode());
                ca.a.should.be(4.2);
                var cb:CompB = universe.entities[0].get(CompB.HashCode());
                cb.b.should.be(42);
            });
        });

        describe("using resources", {
            var universe: Universe;

            beforeAll({
                universe = new Universe();
            });

            it("should return null when a resource hasn't been registered / set", {
                var res: ResA = universe.getResource(ResA);
                res.should.be(null);
            });

            it("should allow you to set and get a resource by its ID", {
                universe.setResource(new ResA(42));
                var res: ResA = universe.getResourceByID(ResA.HashCode());
                res.should.not.be(null);
                res.i.should.be(42);
            });

            it("should only keep track of a single resource per type", {
                universe.setResource(new ResA(42));
                universe.setResource(new ResA(30));
                var res: ResA = universe.getResource(ResA);
                res.should.not.be(null);
                res.i.should.be(30);
            });
        });
    }
}