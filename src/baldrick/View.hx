package baldrick;

@:allow(baldrick.Universe)
class View {
    var universe:Universe;
    var entities:Array<Entity>;
    var matcher:Entity->Bool;

    public var onEntityTrackedEvent:Event<Entity>;
    public var onEntityUntrackedEvent:Event<Entity>;

    function new(universe:Universe, matcher:Entity->Bool) {
        this.universe = universe;
        this.matcher = matcher;
        entities = new Array<Entity>();
        onEntityTrackedEvent = new Event<Entity>();
        onEntityUntrackedEvent = new Event<Entity>();

        for(i in 0...universe.entityExistence.length) {
            if(universe.entityExistence[i] && matcher(i)) {
                entities.push(i);
            }
        }
    }

    function onEntityCreated(entity:Entity):Void {
        if(matcher(entity)) {
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

        if(matcher(entity)) {
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

        if(!matcher(entity)) {
            if(entities.remove(entity)) {
                onEntityUntrackedEvent.invoke(entity);
            }
        }
    }

    inline public function iterator():Iterator<Entity> {
        return entities.iterator();
    }
}