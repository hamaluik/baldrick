package baldrick;

//@:generic
//class ResourceView<T: Resource> {
//    public var resource: T;
//    public function new() {}
//}

@:generic
@:forward
abstract ResourceView<T: Resource>(T) from T to T {
    public function new() {
        this = null;
    }
}