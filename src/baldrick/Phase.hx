package baldrick;

/**
  A collection of processors which will be processed
  together in a single `process` call.
*/
@:allow(baldrick.Universe)
class Phase {
    /**
      The processors grouped in this phase
    */
    public var processors:Array<Processor>;

    public function new() {
        processors = new Array<Processor>();
    }

    /**
      Call `process` on all grouped processors
    */
    public function process(universe:Universe):Void {
        for(processor in processors) {
            processor.process(universe);
        }
    }

    /**
      Add a processor to this phase
      @param processor the processor to add
      @return Phase
    */
    public function addProcessor(processor:Processor):Phase {
        processors.push(processor);
        return this;
    }
}