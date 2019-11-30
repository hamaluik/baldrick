package baldrick;

@:generic
class ResourceView<T: Resource> {
    public var resource: T;
    public function new() {}
}
