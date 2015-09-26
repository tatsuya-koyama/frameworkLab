package tart.components {

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;

    import tart.components.Transform;
    import tart.core.Component;

    public class Sprite2D extends Component implements IView2D {

        private var _sprite:Sprite;

        public override function getClass():Class {
            return Sprite2D;
        }

        public function Sprite2D() {

        }

        public function get display():DisplayObject {
            return _sprite;
        }

        public function get transform():Transform {
            return getComponent(Transform) as Transform;
        }

        public function get sprite():Sprite {
            return _sprite;
        }

        public function init(parent:DisplayObjectContainer):void {
            _sprite = new Sprite();
            parent.addChild(_sprite);
        }

    }
}
