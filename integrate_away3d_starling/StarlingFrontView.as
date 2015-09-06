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
            textField.color    = 0x888888;
            textField.hAlign   = HAlign.LEFT;
            textField.vAlign   = VAlign.TOP;
            addChild(textField);
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
