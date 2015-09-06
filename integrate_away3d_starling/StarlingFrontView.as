package {

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class StarlingFrontView extends Sprite {

        [Embed(source="./piyo.png")]
        public static var PiyoImg:Class;

        public function StarlingFrontView() {
            _addText();
            _addImage();
        }

        private function _addText():void {
            var textField:TextField = new TextField(700, 100, "This image is powered by Starling");
            textField.x        = 180;
            textField.y        = 580;
            textField.fontSize = 30;
            textField.color    = 0xaaaaaa;
            textField.hAlign   = HAlign.LEFT;
            textField.vAlign   = VAlign.TOP;
            addChild(textField);

            var gudeText:TextField = new TextField(
                700, 100,
                "Mouse Drag: Move camera direction \n"
                    + "WASD or Arrow: Move view point"
            );
            gudeText.x        = 180;
            gudeText.y        = 540;
            gudeText.fontSize = 16;
            gudeText.color    = 0xaaaaaa;
            gudeText.hAlign   = HAlign.LEFT;
            gudeText.vAlign   = VAlign.TOP;
            addChild(gudeText);
        }

        private function _addImage():void {
            var texture:Texture = Texture.fromEmbeddedAsset(PiyoImg);
            var image:Image     = new Image(texture);

            image.x      = 20;
            image.y      = 480;
            image.width  = 150;
            image.height = 150;

            addChild(image);
        }
    }
}
