package baldrick.storage;

import baldrick.Storage;
import haxe.ds.IntMap;

@:generic
class HashMapStorage<ComponentType> implements Storage<ComponentType> {
    private var map:IntMap<ComponentType>;

    public function new() {
        map = new IntMap<ComponentType>();
    }

    public function set(entity:Entity, component:ComponentType):Void {
        map.set(entity, component);
    }

    public function unset(entity:Entity):Void {
        map.remove(entity);
    }

    public function has(entity:Entity):Bool {
        return map.exists(entity);
    }
}