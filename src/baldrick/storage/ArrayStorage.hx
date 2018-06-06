package baldrick.storage;

import haxe.Constraints;
import baldrick.Universe;
import baldrick.Component;
import baldrick.Storage;
import baldrick.Entity;

@:generic
class ArrayStorage<T:(Component, Constructible<Void->Void>)> implements Storage<T> {
    private var vec:Array<T>;

    public function new() {
        vec = new Array<T>();
    }

    public function has(entity:Entity):Bool {
        return vec[entity] != null;
    }

    public function get(entity:Entity):T {
        return vec[entity];
    }

    public function addTo(universe:Universe, entity:Entity, notifyUniverse:Bool=true):T {
        if(entity >= vec.length) {
            vec.push(new T());
        }
        else {
            vec[entity] = new T();
        }
        if(notifyUniverse) {
            universe.onComponentsAdded(entity);
        }
        return vec[entity];
    }

    public function removeFrom(universe:Universe, entity:Entity, notifyUniverse:Bool=true):Void {
        var existed:Bool = has(entity);
        vec[entity] = null;
        if(notifyUniverse && existed) {
            universe.onComponentsRemoved(entity);
        }
    }

    public function storageSize():Int {
         return vec.length;
    }
}