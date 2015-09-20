package tart.utils {

    public class LinkedListNode {

        public var prev:LinkedListNode = null;
        public var next:LinkedListNode = null;
        public var item:* = null;

        public function LinkedListNode(item:*) {
            this.item = item;
        }
    }
}
