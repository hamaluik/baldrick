package baldrick;

/**
  A utility class which stores an entity and the entitie's type-matched
  components, as defined by the user in `View`
*/
class ViewData<T:{}> {
    /**
      The entity the components in `data` belong to
    */
    public var entity(default, null):Entity;

    /**
      The anonymous structure defining the components to access
    */
    public var data(default, null):T;

    public function new(entity:Entity, data:T) {
        this.entity = entity;
        this.data = data;
    }
}
