package tart.core {

    public class Component {

        public var entity:Entity;

        public function getClass():Class {
            throw new Error("You should override getClass() in subclasses.");
            return null;
        }

        public function Component() {

        }

        public function getComponent(componentClass:Class):Component {
            if (!entity) {
                throw new Error("No entity.");
            }
            return entity.getComponent(componentClass);
        }

    }
}
