package tart.components {

    import tart.core.Component;

    public class Actor extends Component {

        // よく使うコンポーネントへのアクセスを提供
        protected var _transform:Transform;
        protected var _sprite2D:Sprite2D;
        protected var _image2D:Image2D;
        protected var _text2D:Text2D;

        public var isAwoken:Boolean;

        public override function getClass():Class {
            return Actor;
        }

        public function Actor() {
            reset();
        }

        public function reset():void {
            _transform = null;
            _sprite2D  = null;
            _image2D   = null;
            _text2D    = null;

            isAwoken = false;
        }

        public function internalAwake():void {
            _transform = getComponent(Transform) as Transform;
            _sprite2D  = getComponent(Sprite2D)  as Sprite2D;
            _image2D   = getComponent(Image2D)   as Image2D;
            _text2D    = getComponent(Text2D)    as Text2D;
        }

        //----------------------------------------------------------------------
        // Override following methods in subclasses
        //----------------------------------------------------------------------

        public function awake():void {

        }

        public function update(deltaTime:Number):void {

        }

    }
}
