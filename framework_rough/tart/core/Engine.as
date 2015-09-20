package tart.core {

    import tart.utils.IIterator;
    import tart.utils.LinkedList;

    public class Engine {

        private var _systems:LinkedList;
        private var _systemIter:IIterator;

        public function Engine() {
            _systems    = new LinkedList();
            _systemIter = _systems.iterator();
        }

    }
}
