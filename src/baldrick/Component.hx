package baldrick;

/**
  A component which only stores data but does not contain
  any logic (beyond initialization)
*/
@:autoBuild(baldrick.macros.ComponentMacros.process())
interface Component {
    /**
      The unique type ID for the component class

      **Note:** also generated is a static function
      `HashCode()` with the same signature and function.
      @return ComponentTypeID
    */
    public function hashCode():ComponentTypeID;
}