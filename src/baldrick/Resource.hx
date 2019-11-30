package baldrick;

/**
  A component which only stores data but does not contain
  any logic (beyond initialization). It differs from components
  in that there can only ever be a single resource of each type
  in a universe at once.
*/
@:autoBuild(baldrick.macros.ResourceMacros.process())
interface Resource {
    /**
      The unique type ID for the resource class

      **Note:** also generated is a static function
      `HashCode()` with the same signature and function.
      @return ResourceTypeID
    */
    public function hashCode():ResourceTypeID;
}