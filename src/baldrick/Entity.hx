package baldrick;

import haxe.ds.IntMap;
import haxe.Serializer;
import haxe.Unserializer;

/**
  A group of `Component` instances representing a discrete object
*/
@:allow(baldrick.Universe)
class Entity {
    private static var _nextId = 0;
    /**
      An auto-generated unique ID
    */
    public var id(default, null):Int;
    private var universe:Universe;

    private var components:IntMap<Component> = new IntMap<Component>();

    public function new(universe:Universe, ?components:Array<Component>) {
        this.universe = universe;
        id = _nextId;
        _nextId++;
        universe.entities.push(this);
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
        universe.match(this);
        return this;
    }

    /**
      Add several components at once, triggering the auto-match only once
      @param components The components to add
      @return Entity
    */
    public inline function addMany(components:Array<Component>):Entity {
        for(c in components) this.components.set(c.hashCode(), c);
        universe.match(this);
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
        universe.match(this);
        return this;
    }

    /**
      Remove several components from the entity, if they exist
      @param components The components to remove
      @return Entity
    */
    public inline function removeMany(components:Array<Component>):Entity {
        for(c in components) this.components.remove(c.hashCode());
        universe.match(this);
        return this;
    }

    /**
      Remove a component by its type ID, if it exists
      @param type The type ID to remove
      @return Entity
    */
    public inline function removeByType(type:ComponentTypeID):Entity {
        components.remove(type);
        universe.match(this);
        return this;
    }

    /**
      Remove several components from the entity, if they exist
      @param types The type IDs to remove
      @return Entity
    */
    public inline function removeManyByType(types:Array<ComponentTypeID>):Entity {
        for(t in types) components.remove(t);
        universe.match(this);
        return this;
    }

    /**
      Destroy this entity & remove it from the universe & all processors
    */
    public inline function destroy():Void {
        universe.entities.remove(this);
        universe.unmatch(this);
    }

    @:keep
    private function hxSerialize(s:Serializer):Void {
        s.serialize(id);
        s.serialize(components);
    }

    @:keep
    private function hxUnserialize(u:Unserializer):Void {
        id = u.unserialize();
        components = u.unserialize();
    }
}