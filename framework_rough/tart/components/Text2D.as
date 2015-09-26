package tart.components {

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.text.TextField;

    import tart.components.Transform;
    import tart.core.Component;

    public class Text2D extends Component implements IView2D {

        private var _text:TextField;

        public override function getClass():Class {
            return Text2D;
        }

        public function Text2D() {

        }

        public function get display():DisplayObject {
            return _text;
        }

        public function get transform():Transform {
            return getComponent(Transform) as Transform;
        }

        public function get text():TextField {
            return _text;
        }

        public function init(parent:DisplayObjectContainer,
                             width:Number, height:Number, text:String):void
        {
            _text = new TextField(width, height, text);
            parent.addChild(_text);
        }

    }
}
