package baldrick;

import haxe.ds.HashMap;

/**
  Represents an array of entities matched to a specific typed group of components in
  a `Processor`.

  Use in a `Processor` as follows:

  ```haxe
  class MyProcess implements Processor {
      var myView:View<{a:ComponentA, b:ComponentB}>;

      public function process() {
          for(view in myView) {
              trace(view.entity);
              trace(view.data.a);
              trace(view.data.b);
          }
      }
  }
  ```
*/
class View<T:{}> {
    private var matches:HashMap<Entity, ViewData<T>> = new HashMap<Entity, ViewData<T>>();
    public function new() {}

    /**
      Iterate over the matched data views
      @return Iterator<ViewData<T>>
    */
    public inline function iterator():Iterator<ViewData<T>> {
        return matches.iterator();
    }

    /**
      Make this view match an entity with the corresponding data.
      **Note:** this is generally only ever called in the auto-generated
      `match` function of the `Processor`
      @param entity The entity we're matching against
      @param data An anonymous structure which matches the components this view cares about
    */
    public function set(entity:Entity, data:T):Void {
        matches.set(entity, new ViewData(entity, data));
    }

    /**
      Remove this entity from the view match if it exists.
      **Note:** this is generally only ever called in the auto-generated
      `match` and `unmatch` functions of the `Processor`
      @param entity The entity we're removing from this match
    */
    public function remove(entity:Entity):Void {
        matches.remove(entity);
    }
}
