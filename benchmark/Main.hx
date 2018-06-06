import baldrick.Component;
import baldrick.Entity;
import baldrick.Processor;
import baldrick.View;
import baldrick.Universe;
import baldrick.storage.ArrayStorage;
import baldrick.storage.VecStorage;
import baldrick.storage.HashMapStorage;
import haxe.Timer;

class PositionComp implements Component {
    public static var storage:VecStorage<PositionComp> = new VecStorage<PositionComp>();

    public var x:Float = 0;
    public var y:Float = 0;
}

class VelocityComp implements Component {
    public static var storage:VecStorage<VelocityComp> = new VecStorage<VelocityComp>();

    public var x:Float = 0;
    public var y:Float = 0;
}

class MovementProcessor implements Processor {
    var movingEntities:View;

    public function new(universe:Universe) {
        movingEntities = universe.registerView(function(entity):Bool {
            return PositionComp.storage.has(entity)
                && VelocityComp.storage.has(entity);
        });
    }

    public function process():Void {
        for(entity in movingEntities) {
            var pos = PositionComp.storage.get(entity);
            var vel = VelocityComp.storage.get(entity);
            
            pos.x += vel.x * (1 / 60);
            pos.y += vel.y * (1 / 60);
        }
    }
}

class Main {
    static function measure(activity:Void->Void):Float {
        var start:Float = Timer.stamp();
        activity();
        return Timer.stamp() - start;
    }

    public static function main() {
        var universe:Universe = new Universe();
        var movement:MovementProcessor = new MovementProcessor(universe);
        
        var numEntities:Int = 10000;
        trace('Measuring time to create ${numEntities} entities...');
        var createTime:Float = measure(function() {
            for(i in 0...numEntities) {
                var entity:Entity = universe.createEntity();
                PositionComp.storage.addTo(universe, entity, false);
                VelocityComp.storage.addTo(universe, entity, false);
                universe.onComponentsAdded(entity);
            }
        });
        trace('Took ${createTime} s (${createTime * 1000000 / numEntities}) us/entity');

        var numProcesses:Int = 10000;
        trace('Measuring time to process ${numProcesses} times...');
        var processTime:Float = measure(function() {
            for(i in 0...numProcesses) {
                movement.process();
            }
        });
        trace('Took ${processTime} s (${processTime * 1000000 / numProcesses}) us/process');
    }
}