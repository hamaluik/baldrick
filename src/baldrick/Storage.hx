package baldrick;

@:generic
interface Storage<ComponentType> {
    public function set(entity:Entity, component:ComponentType):Void;
    public function unset(entity:Entity):Void;
    public function has(entity:Entity):Bool;
}