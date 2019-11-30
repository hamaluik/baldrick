package resources;

import baldrick.Resource;

class TimeDelta implements Resource {
    public var delta: Float;

    public function new(delta: Float) {
        this.delta = delta;
    }
}