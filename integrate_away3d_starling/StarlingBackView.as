package {

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class StarlingBackView extends Sprite {

        [Embed(source="./piyo.png")]
        public static var PiyoImg:Class;

        public function StarlingBackView() {
            _addText();
            _addImage();
        }

        private function _addText():void {
            var textField:TextField = new TextField(500, 100, "This image is powered by Starling");
            textField.x        = 420;
            textField.y        = 100;
            textField.fontSize = 25;
            textField.color    = 0x888888;
            textField.hAlign   = HAlign.LEFT;
            textField.vAlign   = VAlign.TOP;
            addChild(textField);

            var gudeText:TextField = new TextField(700, 100, "(Rendered behind Away3D layer)");
            gudeText.x        = 420;
            gudeText.y        = 80;
            gudeText.fontSize = 16;
            gudeText.color    = 0x888888;
            gudeText.hAlign   = HAlign.LEFT;
            gudeText.vAlign   = VAlign.TOP;
            addChild(gudeText);
        }

        private function _addImage():void {
            var texture:Texture = Texture.fromEmbeddedAsset(PiyoImg);
            var image:Image     = new Image(texture);

            image.x      = 300;
            image.y      = 40;
            image.width  = 100;
            image.height = 100;
            image.color  = 0x888888;

            addChild(image);
        }
    }
}
