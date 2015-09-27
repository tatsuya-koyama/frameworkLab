package tart.components {

    import flash.geom.Rectangle;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    import tart.components.Transform;
    import tart.core.Component;
    import tart.core.TartContext;

    public class View2D extends Component {

        public var offsetX:Number;
        public var offsetY:Number;
        public var anchorX:Number;
        public var anchorY:Number;

        private var _transform:Transform;

        // This is abstract component, you cannot attach this.
        public override function getClass():Class {
            return null;
        }

        public function View2D() {
            offsetX = 0;
            offsetY = 0;
            anchorX = 0.5;
            anchorY = 0.5;
        }

        // Override in subclasses
        public function get display():DisplayObject {
            return null;
        }

        public function get transform():Transform {
            if (!_transform) {
                _transform = getComponent(Transform) as Transform;
            }
            return _transform;
        }

        protected function _makeImage(texture:Texture,
                                      width:Number=NaN, height:Number=NaN,
                                      offsetX:Number=0, offsetY:Number=0,
                                      anchorX:Number=0.5, anchorY:Number=0.5):Image
        {
            var image:Image = new Image(texture);
            if (!isNaN(width )) { image.width  = width;  }
            if (!isNaN(height)) { image.height = height; }
            image.x = offsetX;
            image.y = offsetY;
            _setImagePivot(image, texture, anchorX, anchorY);
            return image;
        }

        // Image の中心点を設定（座標指定と回転軸に影響）
        protected function _setImagePivot(image:Image, texture:Texture,
                                        anchorX:Number, anchorY:Number):void
        {
            // care about texture atlas
            var textureRect:Rectangle = texture.frame;
            if (textureRect) {
                image.pivotX = textureRect.width  * anchorX;
                image.pivotY = textureRect.height * anchorY;
            } else {
                image.pivotX = texture.width  * anchorX;
                image.pivotY = texture.height * anchorY;
            }
        }

        protected function _makeTextField(text:String, width:Number, height:Number,
                                          offsetX:Number=0, offsetY:Number=0,
                                          anchorX:Number=0.5, anchorY:Number=0.5):TextField
        {
            var textField:TextField = new TextField(width, height, text);
            _setTextPivot(textField, width, height, anchorX, anchorY);
            return textField;
        }

        protected function _setTextPivot(text:TextField, width:Number, height:Number,
                                       anchorX:Number, anchorY:Number):void
        {
            text.pivotX = width  * anchorX;
            text.pivotY = height * anchorY;
        }

    }
}
