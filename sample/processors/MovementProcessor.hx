package processors;

import baldrick.Processor;
import baldrick.View;
import components.Position;
import components.Velocity;

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