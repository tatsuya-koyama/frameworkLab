package tart.components {

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class Sprite2D extends View2D {

        private var _sprite:Sprite;

        public override function getClass():Class {
            return Sprite2D;
        }

        public function Sprite2D() {

        }

        public override function get display():DisplayObject {
            return _sprite;
        }

        public function get sprite():Sprite {
            return _sprite;
        }

        public function init(parent:DisplayObjectContainer):void {
            _sprite = new Sprite();
            parent.addChild(_sprite);
        }

        public function addImage(texture:Texture,
                                 width:Number=NaN, height:Number=NaN,
                                 offsetX:Number=0, offsetY:Number=0,
                                 anchorX:Number=0.5, anchorY:Number=0.5):Image
        {
            if (!_sprite) {
                throw new Error("Sprite not initialized.");
            }

            var image:Image = _makeImage(
                texture, width, height, offsetX, offsetY, anchorX, anchorY
            );
            _sprite.addChild(image);
            return image;
        }

    }
}
