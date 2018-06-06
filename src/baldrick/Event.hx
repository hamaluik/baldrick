package baldrick;

@:generic
abstract Event<T>(Array<T->Void>) {
    public function new() {
        this = new Array<T->Void>();
    }

    inline public function subscribe(callback:T->Void):Void {
        this.push(callback);
    }

    inline public function unsubscribe(callback:T->Void):Void {
        this.remove(callback);
    }

    inline public function invoke(arg:T):Void {
        for(cb in this) {
            cb(arg);
        }
    }
}