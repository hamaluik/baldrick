package baldrick;

import haxe.Constraints;

@:allow(baldrick.View)
class Universe {
    var phases:Array<Phase>;
    var components:Array<Storage<Component>>;
    private var entityExistence:Array<Bool>;
    private var views:Array<View>;

    public function new() {
        this.phases = new Array<Phase>();
        this.components = new Array<Storage<Component>>();
        this.entityExistence = new Array<Bool>();
        this.views = new Array<View>();
    }

    // TODO: get type id from component type in a macro?
    // TODO: auto-call this function from somewhere using a macro
    public function registerComponentType(type:ComponentType, storage:Storage<Component>):Void {
        while(type >= components.length) {
            components.push(null);
        }
        components[type] = storage;
    }

    public function registerView(requiredTypes:Array<ComponentType>):Void {
        views.push(new View(this, requiredTypes));
    }

    /**
      Construct a new entity
      @param components An optional list of starting components
      @return Entity
    */
    public function createEntity(?types:Array<ComponentType>):Entity {
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

        if(components != null) {
            addComponents(newEntityID, types);
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

    public function hasComponent(entity:Entity, type:ComponentType):Bool {
        return this.components[type].has(entity);
    }

    // TODO: get type id from component type in a macro?
    @:generic
    public function getComponentUnsafe<T:Component>(entity:Entity, type:ComponentType):T {
        return cast(components[type].get(entity));
    }

    // TODO: auto-calculate the typeID at compile time
    @:generic
    public function addComponent<T:Component>(entity:Entity, type:ComponentType):T {
        var comp:Component = this.components[type].create(entity);
        for(view in views) {
            view.onComponentsAdded(entity);
        }
        return cast(comp);
    }

    public function addComponents(entity:Entity, types:Array<ComponentType>):Void {
        for(type in types) {
            this.components[type].create(entity);
        }
        for(view in views) {
            view.onComponentsAdded(entity);
        }
    }

    public function removeComponent(entity:Entity, type:ComponentType):Void {
        this.components[type].destroy(entity);
        for(view in views) {
            view.onComponentsRemoved(entity);
        }
    }

    public function removeComponents(entity:Entity, types:Array<ComponentType>):Void {
        for(type in types) {
            this.components[type].destroy(entity);
        }
        for(view in views) {
            view.onComponentsRemoved(entity);
        }
    }
}
