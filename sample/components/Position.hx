package components;

import baldrick.Component;

class Position implements Component {
    public var x:Float = 0.0;
    public var y:Float = 0.0;

    public function new(x:Float, y:Float) {
        this.x = x;
        this.y = y;
    }

    public inline function typeID():Int { return 0; }
}