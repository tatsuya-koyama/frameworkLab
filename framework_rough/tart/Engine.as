package tart {

    public class Engine {

        private var _list:LinkedList;
        private var _listIter:IIterator;

        public function Engine() {
            _list     = new LinkedList();
            _listIter = _list.iterator();  // cache iterator to avoid new cost
        }

        public function test():void {
            _list.push(3);
            _list.push(1);
            _list.push(4);
            _list.push(1);
            _list.push(5);

            trace("\n----- loop 1 -----");
            var node:LinkedListNode;
            for (node = _list.head; node; node = node.next) {
                trace("item:", node.item);
            }

            trace("\n----- loop 2 -----");
            for (_listIter.start(); _listIter.hasNext();) {
                trace("item:", _listIter.current(), _listIter.next(), _listIter.current());
            }

            trace("\n----- loop 3 -----");
            _listIter.start();
            while(_listIter.hasNext()) {
                var item:int = _listIter.next();
                trace("item:", item);
            }
        }
    }
}
