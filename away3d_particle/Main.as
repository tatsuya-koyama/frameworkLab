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
    import away3d.debug.AwayStats;
    import away3d.entities.Mesh;
    import away3d.materials.ColorMaterial;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.CubeGeometry;
    import away3d.primitives.PlaneGeometry;
    import away3d.tools.helpers.ParticleGeometryHelper;
    import away3d.utils.Cast;

    [SWF(backgroundColor="#222222", frameRate="60", width="960", height="640")]

    public class Main extends Sprite {

        [Embed(source="./dust.png")]
        public static var DustImg:Class;

        private var _view:View3D;
        private var _plane:Mesh;
        private var _cameraController:CameraController;

        public function Main() {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align     = StageAlign.TOP_LEFT;

            _view = new View3D();
            addChild(_view);
            addChild(new AwayStats(_view));

            _view.backgroundColor = 0x222222;
            _initCamera(_view);
            _cameraController = new CameraController(stage, _view.camera);

            var particleGeometry:ParticleGeometry = _makeParticleGeometry();
            var particleMaterial:TextureMaterial  = _makeParticleMaterial();
            var particleMesh:Mesh = new Mesh(particleGeometry, particleMaterial);

            var particleAnimator:ParticleAnimator = _makeParticleAnimator();
            particleMesh.animator = particleAnimator;

            _view.scene.addChild(particleMesh);
            particleAnimator.start();

            _view.width  = stage.stageWidth;
            _view.height = stage.stageHeight;

            addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        }

        private function _initCamera(view:View3D):void {
            view.camera.z = -500;
            view.camera.y = 500;
            view.camera.lookAt(new Vector3D());
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
            _view.render();
        }
    }
}
