import baldrick.Universe;
import baldrick.Phase;

class Main {
    public static function main() {
        var universe:Universe = new Universe();
        universe.registerComponentType(components.Position.TypeID(), components.Position.storage());
    }
}