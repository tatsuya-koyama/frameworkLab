package tart.systems {

    import tart.components.Image2D;
    import tart.components.IView2D;
    import tart.components.Sprite2D;
    import tart.components.Text2D;
    import tart.components.Transform;
    import tart.core.System;
    import tart.core.TartContext;
    import tart.utils.IIterator;

    public class RenderSystem extends System{

        private var _sprite2DIter:IIterator;
        private var _image2DIter :IIterator;
        private var _text2DIter  :IIterator;

        public override function init():void {
            _sprite2DIter = getComponents(Sprite2D).iterator();
            _image2DIter  = getComponents(Image2D) .iterator();
            _text2DIter   = getComponents(Text2D)  .iterator();
        }

        public override function process(tartContext:TartContext):void {
            for (var sprite2D:Sprite2D = _sprite2DIter.head(); sprite2D; sprite2D = _sprite2DIter.next()) {
                _applyTransform2D(sprite2D);
            }

            for (var image2D:Image2D = _image2DIter.head(); image2D; image2D = _image2DIter.next()) {
                _applyTransform2D(image2D);
            }

            for (var text2D:Text2D = _text2DIter.head(); text2D; text2D = _text2DIter.next()) {
                _applyTransform2D(text2D);
            }

            tartContext.starlingBack.nextFrame();
            tartContext.view3D.render();
            tartContext.starlingFront.nextFrame();
        }

        private function _applyTransform2D(view2D:IView2D):void {
            var transform:Transform = view2D.transform;
            if (!transform) { return; }

            view2D.display.x = transform.position.x;
            view2D.display.y = transform.position.y;
        }

    }
}
