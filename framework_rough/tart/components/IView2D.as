package tart.components {

    import starling.display.DisplayObject;

    import tart.components.Transform;

    public interface IView2D {

        function get display():DisplayObject;

        function get transform():Transform;

    }
}
