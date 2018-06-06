package baldrick.storage;

import haxe.Constraints;
import haxe.ds.Vector;
import baldrick.Component;
import baldrick.Storage;
import baldrick.Entity;

@:generic
class VecStorage<T:(Component, Constructible<Void->Void>)> implements Storage<T> {
    private var vec:Vector<T>;

    public function new(size:Int = 1024) {
        vec = new Vector<T>(size);
    }

    public function has(entity:Entity):Bool {
        return vec[entity] != null;
    }

    public function get(entity:Entity):T {
        return vec[entity];
    }

    public function create(entity:Entity):T {
        if(entity >= vec.length) {
            upSize();
        }
        vec[entity] = new T();
        return vec[entity];
    }

    public function destroy(entity:Entity):Void {
        vec[entity] = null;
    }

    function upSize():Void {
        var newVec:Vector<T> = new Vector<T>(vec.length * 2);
        Vector.blit(vec, 0, newVec, 0, vec.length);
        vec = newVec;
    }
}