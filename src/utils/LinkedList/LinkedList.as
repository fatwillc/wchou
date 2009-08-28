package utils.LinkedList {
	
	/** A doubly linked list. */
	public class LinkedList	{
		
		protected var first:Node;
		protected var last:Node;
		
		public function getFirst():Node {
			return first;
		}
		
		public function length():int {
			var l:int;
			
			var n:Node = first;
			
			for (l = 0; n != null; l++) {
				n = n.next;
			}
			
			return l; 
		}
		
		public function push(data:Object):void {
			if (last == null) {
				// Length == 0.
				first = last = new Node(data);
			} else {
				// Length >= 1.
				var n:Node = new Node(data);
				
				n.prev = last;
				last.next = n;
				
				last = n;
			}
		}
		
		public function pop(o:Node):void {
			if (o == null) {
				throw new Error("Cannot pop a null reference!");
			}
			
			var p:Node = o.prev;
			var n:Node = o.next;
			
			if (p != null && n != null) {
				p.next = n;
				n.prev = p;
			} else if (p != null) { // Must be the last element.
				if (o != last) throw new Error("Node to pop does not exist in list!");
			
				p.next = null;
				last = p;
			} else if (n != null) { // Must be the first element.
				if (o != first) throw new Error("Node to pop does not exist in list!");
			
				n.prev = null;
				first = n;
			} else { // Must be the only element.
				if (o != last || o != first) throw new Error("Node to pop does not exist in list!");
			
				first = last = null;
			}
			
			o = null;
		}

		/** Requires running in debug mode. */
		public static function test():void {
			trace("LinkedList->test():");
			
			trace("=========================");
			trace("TEST 1");
			trace("=========================");
			trace("Push integers 0 to 10...");
			var list:LinkedList = new LinkedList();
			for (var i:int = 0; i <= 10; i++) {
				list.push(i);
			}
			
			var iterator:LinkedListIterator;
			var node:Node;
			
			trace("PRINT LIST!");
			iterator = new LinkedListIterator(list);
			while (iterator.hasNext()) {
				node = iterator.next();
				trace(node.data);
			}
			
			trace("Pop nodes in odd-numbered slots...");
			iterator = new LinkedListIterator(list);
			while (iterator.hasNext()) {
				iterator.next();
				node = iterator.next();
				if (node != null) {
					list.pop(node);
				}
			}
			
			trace("PRINT LIST!");
			iterator = new LinkedListIterator(list);
			while (iterator.hasNext()) {
				node = iterator.next();
				trace(node.data);
			}
			
			trace("=========================");
			trace("TEST 2");
			trace("=========================");
			trace("Pushing a single string...");
			list = new LinkedList();
			list.push("A single string");
			
			trace("PRINT LIST!");
			iterator = new LinkedListIterator(list);
			while (iterator.hasNext()) {
				node = iterator.next();
				trace(node.data);
			}
			
			trace("Popping once...");
			iterator = new LinkedListIterator(list);
			list.pop(iterator.next());
			
			trace("PRINT LIST!");
			try {
				iterator = new LinkedListIterator(list);
			} catch (e:Error) {
				trace("Error caught: successful!");
			}
		}

	}
}