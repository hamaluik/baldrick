import baldrick.Component;
import baldrick.Entity;
import baldrick.Processor;
import baldrick.View;
import baldrick.Universe;
import haxe.Timer;

class Position implements Component {
    public var x:Float = 0;
    public var y:Float = 0;

    public function new() {}
}

class Velocity implements Component {
    public var x:Float = 0;
    public var y:Float = 0;

    public function new() {}
}

class Movement implements Processor {
    var movingEntities:View<{pos:Position, vel:Velocity}> = new View<{pos:Position, vel:Velocity}>();

    public function process():Void {
        for(entity in movingEntities) {
            var pos = entity.data.pos;
            var vel = entity.data.vel;
            
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
        var movement:Movement = new Movement();
        
        var numEntities:Int = 1000000;
        trace('Measuring time to create ${numEntities} entities...');
        var createTime:Float = measure(function() {
            for(i in 0...numEntities) {
                universe.createEntity([
                    new Position(),
                    new Velocity()
                ]);
            }
        });
        trace('Took ${createTime} s (${createTime * 1000000 / numEntities}) us/entity');

        var numProcesses:Int = 1000000;
        trace('Measuring time to process ${numProcesses} times...');
        var processTime:Float = measure(function() {
            for(i in 0...numProcesses) {
                movement.process();
            }
        });
        trace('Took ${processTime} s (${processTime * 1000000 / numProcesses}) us/process');
    }
}
