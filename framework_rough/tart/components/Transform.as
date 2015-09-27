package tart.components {

    import flash.geom.Vector3D;

    import tart.core.Component;

    public class Transform extends Component {

        public var position:Vector3D;
        public var rotation:Vector3D;
        public var scale:Vector3D;

        public override function getClass():Class {
            return Transform;
        }

        public function Transform() {
            position = new Vector3D(0, 0, 0);
            rotation = new Vector3D(0, 0, 0);
            scale    = new Vector3D(1, 1, 1);
        }

    }
}
