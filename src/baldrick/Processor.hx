package baldrick;

/**
  Interface for a processor ('system').
  
  An auto-build macro will auto-generate the `match` and `unmatch`
  functions if they aren't defined in by the implementing class.
*/
@:autoBuild(baldrick.macros.ProcessorMacros.process())
@:allow(baldrick.Phase)
#if (turnip && !display)
@:autoBuild(baldrick.macros.Turnip.dumpProcessor())
#end
interface Processor {
    /**
      The `match` function is responsible for maintaining the state
      of all `View` variables in the processor
      @param entity the entity to check `View`s against
    */
    private function match(entity:Entity):Void;

    /**
      The `unmatch` function is responsible for force-removing
      entities from all `View`s which are watching it
      @param entity the entity to remove from `View`s
    */
    private function unmatch(entity:Entity):Void;

    /**
      Called automatically by `Phase`s to process everything
      in the `View`s. Application logic goes here.
    */
    public function process():Void;

    #if profiling
    /**
      The fully-qualified name of the processor to be used when profiling

      **Note:** only generated when `profiling` is defined
    */
    public var profileName(default, null):String;

    /**
      The execution time of the process as determinged by the profiler

      **Note:** only generated when `profiling` is defined
    */
    public var profileTime(default, null):Float;

    /**
      Call `process()` with auto-calculation of the profiling time

      **Note:** only generated when `profiling` is defined
    */
    public function profileProcess():Void;
    #end
}