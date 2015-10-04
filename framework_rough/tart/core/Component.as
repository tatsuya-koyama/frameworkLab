package tart.core {

    public class Component {

        protected var _entity:Entity;
        protected var _tartContext:TartContext;

        public function getClass():Class {
            throw new Error("You should override getClass() in subclasses.");
            return null;
        }

        public function Component() {

        }

        public function internalAwake():void {

        }

        public function onCreateEntity(tartContext:TartContext):void {
            _tartContext = tartContext;
            internalAwake();
        }

        public function onAttachedToEntity(entity:Entity):void {
            _entity = entity;
        }

        public function getComponent(componentClass:Class):Component {
            if (!_entity) {
                throw new Error("No entity.");
            }
            return _entity.getComponent(componentClass);
        }

        public function createEntity(entity:Entity):void {
            if (!_entity) {
                throw new Error("No entity.");
            }
            _entity.createEntity(entity);
        }

    }
}
