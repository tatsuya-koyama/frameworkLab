package tart.components {

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;

    import tart.core.Component;
    import tart.core.TartContext;

    public class View2D extends Component {

        private var _displayParent:DisplayObjectContainer;
        private var _displayRoot:DisplayObject;

        public override function getClass():Class {
            return View2D;
        }

        public function View2D() {

        }

    }
}
