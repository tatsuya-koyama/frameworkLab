package tart.core {

    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import flash.utils.setTimeout; /// ToDo: 不本意

    import away3d.containers.View3D;
    import away3d.core.managers.Stage3DManager;
    import away3d.core.managers.Stage3DProxy;
    import away3d.debug.AwayStats;
    import away3d.events.Stage3DEvent;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    import tart.core.Component;
    import tart.core.Entity;
    import tart.core.System;
    import tart.utils.IIterator;
    import tart.utils.LinkedList;

    public class Engine {

        // ToDo: option にする
        private const STARLING_COORDINATE_WIDTH :Number = 960;
        private const STARLING_COORDINATE_HEIGHT:Number = 640;

        private var _stage:Stage;
        private var _rootSprite:flash.display.Sprite;

        private var _stage3DManager:Stage3DManager;
        private var _stage3DProxy:Stage3DProxy;
        private var _view3D:View3D;
        private var _starlingFront:Starling;
        private var _starlingBack:Starling;
        private var _onInitComplete:Function;

        private var _tartContext:TartContext;
        private var _systems:LinkedList;
        private var _systemIter:IIterator;
        private var _componentMap:Dictionary;

        public function Engine() {
            _tartContext  = new TartContext();
            _systems      = new LinkedList();
            _systemIter   = _systems.iterator();
            _componentMap = new Dictionary();
        }

        // ToDo: 初期化する専用のクラスを作ってもろもろ差し替え可能にする
        // ToDo: コールバックじゃなくて onSystemInit みたいなのを実装する感じで制御の反転にする
        public function boot(rootSprite:flash.display.Sprite, onInitComplete:Function):void {
            _rootSprite     = rootSprite;
            _stage          = _rootSprite.stage;
            _onInitComplete = onInitComplete;

            _stage.scaleMode = StageScaleMode.NO_SCALE;
            _stage.align     = StageAlign.TOP_LEFT;

            _initStage3D();
        }

        private function _initStage3D():void {
            _stage3DManager = Stage3DManager.getInstance(_stage);

            _stage3DProxy = _stage3DManager.getFreeStage3DProxy();
            _stage3DProxy.antiAlias = 8;
            _stage3DProxy.color     = 0x222222;
            _stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, _onContextCreated);
        }

        private function _onContextCreated(event:Stage3DEvent):void {
            _view3D = _makeAway3DView(_stage3DProxy);
            _rootSprite.addChild(_view3D);
            _rootSprite.addChild(new AwayStats(_view3D));

            _starlingFront = _makeStarling(_stage3DProxy);
            _starlingFront.showStatsAt(HAlign.RIGHT, VAlign.BOTTOM);

            _starlingBack = _makeStarling(_stage3DProxy);
            _starlingBack.showStatsAt(HAlign.RIGHT, VAlign.TOP);

            _stage.addEventListener(Event.RESIZE, _onStageResize);
            _onStageResize();

            _initTartContext();
            _initSystems();
            _stage3DProxy.addEventListener(Event.ENTER_FRAME, _onEnterFrame);

            if (_onInitComplete != null) {
                // ToDo: ちゃんとやるには Starling の ROOT_CREATED イベントを待たなければならない
                var that:Engine = this;
                setTimeout(function():void {
                    _onInitComplete(that);
                }, 1);
            }
        }

        private function _makeAway3DView(stage3DProxy:Stage3DProxy):View3D {
            var view3D:View3D = new View3D();
            view3D.stage3DProxy = stage3DProxy;
            view3D.shareContext = true;
            view3D.width        = _stage.stageWidth;
            view3D.height       = _stage.stageHeight;
            return view3D;
        }

        private function _makeStarling(stage3DProxy:Stage3DProxy):Starling {
            var starling:Starling = new Starling(
                starling.display.Sprite,
                _stage,
                stage3DProxy.viewPort,
                stage3DProxy.stage3D
            );
            return starling;
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

            _starlingBack.stage.stageWidth  = STARLING_COORDINATE_WIDTH;
            _starlingBack.stage.stageHeight = STARLING_COORDINATE_HEIGHT;
        }

        private function _getBestFitViewPort():Rectangle {
            // ToDo: option にする
            const aspectRatio:Number = 2 / 3;  // height / width
            var screenWidth:Number   = _stage.stageWidth;
            var screenHeight:Number  = _stage.stageHeight;
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

        //----------------------------------------------------------------------
        // ここから先が Engine 本命の処理
        //----------------------------------------------------------------------

        public function getComponents(componentClass:Class):LinkedList {
            return _getComponentsSafe(componentClass);
        }

        public function addSystems(systems:Array):void {
            for each (var system:System in systems) {
                system.onAddedToEngine(this);
                _systems.push(system);
            }
        }

        public function addEntity(entity:Entity):void {
            var components:Array = entity.components;
            for each (var component:Component in components) {
                var cmptClass:Class = component.getClass();
                if (!cmptClass) {
                    throw new Error("Cannot attach abstract component: " + component);
                }

                component.onAddedToEngine(_tartContext);
                _getComponentsSafe(cmptClass).push(component);
            }
        }

        private function _initTartContext():void {
            _tartContext.starlingBack  = _starlingBack;
            _tartContext.view3D        = _view3D;
            _tartContext.starlingFront = _starlingFront;
        }

        // 無ければ作る
        private function _getComponentsSafe(componentClass:Class):LinkedList {
            if (!_componentMap[componentClass]) {
                _componentMap[componentClass] = new LinkedList();
            }
            return _componentMap[componentClass];
        }

        private function _initSystems():void {
            for (var system:System = _systemIter.head(); system; system = _systemIter.next()) {
                system.init();
            }
        }

        private function _onEnterFrame(event:Event):void {
            mainLoop();
        }

        public function mainLoop():void {
            for (var system:System = _systemIter.head(); system; system = _systemIter.next()) {
                system.process(_tartContext);
            }
        }

    }
}
