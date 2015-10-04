package game.entities {

    import starling.display.BlendMode;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    import tart.components.Actor;
    import tart.components.Image2D;
    import tart.components.Transform;
    import tart.core.Entity;

    public class Dust extends Actor {

        [Embed(source="../../dust.png")]
        private static var DustImg:Class;

        private var _vecX:Number = 120;
        private var _vecY:Number = 110;

        public static function create():Entity {
            var entity:Entity = new Entity();
            entity.attachComponent(new Dust());
            entity.attachComponent(new Transform());
            entity.attachComponent(new Image2D());
            return entity;
        }

        public override function awake():void {
            var layerSprite:Sprite = _tartContext.starlingFront.root as Sprite;
            var texture:Texture    = Texture.fromEmbeddedAsset(DustImg);
            _image2D.init(layerSprite, texture, 50, 50);
            _image2D.image.blendMode = BlendMode.ADD;
        }

        public override function update(deltaTime:Number):void {
            _transform.rotation.z += 2 * deltaTime;
        }

    }
}
