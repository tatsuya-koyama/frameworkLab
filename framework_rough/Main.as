package {

    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;

    import away3d.animators.ParticleAnimationSet;
    import away3d.animators.ParticleAnimator;
    import away3d.animators.data.ParticleProperties;
    import away3d.animators.data.ParticlePropertiesMode;
    import away3d.animators.nodes.ParticleBillboardNode;
    import away3d.animators.nodes.ParticleColorNode;
    import away3d.animators.nodes.ParticleVelocityNode;
    import away3d.containers.View3D;
    import away3d.core.base.Geometry;
    import away3d.core.base.ParticleGeometry;
    import away3d.core.managers.Stage3DManager;
    import away3d.core.managers.Stage3DProxy;
    import away3d.debug.AwayStats;
    import away3d.entities.Mesh;
    import away3d.events.Stage3DEvent;
    import away3d.lights.DirectionalLight;
    import away3d.materials.ColorMaterial;
    import away3d.materials.TextureMaterial;
    import away3d.materials.lightpickers.StaticLightPicker;
    import away3d.primitives.CubeGeometry;
    import away3d.primitives.PlaneGeometry;
    import away3d.tools.helpers.ParticleGeometryHelper;
    import away3d.utils.Cast;

    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    import tart.Engine;

    [SWF(backgroundColor="#222222", frameRate="60", width="960", height="640")]

    public class Main extends Sprite {

        [Embed(source="./dust.png")]
        public static var DustImg:Class;

        private const STARLING_COORDINATE_WIDTH :Number = 960;
        private const STARLING_COORDINATE_HEIGHT:Number = 640;

        private var _stage3DManager:Stage3DManager;
        private var _stage3DProxy:Stage3DProxy;
        private var _view3D:View3D;
        private var _starlingFront:Starling;
        private var _starlingBack:Starling;
        private var _light:DirectionalLight;
        private var _lightPicker:StaticLightPicker;
        private var _engine:Engine;

        public function Main() {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align     = StageAlign.TOP_LEFT;

            _initStage3D();
        }

        private function _initStage3D():void {
            _stage3DManager = Stage3DManager.getInstance(stage);

            _stage3DProxy = _stage3DManager.getFreeStage3DProxy();
            _stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, _onContextCreated);
            _stage3DProxy.antiAlias = 8;
            _stage3DProxy.color     = 0x222222;
        }

        private function _onContextCreated(event:Stage3DEvent):void {
            _view3D = _initAway3DView(_stage3DProxy);
            _light  = _initLight(_view3D);
            _lightPicker = new StaticLightPicker([_light]);
            _initCamera(_view3D);

            _initStarling(_stage3DProxy);

            _initEngine();

            _stage3DProxy.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
            stage.addEventListener(Event.RESIZE, _onStageResize);
            _onStageResize();
        }

        private function _initEngine():void {
            _engine = new Engine();
            _engine.test();
        }

        private function _onStageResize(event:Event=null):void {
            var viewPort:Rectangle = _getBestFitViewPort();

            _view3D.x            = viewPort.x;
            _view3D.y            = viewPort.y;
            _view3D.width        = viewPort.width;
            _view3D.height       = viewPort.height;

            _stage3DProxy.x      = viewPort.x;
            _stage3DProxy.y      = viewPort.y;
            _stage3DProxy.width  = viewPort.width;
            _stage3DProxy.height = viewPort.height;

            _starlingFront.stage.stageWidth  = STARLING_COORDINATE_WIDTH;
            _starlingFront.stage.stageHeight = STARLING_COORDINATE_HEIGHT;

            _starlingBack .stage.stageWidth  = STARLING_COORDINATE_WIDTH;
            _starlingBack .stage.stageHeight = STARLING_COORDINATE_HEIGHT;
        }

        private function _getBestFitViewPort():Rectangle {
            const aspectRatio:Number = 2 / 3;  // height / width
            var screenWidth:Number   = stage.stageWidth;
            var screenHeight:Number  = stage.stageHeight;
            var viewPort:Rectangle   = new Rectangle();

            if (screenHeight / screenWidth < aspectRatio) {
                viewPort.height = screenHeight;
                viewPort.width  = int(screenHeight / aspectRatio);
                viewPort.x      = int((screenWidth - viewPort.width) / 2);  // centering horizontally
            } else {
                viewPort.width  = screenWidth;
                viewPort.height = int(screenWidth * aspectRatio);
                viewPort.y      = int((screenHeight - viewPort.height) / 2);  // centering vertically
            }
            return viewPort;
        }

        private function _initAway3DView(stage3DProxy:Stage3DProxy):View3D {
            var view3D:View3D = new View3D();
            view3D.stage3DProxy = stage3DProxy;
            view3D.shareContext = true;

            addChild(view3D);
            addChild(new AwayStats(view3D));

            view3D.width  = stage.stageWidth;
            view3D.height = stage.stageHeight;
            return view3D;
        }

        private function _initCamera(view:View3D):void {
            view.camera.x = 0;
            view.camera.y = 500;
            view.camera.z = -500;
            view.camera.lookAt(new Vector3D());

            view.camera.lens.near = 20;
            view.camera.lens.far  = 5000;
        }

        private function _initLight(view:View3D):DirectionalLight {
            var light:DirectionalLight = new DirectionalLight();
            light.x = 0;
            light.y = 500;
            light.z = 1000;
            light.lookAt(new Vector3D(0, 0, 0));
            light.color    = 0xff8811;
            light.ambient  = 0.2;
            light.diffuse  = 0.6;
            light.specular = 0.8;
            return light;
        }

        private function _initStarling(stage3DProxy:Stage3DProxy):void {
            _starlingFront = new Starling(
                StarlingFrontView, stage,
                stage3DProxy.viewPort,
                stage3DProxy.stage3D
            );
            _starlingFront.showStatsAt(HAlign.RIGHT, VAlign.BOTTOM);

            _starlingBack = new Starling(
                StarlingBackView, stage,
                stage3DProxy.viewPort,
                stage3DProxy.stage3D
            );
            _starlingBack.showStatsAt(HAlign.RIGHT, VAlign.TOP);
        }

        private function _onEnterFrame(event:Event):void {
            _render();
        }

        private function _render():void {
            _starlingBack.nextFrame();
            _view3D.render();
            _starlingFront.nextFrame();
        }
    }
}
