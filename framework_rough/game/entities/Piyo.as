package game.entities {

    import starling.display.Sprite;
    import starling.textures.Texture;

    import tart.components.Actor;
    import tart.components.Image2D;
    import tart.components.Sprite2D;
    import tart.components.Text2D;
    import tart.components.Transform;
    import tart.core.Entity;

    public class Piyo extends Actor {

        [Embed(source="../../piyo.png")]
        private static var PiyoImg:Class;

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
            // ここで View の操作？
            var layerSprite:Sprite = _tartContext.starlingFront.root as Sprite;
            var texture:Texture    = Texture.fromEmbeddedAsset(PiyoImg);
            _image2D.init(layerSprite, texture);

            _text2D.init(layerSprite, 200, 50, "Entity 1");
            _text2D.text.color = 0xffffff;

            _sprite2D.init(layerSprite);

            // ToDo: 親子構造の実験
        }

        public override function update(deltaTime:Number):void {
            _transform.position.x += 30 * deltaTime;
            _transform.position.y += 20 * deltaTime;
        }

    }
}
