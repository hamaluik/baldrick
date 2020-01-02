package baldrick;

/**
  A collection of processors which will be processed
  together in a single `process` call.
*/
@:allow(baldrick.Universe)
class Phase {
    private var universe:Universe;

    /**
      The processors grouped in this phase
    */
    public var processors:Array<Processor>;

    #if profiling
    /**
      The total time taken to run this phase

      **Note:** only generated when `profiling` is defined
    */
    public var profileTime(default, null):Float = 0.0;
    
    /**
      The times of each individual processor

      **Note:** only generated when `profiling` is defined
    */
    public var processorTimes(default, null):haxe.ds.StringMap<Float> = new haxe.ds.StringMap<Float>();
    #end

    public function new(universe:Universe) {
        this.universe = universe;
        processors = new Array<Processor>();
        universe.phases.push(this);
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
        #if profiling
        var startT:Float = haxe.Timer.stamp();
        #end
        for(processor in processors) {
            #if profiling
            processor.profileProcess();
            processorTimes.set(processor.profileName, processor.profileTime);
            #else
            processor.process();
            #end
        }
        #if profiling
        profileTime = haxe.Timer.stamp() - startT;
        #end
    }

    /**
      Add a processor to this phase
      @param processor the processor to add
      @return Phase
    */
    public function addProcessor(processor:Processor):Phase {
        processors.push(processor);
        for(entity in universe.entities) {
            processor.match(entity);
        }
        applyResources();
        return this;
    }

    /**
      Remove a processor from this phase
      @param processor the processor to remove
      @return Phase
     */
    public function removeProcessor(processor:Processor):Phase {
        for(entity in universe.entities) {
            processor.unmatch(entity);
        }
        processors.remove(processor);
        return this;
    }

    public function removeProcessorByType(pid:ProcessorTypeID):Phase {
        var processor:Processor = null;
        for(p in processors) {
            if(p.hashCode() == pid) {
                processor = p;
                break;
            }
        }
        if(processor == null) {
            return this;
        }

        return removeProcessor(processor);
    }

    private function applyResources() {
        for(processor in processors) {
            processor.setResources(universe);
        }
    }
}