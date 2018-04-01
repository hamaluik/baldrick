package baldrick;

import haxe.ds.IntMap;

/**
  A group of `Component` instances representing a discrete object
*/
class Entity {
    private static var _nextId = 0;
    /**
      An auto-generated unique ID
    */
    public var id(default, null):Int;
    private var Universe:Universe;

    private var components:IntMap<Component> = new IntMap<Component>();

    public function new(Universe:Universe, ?components:Array<Component>) {
        this.Universe = Universe;
        id = _nextId;
        _nextId++;
        Universe.entities.push(this);
        if(components != null) addMany(components);
    }

    /**
      Shortcut for accessing the entity ID

      (allows Entities to be used in `HashMap`s)
      @return Int
    */
    public inline function hashCode():Int {
        return id;
    }

    /**
      Add a single component, triggering the auto-match
      @param component the component to add
      @return Entity
    */
    public inline function add(component:Component):Entity {
        components.set(component.hashCode(), component);
        Universe.match(this);
        return this;
    }

    /**
      Add several components at once, triggering the auto-match only once
      @param components The components to add
      @return Entity
    */
    public inline function addMany(components:Array<Component>):Entity {
        for(c in components) this.components.set(c.hashCode(), c);
        Universe.match(this);
        return this;
    }

    /**
      Checks to see if the entity has a type of component
      @param type The type to check. Can be queried at runtime
      using `Component.HashCode()` (`HashCode` is auto-generated).
      @return Bool
    */
    public inline function has(type:ComponentTypeID):Bool {
        return components.exists(type);
    }

    /**
      Gets the component with a specific type id
      @param type The type id to query with
      @return T
    */
    public inline function get<T:Component>(type:ComponentTypeID):T {
        return cast(components.get(type));
    }

    /**
      Remove a single component from the entity, if it exists
      @param component The component to remove
      @return Entity
    */
    public inline function remove(component:Component):Entity {
        components.remove(component.hashCode());
        Universe.match(this);
        return this;
    }

    /**
      Remove several components from the entity, if they exist
      @param components The components to remove
      @return Entity
    */
    public inline function removeMany(components:Array<Component>):Entity {
        for(c in components) this.components.remove(c.hashCode());
        Universe.match(this);
        return this;
    }

    /**
      Remove a component by its type ID, if it exists
      @param type The type ID to remove
      @return Entity
    */
    public inline function removeByType(type:ComponentTypeID):Entity {
        components.remove(type);
        Universe.match(this);
        return this;
    }

    /**
      Remove several components from the entity, if they exist
      @param types The type IDs to remove
      @return Entity
    */
    public inline function removeManyByType(types:Array<ComponentTypeID>):Entity {
        for(t in types) components.remove(t);
        Universe.match(this);
        return this;
    }

    /**
      Destroy this entity & remove it from the Universe & all processors
    */
    public inline function destroy():Void {
        Universe.entities.remove(this);
        Universe.unmatch(this);
    }
}