package baldrick;

/**
  A collection of processors which will be processed
  together in a single `process` call.
*/
class Phase {
    var processors:Array<Processor>;

    public function new() {
        processors = new Array<Processor>();
    }

    /**
      Call `process` on all grouped processors
    */
    inline public function process():Void {
        for(processor in processors) {
            processor.process();
        }
    }

    /**
      Add a processor to this phase
      @param processor the processor to add
      @return Phase
    */
    inline public function addProcessor(processor:Processor):Phase {
        processors.push(processor);
        return this;
    }
}