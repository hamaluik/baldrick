package components;

import baldrick.Component;
import baldrick.storage.VecStorage;

class Position implements Component {
    public var x:Float = 0.0;
    public var y:Float = 0.0;
    
    public static var storage:VecStorage<Position> = new VecStorage<Position>();
}