package tart.components {

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.textures.Texture;

    import tart.components.Transform;
    import tart.core.Component;

    public class Image2D extends Component implements IView2D {

        private var _image:Image;

        public override function getClass():Class {
            return Image2D;
        }

        public function Image2D() {

        }

        public function get display():DisplayObject {
            return _image;
        }

        public function get transform():Transform {
            return getComponent(Transform) as Transform;
        }

        public function get image():Image {
            return _image;
        }

        public function init(parent:DisplayObjectContainer, texture:Texture):void {
            _image = new Image(texture);
            parent.addChild(_image);
        }

    }
}
