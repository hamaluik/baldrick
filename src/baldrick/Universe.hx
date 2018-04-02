package baldrick;

/**
  A group of `Entity`s and the `Processor`s that are used
  to process them in different phases.
*/
@:allow(baldrick.Entity)
class Universe {
    /**
      The entities that belong to this universe
    */
    public var entities:Array<Entity>;

    /**
      The processor phases that belong to this universe
    */
    public var phases:Array<Phase>;

    public function new() {
        this.entities = new Array<Entity>();
        this.phases = new Array<Phase>();
    }

    private function match(entity:Entity):Void {
        for(phase in phases) {
            phase.match(entity);
        }
    }

    private function unmatch(entity:Entity):Void {
        for(phase in phases) {
            phase.unmatch(entity);
        }
    }

    /**
      Construct a new entity
      @param components An optional list of starting components
      @return Entity
    */
    public function createEntity(?components:Array<Component>):Entity {
        return new Entity(this, components);
    }

    /**
      Destroys an entity, removing it entirely from this `Universe`
      @param entity The entity to destroy
    */
    public function destroyEntity(entity:Entity) {
        entity.destroy();
    }

    /**
      Construct a phase, adding it to this Universe
      @return Phase
    */
    public function createPhase():Phase {
        return new Phase(this);
    }

    /**
      Unmatch and delete all entities from this universe
    */
    public function destroyAllEntities():Void {
        for(entity in entities) {
            unmatch(entity);
        }
        entities = new Array<Entity>();
    }
}
