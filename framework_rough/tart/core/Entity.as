package tart.core {

    import flash.utils.Dictionary;

    public class Entity {

        protected var _engine:Engine;

        private var _componentMap:Dictionary;
        private var _componentList:Array;

        public function Entity() {
            _componentMap  = new Dictionary();
            _componentList = [];
        }

        public function get components():Array {
            return _componentList;
        }

        public function onCreate(engine:Engine):void {
            _engine = engine;
        }

        public function getComponent(componentClass:Class):Component {
            var component:Component = _componentMap[componentClass];
            return component as Component;
        }

        public function attachComponent(component:Component):void {
            var cmptClass:Class = component.getClass();
            _componentMap[cmptClass] = component;
            _componentList.push(component);

            component.onAttachedToEntity(this);
        }

        public function createEntity(entity:Entity):void {
            _engine.createEntity(entity);
        }

    }
}
