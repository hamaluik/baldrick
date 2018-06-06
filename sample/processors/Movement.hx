package processors;

import baldrick.Processor;
import baldrick.Universe;
import baldrick.View;

class Movement implements Processor {
    var myEnts:View;

    public function new(universe:Universe) {
        myEnts = universe.registerView(function(entity):Bool {
            return components.Position.storage.has(entity)
                && components.Velocity.storage.has(entity);
        });
    }

    public function process():Void {
        for(ent in myEnts) {
            trace('processing movement on entity ' + ent);
            var pos = components.Position.storage.get(ent);
            var vel = components.Velocity.storage.get(ent);

            pos.x += vel.vx * (1 / 60);
            pos.y += vel.vy * (1 / 60);
        }
    }
}