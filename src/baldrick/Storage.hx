package baldrick;

import haxe.Constraints;

@:generic
interface Storage<T:Constructible<Void->Void>> {
    public function has(entity:Entity):Bool;
    public function get(entity:Entity):T;
    public function addTo(universe:Universe, entity:Entity):T;
    public function removeFrom(universe:Universe, entity:Entity):Void;
}