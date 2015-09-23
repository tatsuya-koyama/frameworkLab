package game.entities {

    import tart.components.Actor;
    import tart.components.Transform;
    import tart.components.View2D;
    import tart.components.View3D;
    import tart.core.Entity;

    public class Piyo extends Actor {

        public function Piyo() {

        }

        public static function create():Entity {
            var entity:Entity = new Entity();
            entity.attachComponent(new Piyo());
            entity.attachComponent(new Transform());
            entity.attachComponent(new View2D());
            return entity;
        }

        public override function awake():void {
            trace("::: awake:", transform); ////////////// debug
        }

    }
}
