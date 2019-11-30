package processors;

import baldrick.Processor;
import baldrick.View;
import baldrick.ResourceView;
import components.Position;
import components.Velocity;
import resources.TimeDelta;

class MovementProcessor implements Processor {
    var moving:View<{pos:Position, vel:Velocity}>;
    var timeDelta: ResourceView<TimeDelta>;

    public function process():Void {
        for(view in moving) {
            view.data.pos.x += view.data.vel.vx * timeDelta.resource.delta;
            view.data.pos.y += view.data.vel.vy * timeDelta.resource.delta;
        }
    }
}