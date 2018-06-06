package baldrick;

@:generic
interface Storage<T:Component> {
    public function has(entity:Entity):Bool;
    public function get(entity:Entity):T;
    public function create(entity:Entity):T;
    public function destroy(entity:Entity):Void;
}