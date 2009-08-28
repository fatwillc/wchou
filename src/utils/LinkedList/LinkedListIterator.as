package utils.LinkedList {
	
	public class LinkedListIterator	{
		
		protected var currentNode:Node;
		
		public function LinkedListIterator(list:LinkedList, startIndex:int = 0) {
			currentNode = list.getFirst();
			
			if (currentNode == null) {
				throw new Error("Input list is null!");
			}
			
			for (var i:int = 0; i < startIndex; i++) {
				if (currentNode == null) {
					break;
				}
				
				currentNode = currentNode.next;
			}
		}
		
		public function current():Node {
			return currentNode;
		}
		
		public function next():Node {
			if (!hasNext()) {
				return null;
			}
			
			var next:Node = currentNode;
			currentNode = currentNode.next;
			return next;
		}
		
		public function hasNext():Boolean {
			return (currentNode != null);
		}

	}
}