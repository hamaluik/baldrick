import baldrick.Universe;
import baldrick.Phase;

class Main {
    public static function main() {
        var universe:Universe = new Universe();
        
        var ball = universe.createEntity();
        var pos = components.Position.storage.addTo(universe, ball);
        pos.x = 128;
        var vel = components.Velocity.storage.addTo(universe, ball);
        vel.vy = 8;

        var updatePhase:Phase = new Phase();
        updatePhase.addProcessor(new processors.Movement(universe));
        
        var renderPhase:Phase = new Phase();
        renderPhase.addProcessor(new processors.Trace(universe));

        // display the results!
        renderPhase.process();
        updatePhase.process();
        renderPhase.process();
    }
}