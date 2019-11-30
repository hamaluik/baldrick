import baldrick.Universe;
import baldrick.Phase;
import components.*;
import processors.*;
import resources.*;

class Main {
    public static function main() {
        var universe:Universe = new Universe();
        var physics:Phase = universe.createPhase();
        var render:Phase = universe.createPhase();
        physics.addProcessor(new MovementProcessor());
        render.addProcessor(new PrintProcessor());

        universe.setResource(new TimeDelta(1.0 / 60.0));

        universe.createEntity([
            new Position(0, 0),
            new Velocity(1.0, -0.5)
        ]);
        
        // demo processing & profiling
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

        // demo serialization
        var saveState:String = universe.saveEntities();
        trace('Saving entities state: ' + saveState);

        universe.destroyAllEntities();
        trace('Destroyed all entities: ' + universe.entities);

        trace('Loading entities state...');
        var result:LoadResult = universe.loadEntities(saveState);
        if(result.match(LoadResult.VersionMismatch)) {
            trace('WARNING: Version mismatch in saved entity state!');
        }

        for(i in 0...5) {
            physics.process();
            render.process();
        }
    }
}