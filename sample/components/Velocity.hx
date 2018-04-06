package components;

import baldrick.Component;

class Velocity implements Component {
    public var vx:Float;
    public var vy:Float;

    public function new(vx:Float, vy:Float) {
        this.vx = vx;
        this.vy = vy;
    }
}