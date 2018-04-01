package baldrick;

/**
  A collection of processors which will be processed
  together in a single `process` call.
*/
@:allow(baldrick.Universe)
class Phase {
    private var Universe:Universe;

    /**
      The processors grouped in this phase
    */
    public var processors:Array<Processor>;

    public function new(Universe:Universe) {
        this.Universe = Universe;
        processors = new Array<Processor>();
        Universe.phases.push(this);
    }

    private function match(entity:Entity):Void {
        for(processor in processors) {
            processor.match(entity);
        }
    }

    private function unmatch(entity:Entity):Void {
        for(processor in processors) {
            processor.unmatch(entity);
        }
    }

    /**
      Call `process` on all grouped processors
    */
    public function process():Void {
        for(processor in processors) {
            processor.process();
        }
    }

    /**
      Add a processor to this phase
      @param processor the processor to add
      @return Phase
    */
    public function addProcessor(processor:Processor):Phase {
        processors.push(processor);
        for(entity in Universe.entities) {
            processor.match(entity);
        }
        return this;
    }
}