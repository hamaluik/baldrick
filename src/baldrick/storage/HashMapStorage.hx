package baldrick.storage;

import haxe.ds.IntMap;
import haxe.Constraints;
import baldrick.Component;
import baldrick.Storage;

@:generic
class HashMapStorage<T:(Component, Constructible<Void->Void>)> implements Storage<T> {
    private var map:IntMap<T>;

    public function new() {
        map = new IntMap<T>();
    }

    public function has(entity:Entity):Bool {
        return map.exists(entity);
    }

    public function get(entity:Entity):T {
        return map.get(entity);
    }

    public function create(entity:Entity):T {
        map.set(entity, new T());
        return map.get(entity);
    }

    public function destroy(entity:Entity):Void {
        map.remove(entity);
    }
}