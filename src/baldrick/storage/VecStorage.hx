package baldrick.storage;

import haxe.Constraints;
import haxe.ds.Vector;
import baldrick.Universe;
import baldrick.Component;
import baldrick.Storage;
import baldrick.Entity;

@:generic
class VecStorage<T:(Component, Constructible<Void->Void>)> implements Storage<T> {
    private var vec:Vector<T>;

    public function new(size:Int = 1024) {
        vec = new Vector<T>(size);
    }

    function upSize():Void {
        var newVec:Vector<T> = new Vector<T>(vec.length * 2);
        Vector.blit(vec, 0, newVec, 0, vec.length);
        vec = newVec;
    }

    public function has(entity:Entity):Bool {
        return vec[entity] != null;
    }

    public function get(entity:Entity):T {
        return vec[entity];
    }

    public function addTo(universe:Universe, entity:Entity):T {
        if(entity >= vec.length) {
            upSize();
        }
        vec[entity] = new T();
        universe.onComponentsAdded(entity);
        return vec[entity];
    }

    public function removeFrom(universe:Universe, entity:Entity):Void {
        var existed:Bool = has(entity);
        vec[entity] = null;
        if(existed) {
            universe.onComponentsRemoved(entity);
        }
    }
}