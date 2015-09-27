package tart.components {

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.textures.Texture;

    public class Image2D extends View2D {

        private var _image:Image;

        public override function getClass():Class {
            return Image2D;
        }

        public function Image2D() {

        }

        public override function get display():DisplayObject {
            return _image;
        }

        public function get image():Image {
            return _image;
        }

        public function init(parent:DisplayObjectContainer, texture:Texture,
                             width:Number=NaN, height:Number=NaN,
                             offsetX:Number=0, offsetY:Number=0,
                             anchorX:Number=0.5, anchorY:Number=0.5):void
        {
            _image = _makeImage(
                texture, width, height, offsetX, offsetY, anchorX, anchorY
            );
            this.offsetX = offsetX;
            this.offsetY = offsetY;
            this.anchorX = anchorX;
            this.anchorY = anchorY;

            parent.addChild(_image);
        }

    }
}
