package {

    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import away3d.cameras.Camera3D;
    import away3d.controllers.HoverController;

    public class CameraController {

        private var _cameraController:HoverController;
        private var _stage:Stage;
        private var _isTouching:Boolean   = false;
        private var _lastMouseX:Number    = 0;
        private var _lastMouseY:Number    = 0;
        private var _lastPanAngle:Number  = 0;
        private var _lastTiltAngle:Number = 0;

        public function CameraController(stage:Stage, camera:Camera3D) {
            _stage = stage;
            _cameraController = new HoverController(camera, null, 45, 20, 1000);

            _stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
            _stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
            _stage.addEventListener(Event.MOUSE_LEAVE, _onMouseLeave);
        }

        public function update():void {
            if (!_isTouching) { return; }

            _cameraController.panAngle  = _lastPanAngle  + 0.3 * (_stage.mouseX - _lastMouseX);
            _cameraController.tiltAngle = _lastTiltAngle + 0.3 * (_stage.mouseY - _lastMouseY);
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
    }
}
