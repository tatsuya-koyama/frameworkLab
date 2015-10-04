package game.entities {

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    import tart.components.Actor;
    import tart.components.Image2D;
    import tart.components.Sprite2D;
    import tart.components.Text2D;
    import tart.components.Transform;
    import tart.core.Entity;

    public class Piyo extends Actor {

        [Embed(source="../../piyo.png")]
        private static var PiyoImg:Class;

        [Embed(source="../../dust.png")]
        private static var DustImg:Class;

        private var _vecX:Number = 120;
        private var _vecY:Number = 110;
        private var _frame:int   = 0;

        public function Piyo() {

        }

        public static function create():Entity {
            var entity:Entity = new Entity();
            // ToDo: 実際には Pool から取得するようにする（引数の指定が面倒だな）
            //       ここではクラス名だけ並べる感じにしたいなー
            entity.attachComponent(new Piyo());
            entity.attachComponent(new Transform());
            entity.attachComponent(new Sprite2D());
            entity.attachComponent(new Image2D());
            entity.attachComponent(new Text2D());
            return entity;
        }

        public override function awake():void {
            var layerSprite:Sprite = _tartContext.starlingFront.root as Sprite;
            var texture1:Texture   = Texture.fromEmbeddedAsset(PiyoImg);
            var texture2:Texture   = Texture.fromEmbeddedAsset(DustImg);

            _image2D.init(layerSprite, texture1, 150, 150, 0, 0);

            _sprite2D.init(layerSprite);
            var subImage1:Image = _sprite2D.addImage(texture1, 80, 80, -100, 50);
            var subImage2:Image = _sprite2D.addImage(texture2, 10, 10);
            subImage1.color = 0xff9900;

            _text2D.init(layerSprite, "Entity 1", 200, 50, 0, 0, 0, 0);
            _text2D.textField.color    = 0x004400;
            _text2D.textField.fontSize = 14;
            _text2D.textField.hAlign   = HAlign.LEFT;
            _text2D.textField.vAlign   = VAlign.TOP;

            // ToDo: 親子構造の実験
        }

        public override function update(deltaTime:Number):void {
            if (_transform.position.x < 0 || 960 < _transform.position.x) { _vecX *= -1; }
            if (_transform.position.y < 0 || 640 < _transform.position.y) { _vecY *= -1; }

            _transform.position.x += _vecX * deltaTime;
            _transform.position.y += _vecY * deltaTime;

            _transform.rotation.z += 1 * deltaTime;

            _spawnTest();
        }

        private function _spawnTest():void {
            ++_frame;
            if (_frame % 60 != 0) { return; }

            var entity:Entity = Dust.create();
            createEntity(entity);
        }

    }
}
