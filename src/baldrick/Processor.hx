package baldrick;

/**
  Interface for a processor ('system').
*/
interface Processor {
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