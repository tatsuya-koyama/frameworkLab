package tart.core {

    import tart.utils.LinkedList;

    public class System {

        protected var engine:Engine;

        public function System() {

        }

        public function onAddedToEngine(engine:Engine):void {
            this.engine = engine;
        }

        protected function getComponents(componentClass:Class):LinkedList {
            if (!engine) {
                throw new Error("No engine.");
            }
            return engine.getComponents(componentClass);
        }

        //----------------------------------------------------------------------
        // Override following methods in subclasses
        //----------------------------------------------------------------------

        public function init():void {

        }

        public function process(tartContext:TartContext):void {

        }

    }
}
