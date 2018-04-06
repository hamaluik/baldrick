package processors;

import baldrick.Processor;
import baldrick.View;
import components.Position;

class PrintProcessor implements Processor {
    var prints:View<{pos:Position}> = new View<{pos:Position}>();
    public function new(){}

    public function process():Void {
        for(view in prints) {
            trace('Entity ' + view.entity.hashCode() + ' position: (' + view.data.pos.x + ', ' + view.data.pos.y + ')');
        }
    }
}