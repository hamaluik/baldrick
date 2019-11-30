package processors;

import baldrick.Processor;
import baldrick.View;
import baldrick.ResourceView;
import components.Position;
import resources.TimeDelta;

@:allow(processors.PrintProcessor)
class PrintStep implements baldrick.Resource {
    var step: Int = 0;
    public function new() {}
}

class PrintProcessor implements Processor {
    var prints:View<{pos:Position}>;
    var printStep: ResourceView<PrintStep>;
    var timeDelta: ResourceView<TimeDelta>;

    public function new(universe: baldrick.Universe) {
        universe.setResource(new PrintStep());
        this.prints = new View();
        this.printStep = new ResourceView();
        this.timeDelta = new ResourceView();
    }

    public function process():Void {
        trace('Step ${printStep.step}');
        trace('Time delta: ${timeDelta.delta}');

        for(view in prints) {
            trace('Entity ' + view.entity.hashCode() + ' position: (' + view.data.pos.x + ', ' + view.data.pos.y + ')');
        }

        printStep.step += 1;
    }
}