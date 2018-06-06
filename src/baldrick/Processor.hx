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
}