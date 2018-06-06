package baldrick;

@:allow(baldrick.Universe)
class View {
    var universe:Universe;
    // TODO: more fine-grained selectors?
    var requiredTypes:Array<ComponentType>;
    var entities:Array<Entity>;

    public var onEntityTrackedEvent:Event<Entity>;
    public var onEntityUntrackedEvent:Event<Entity>;

    function new(universe:Universe, requiredTypes:Array<ComponentType>) {
        this.universe = universe;
        this.requiredTypes = requiredTypes;
        entities = new Array<Entity>();
        onEntityTrackedEvent = new Event<Entity>();
        onEntityUntrackedEvent = new Event<Entity>();
    }

    function matches(entity:Entity):Bool {
        for(type in requiredTypes) {
            if(!universe.components[type].has(entity)) {
                // we have a required type that the entity does not have
                // don't add it to our array
                return false;
            }
        }
        return true;
    }

    function onEntityCreated(entity:Entity):Void {
        if(matches(entity)) {
            entities.push(entity);
            onEntityTrackedEvent.invoke(entity);
        }
    }

    function onEntityDestroyed(entity:Entity):Void {
        if(entities.remove(entity)) {
            onEntityUntrackedEvent.invoke(entity);
        }
    }

    function onComponentsAdded(entity:Entity):Void {
        if(entities.indexOf(entity) != -1) {
            // we are already tracking the entity and a new component was added
            // this won't change our tracking status
            return;
        }

        if(matches(entity)) {
            entities.push(entity);
            onEntityTrackedEvent.invoke(entity);
        }
    }

    function onComponentsRemoved(entity:Entity):Void {
        if(entities.indexOf(entity) == -1) {
            // we already weren't tracking the entity, so removing a component
            // won't change our tracking status
            return;
        }

        if(!matches(entity)) {
            if(entities.remove(entity)) {
                onEntityUntrackedEvent.invoke(entity);
            }
        }
    }

    inline public function iterator():Iterator<Entity> {
        return entities.iterator();
    }
}