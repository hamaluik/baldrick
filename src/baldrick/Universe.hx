package baldrick;

@:allow(baldrick.View, baldrick.Storage)
class Universe {
    private var entityExistence:Array<Bool>;
    private var views:Array<View>;

    public function new() {
        this.entityExistence = new Array<Bool>();
        this.views = new Array<View>();
    }

    public function registerView(matcher:Entity->Bool):View {
        var newView:View = new View(this, matcher);
        views.push(newView);
        return newView;
    }

    public function createEntity():Entity {
        var newEntityID:Entity = -1;
        for(i in 0...entityExistence.length) {
            if(!entityExistence[i]) {
                newEntityID = i;
                break;
            }
        }
        if(newEntityID < 0) {
            newEntityID = entityExistence.length;
            entityExistence.push(true);
        }
        else {
            entityExistence[newEntityID] = true;
        }

        for(view in views) {
            view.onEntityCreated(newEntityID);
        }

        return newEntityID;
    }

    public function destroyEntity(entity:Entity):Void {
        if(entity < entityExistence.length) {
            if(entityExistence[entity]) {
                for(view in views) {
                    view.onEntityDestroyed(entity);
                }
            }

            entityExistence[entity] = false;
        }
    }

    inline function onComponentsAdded(entity:Entity):Void {
        for(view in views) {
            view.onComponentsAdded(entity);
        }
    }

    inline function onComponentsRemoved(entity:Entity):Void {
        for(view in views) {
            view.onComponentsRemoved(entity);
        }
    }
}
