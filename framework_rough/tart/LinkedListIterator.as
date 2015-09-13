package tart {

    public class LinkedListIterator implements IIterator {

        private var _list:LinkedList;
        private var _currentNode:LinkedListNode;
        private var _nextNode:LinkedListNode;

        public function LinkedListIterator(list:LinkedList) {
            _list        = list;
            _currentNode = null;
            _nextNode    = null;
        }

        public function start():void {
            _currentNode = null;
            _nextNode    = _list.head;
        }

        public function current():* {
            if (!_currentNode) { return null; }
            return _currentNode.item;
        }

        public function next():* {
            _currentNode = _nextNode;
            if (_currentNode) {
                _nextNode = _currentNode.next;
            }
            return current();
        }

        public function hasNext():Boolean {
            return !!_nextNode;
        }

    }
}
