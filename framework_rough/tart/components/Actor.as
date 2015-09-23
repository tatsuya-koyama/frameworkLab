package tart.components {

    import tart.core.Component;

    public class Actor extends Component {

        // よく使うコンポーネントへのアクセスを提供
        protected var transform:Transform;
        protected var view2d:View2D;
        protected var view3d:View3D;

        public var isAwoken:Boolean;

        public override function getClass():Class {
            return Actor;
        }

        public function Actor() {
            reset();
        }

        public function reset():void {
            transform = null;
            view2d    = null;
            view3d    = null;

            isAwoken  = false;
        }

        public function internalAwake():void {
            transform = getComponent(Transform) as Transform;
            view2d    = getComponent(View2D)    as View2D;
            view3d    = getComponent(View2D)    as View3D;
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
