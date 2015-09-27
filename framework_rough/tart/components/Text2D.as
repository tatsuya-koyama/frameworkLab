package tart.components {

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.text.TextField;

    public class Text2D extends View2D {

        private var _textField:TextField;

        public override function getClass():Class {
            return Text2D;
        }

        public function Text2D() {

        }

        public override function get display():DisplayObject {
            return _textField;
        }

        public function get textField():TextField {
            return _textField;
        }

        public function init(parent:DisplayObjectContainer,
                             text:String, width:Number, height:Number,
                             offsetX:Number=0, offsetY:Number=0,
                             anchorX:Number=0.5, anchorY:Number=0.5):void
        {
            _textField = _makeTextField(
                text, width, height, offsetX, offsetY, anchorX, anchorY
            );
            this.offsetX = offsetX;
            this.offsetY = offsetY;
            this.anchorX = anchorX;
            this.anchorY = anchorY;

            parent.addChild(_textField);
        }

    }
}
