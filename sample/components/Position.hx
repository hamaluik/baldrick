package components;

import baldrick.Component;

class Position implements Component {
    public var x:Float = 0.0;
    public var y:Float = 0.0;

    public function new() {}

    public inline function typeID():Int { return 0; }
    public inline static function TypeID():Int { return 0; }
    public inline static function storage() { return new baldrick.storage.VecStorage<Position>(); }
}