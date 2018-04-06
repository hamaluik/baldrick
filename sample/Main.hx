import baldrick.Universe;
import baldrick.Phase;
import components.*;
import processors.*;

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
        
        #if profiling
        var physicsTime:Float = 0;
        var renderTime:Float = 0;
        #end
        for(i in 0...5) {
            physics.process();
            render.process();

            #if profiling
            physicsTime += physics.profileTime;
            renderTime += render.profileTime;
            #end
        }

        #if profiling
        physicsTime /= 5;
        renderTime /= 5;
        trace('Average physics time: ' + Math.round(physicsTime * 1000 * 100) / 100 + ' ms');
        trace('Average render time: ' + Math.round(renderTime * 1000 * 100) / 100 + ' ms');

        trace('Processor times');
        trace(physics.processorTimes);
        trace(render.processorTimes);
        #end
    }
}