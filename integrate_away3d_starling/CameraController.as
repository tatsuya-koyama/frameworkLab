package {

    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;

    import away3d.cameras.Camera3D;
    import away3d.controllers.HoverController;

    public class CameraController {

        private var _camera:Camera3D;
        private var _cameraController:HoverController;
        private var _stage:Stage;
        private var _lookAt:Vector3D;
        private var _isTouching:Boolean   = false;
        private var _lastMouseX:Number    = 0;
        private var _lastMouseY:Number    = 0;
        private var _lastPanAngle:Number  = 0;
        private var _lastTiltAngle:Number = 0;
        private var _pressedMap:Object    = {};  // {keyCode: <isPressed>}

        public function CameraController(stage:Stage, camera:Camera3D) {
            _stage  = stage;
            _camera = camera;
            _cameraController = new HoverController(camera, null, 45, 20, 1000);

            _lookAt = new Vector3D(0, 0, 0);
            _cameraController.lookAtPosition = _lookAt;

            _stage.addEventListener(MouseEvent.MOUSE_DOWN,  _onMouseDown);
            _stage.addEventListener(MouseEvent.MOUSE_UP,    _onMouseUp);
            _stage.addEventListener(Event.MOUSE_LEAVE,      _onMouseLeave);
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
            _stage.addEventListener(KeyboardEvent.KEY_UP,   _onKeyUp);
        }

        public function update():void {
            _moveViewPointByKeyPress_forUpDown();
            _moveViewPointByKeyPress_forLeftRight();

            if (!_isTouching) { return; }

            _cameraController.panAngle  = _lastPanAngle  + 0.3 * (_stage.mouseX - _lastMouseX);
            _cameraController.tiltAngle = _lastTiltAngle + 0.3 * (_stage.mouseY - _lastMouseY);
        }

        private function _moveViewPointByKeyPress_forUpDown():void {
            var speed:Number = 0;
            if (_pressedMap[Keyboard.W    ]) { speed =  20; }
            if (_pressedMap[Keyboard.S    ]) { speed = -20; }
            if (_pressedMap[Keyboard.UP   ]) { speed =  20; }
            if (_pressedMap[Keyboard.DOWN ]) { speed = -20; }
            if (speed == 0) { return; }

            var vec:Vector3D = _camera.forwardVector.clone();
            vec.scaleBy(speed);

            _lookAt.setTo(
                _lookAt.x + vec.x,
                _lookAt.y + vec.y,
                _lookAt.z + vec.z
            );
            _cameraController.lookAtPosition = _lookAt;
        }

        private function _moveViewPointByKeyPress_forLeftRight():void {
            var speed:Number = 0;
            if (_pressedMap[Keyboard.A    ]) { speed =  20; }
            if (_pressedMap[Keyboard.D    ]) { speed = -20; }
            if (_pressedMap[Keyboard.LEFT ]) { speed =  20; }
            if (_pressedMap[Keyboard.RIGHT]) { speed = -20; }
            if (speed == 0) { return; }

            var vec:Vector3D = _camera.leftVector.clone();
            vec.scaleBy(speed);

            _lookAt.setTo(
                _lookAt.x + vec.x,
                _lookAt.y + vec.y,
                _lookAt.z + vec.z
            );
            _cameraController.lookAtPosition = _lookAt;
        }

        private function _onMouseDown(event:MouseEvent):void {
            _isTouching = true;
            _lastMouseX = _stage.mouseX;
            _lastMouseY = _stage.mouseY;

            _lastPanAngle  = _cameraController.panAngle;
            _lastTiltAngle = _cameraController.tiltAngle;
        }

        private function _onMouseUp(event:MouseEvent):void {
            _isTouching = false;
        }

        private function _onMouseLeave(event:Event):void {
            _isTouching = false;
        }

        private function _onKeyDown(event:KeyboardEvent):void {
            _pressedMap[event.keyCode] = true;
        }

        private function _onKeyUp(event:KeyboardEvent):void {
            _pressedMap[event.keyCode] = false;
        }
    }
}
