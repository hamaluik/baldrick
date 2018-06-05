package baldrick.storage;

import baldrick.Storage;
import baldrick.Entity;
import haxe.ds.Vector;

@:generic
class VecStorage<ComponentType> implements Storage<ComponentType> {
    private var vec:Vector<ComponentType>;

    public function new(size:Int = 1024) {
        vec = new Vector<ComponentType>(size);
    }

    public function set(entity:Entity, component:ComponentType):Void {
        if(entity >= vec.length) {
            upSize();
        }
        vec[entity] = component;
    }

    public function unset(entity:Entity):Void {
        vec[entity] = null;
    }

    public function has(entity:Entity):Bool {
        return vec[entity] != null;
    }

    function upSize():Void {
        var newVec:Vector<ComponentType> = new Vector<ComponentType>(vec.length * 2);
        Vector.blit(vec, 0, newVec, 0, vec.length);
        vec = newVec;
    }
}