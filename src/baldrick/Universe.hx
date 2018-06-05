package baldrick;

/**
  A group of `Entity`s and the `Processor`s that are used
  to process them in different phases.
*/
@:allow(baldrick.Entity)
class Universe {
    /**
     *  All the components
     */
    public var components:Array<Storage<Component>>;

    /**
      The processor phases that belong to this universe
    */
    public var phases:Array<Phase>;

    private var entityExistence:Array<Bool>;

    public function new() {
        this.components = new Array<Storage<Component>>();
        this.entityExistence = new Array<Bool>();
        this.phases = new Array<Phase>();
    }

    // TODO: get type id from component type in a macro?
    @:generic
    public function registerComponentType<T>(type:ComponentType, storage:Storage<Component>):Void {
        while(type >= components.length) {
            components.push(null);
        }
        components[type] = storage;
    }

    /**
      Construct a new entity
      @param components An optional list of starting components
      @return Entity
    */
    public function createEntity(?components:Array<Component>):Entity {
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
            addComponents(newEntityID, components);
        }

        return newEntityID;
    }

    public function destroyEntity(entity:Entity):Void {
        if(entity < entityExistence.length) {
            entityExistence[entity] = false;
        }
    }

    public function addComponent(entity:Entity, component:Component):Void {
        this.components[component.typeID()].set(entity, component);
    }

    public function addComponents(entity:Entity, components:Array<Component>):Void {
        for(component in components) {
            this.components[component.typeID()].set(entity, component);
        }
    }

    public function hasComponent(entity:Entity, type:ComponentType):Bool {
        return this.components[type].has(entity);
    }

    public function removeComponent(entity:Entity, type:ComponentType):Void {
        this.components[type].unset(entity);
    }

    public function removeComponents(entity:Entity, types:Array<ComponentType>):Void {
        for(type in types) {
            this.components[type].unset(entity);
        }
    }
}
