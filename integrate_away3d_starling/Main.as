package {

    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.ColorTransform;
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
    import away3d.materials.ColorMaterial;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.CubeGeometry;
    import away3d.primitives.PlaneGeometry;
    import away3d.tools.helpers.ParticleGeometryHelper;
    import away3d.utils.Cast;

    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    [SWF(backgroundColor="#222222", frameRate="60", width="960", height="640")]

    public class Main extends Sprite {

        [Embed(source="./dust.png")]
        public static var DustImg:Class;

        private var _stage3DManager:Stage3DManager;
        private var _stage3DProxy:Stage3DProxy;
        private var _view3D:View3D;
        private var _starlingFront:Starling;
        private var _starlingBack:Starling;
        private var _plane:Mesh;
        private var _cameraController:CameraController;

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

        private function _initCamera(view:View3D):void {
            view.camera.z = -500;
            view.camera.y = 500;
            view.camera.lookAt(new Vector3D());
        }

        private function _onContextCreated(event:Stage3DEvent):void {
            _view3D = _initAway3DView(_stage3DProxy);
            _initCamera(_view3D);
            _cameraController = new CameraController(stage, _view3D.camera);
            _initParticle(_view3D);

            _initStarling(_stage3DProxy);

            _stage3DProxy.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
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

        private function _initStarling(stage3DProxy:Stage3DProxy):void {
            _starlingFront = new Starling(
                StarlingFrontView, stage,
                stage3DProxy.viewPort,
                stage3DProxy.stage3D
            );
            _starlingFront.showStatsAt(HAlign.RIGHT, VAlign.TOP);

            _starlingBack = new Starling(
                StarlingBackView, stage,
                stage3DProxy.viewPort,
                stage3DProxy.stage3D
            );
            _starlingBack.showStatsAt(HAlign.RIGHT, VAlign.BOTTOM);
        }

        private function _initParticle(view3D:View3D):void {
            var particleGeometry:ParticleGeometry = _makeParticleGeometry();
            var particleMaterial:TextureMaterial  = _makeParticleMaterial();
            var particleMesh:Mesh = new Mesh(particleGeometry, particleMaterial);

            var particleAnimator:ParticleAnimator = _makeParticleAnimator();
            particleMesh.animator = particleAnimator;

            view3D.scene.addChild(particleMesh);
            particleAnimator.start();
        }

        private function _makeParticleGeometry():ParticleGeometry {
            // var cube:Geometry = new CubeGeometry(100, 100, 100);
            var plane:Geometry = new PlaneGeometry(20, 20, 1, 1, false);
            var geometrySet:Vector.<Geometry> = new Vector.<Geometry>;
            for (var i:int = 0; i < 10000; ++i) {
                geometrySet.push(plane);
            }
            return ParticleGeometryHelper.generateGeometry(geometrySet);
        }

        private function _makeParticleMaterial():TextureMaterial {
            var material:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(DustImg));
            material.blendMode = BlendMode.ADD;
            return material;
        }

        private function _makeParticleAnimator():ParticleAnimator {
            var animationSet:ParticleAnimationSet = _makeParticleAnimationSet();
            var particleAnimator:ParticleAnimator = new ParticleAnimator(animationSet);
            return particleAnimator;
        }

        private function _makeParticleAnimationSet():ParticleAnimationSet {
            // (usesDuration:Boolean = false, usesLooping:Boolean = false, usesDelay:Boolean = false)
            var animationSet:ParticleAnimationSet = new ParticleAnimationSet(true, true, true);
            animationSet.addAnimation(new ParticleBillboardNode());
            animationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_STATIC));
            animationSet.addAnimation(new ParticleColorNode(ParticlePropertiesMode.LOCAL_STATIC));
            animationSet.initParticleFunc = _initParticleParams;
            return animationSet;
        }

        private function _initParticleParams(prop:ParticleProperties):void {
            var i:int = prop.index;
            prop.startTime = i * (5 / 10000);
            prop.duration  = 5;
            prop.delay     = 2;

            var degree1:Number;
            var degree2:Number;

            if (i % 3 == 0) {
                degree1 = prop.index * 0.0017;
                degree2 = prop.index * 0.0029;
            } else {
                degree1 = Math.random() * Math.PI;
                degree2 = Math.random() * Math.PI * 2;
            }
            var r:Number = Math.random() * 300 + 400;

            prop[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(
                r * Math.sin(degree1) * Math.cos(degree2),
                r * Math.cos(degree1) * Math.cos(degree2),
                r * Math.sin(degree2)
            );

            prop[ParticleColorNode.COLOR_START_COLORTRANSFORM] = new ColorTransform(0.1, 0.7, 1.0, 1.0);
            prop[ParticleColorNode.COLOR_END_COLORTRANSFORM]   = new ColorTransform(1.0, 0.1, 0.3, 1.0);
        }

        private function _onEnterFrame(event:Event):void {
            _cameraController.update();
            _render();
        }

        private function _render():void {
            _starlingBack.nextFrame();
            _view3D.render();
            _starlingFront.nextFrame();
        }
    }
}
