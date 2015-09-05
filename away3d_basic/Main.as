package {

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Vector3D;

    import away3d.containers.View3D;
    import away3d.debug.AwayStats;
    import away3d.entities.Mesh;
    import away3d.materials.ColorMaterial;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.PlaneGeometry;
    import away3d.utils.Cast;

    [SWF(backgroundColor="#333333", frameRate="60", width="960", height="640")]

    public class Main extends Sprite {

        [Embed(source="./joy.png")]
        public static var JoyTexture:Class;

        private var _view:View3D;
        private var _plane:Mesh;

        public function Main() {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align     = StageAlign.TOP_LEFT;

            _view = new View3D();
            addChild(_view);
            addChild(new AwayStats(_view));

            _view.backgroundColor = 0x333333;
            _initCamera(_view);

            _plane = _makePlane();
            _view.scene.addChild(_plane);

            _view.width  = stage.stageWidth;
            _view.height = stage.stageHeight;

            addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        }

        private function _initCamera(view:View3D):void {
            view.camera.z = -1000;
            view.camera.y = 500;
            view.camera.lookAt(new Vector3D());
        }

        private function _makePlane():Mesh {
            var geometry:PlaneGeometry = new PlaneGeometry(2000, 2000);
            geometry.scaleUV(8, 8);

            // var material:ColorMaterial = new ColorMaterial(0xffffff, 1);
            var material:TextureMaterial = new TextureMaterial(
                Cast.bitmapTexture(JoyTexture)
            );
            material.repeat = true;

            var plane = new Mesh(geometry, material);
            return plane;
        }

        private function _onEnterFrame(event:Event):void {
            _plane.rotationY += 0.5;
            _view.render();
        }
    }
}
