import baldrick.Universe;
import baldrick.Phase;
import baldrick.Component;
import baldrick.Entity;
import baldrick.Processor;
import baldrick.View;

class Position implements Component {
    public var x:Float;
    public var y:Float;

    public function new(x:Float, y:Float) {
        this.x = x;
        this.y = y;
    }
}

class Velocity implements Component {
    public var vx:Float;
    public var vy:Float;

    public function new(vx:Float, vy:Float) {
        this.vx = vx;
        this.vy = vy;
    }
}

class MovementProcessor implements Processor {
    var moving:View<{pos:Position, vel:Velocity}> = new View<{pos:Position, vel:Velocity}>();

    public function new(){}

    public function process():Void {
        for(view in moving) {
            view.data.pos.x += view.data.vel.vx * (1.0 / 60.0);
            view.data.pos.y += view.data.vel.vy * (1.0 / 60.0);
        }
    }
}

class PrintProcessor implements Processor {
    var prints:View<{pos:Position}> = new View<{pos:Position}>();
    public function new(){}

    public function process():Void {
        for(view in prints) {
            trace('Entity ' + view.entity.hashCode() + ' position: (' + view.data.pos.x + ', ' + view.data.pos.y + ')');
        }
    }
}

class Main {
    public static function main() {
        var Universe:Universe = new Universe();
        var physics:Phase = Universe.createPhase();
        var render:Phase = Universe.createPhase();
        physics.addProcessor(new MovementProcessor());
        render.addProcessor(new PrintProcessor());

        Universe.createEntity([
            new Position(0, 0),
            new Velocity(1.0, -0.5)
        ]);
        
        for(i in 0...5) {
            physics.process();
            render.process();
        }
    }
}