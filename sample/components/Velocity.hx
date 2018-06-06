package components;

import baldrick.Component;
import baldrick.storage.HashMapStorage;

class Velocity implements Component {
    public var vx:Float = 0.0;
    public var vy:Float = 0.0;

    public static var storage:HashMapStorage<Velocity> = new HashMapStorage<Velocity>();
}