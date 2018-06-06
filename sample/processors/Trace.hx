package processors;

import baldrick.Processor;
import baldrick.View;
import baldrick.Universe;

class Trace implements Processor {
    var myEnts:View;

    public function new(universe:Universe) {
        myEnts = universe.registerView(function(entity):Bool {
            return components.Position.storage.has(entity);
        });
    }

    public function process():Void {
        for(ent in myEnts) {
            var pos = components.Position.storage.get(ent);
            trace('$ent: (${pos.x}, ${pos.y})');
        }
    }
}