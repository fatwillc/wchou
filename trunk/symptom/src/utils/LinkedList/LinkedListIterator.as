package utils.LinkedList {
  
  /** An iterator for a linked list. */
  public class LinkedListIterator  {
    
    /** Node corresponding to current iterator position in list. */
    protected var currentNode:Node;
    
    /** 
     * Creates a new linked list iterator. 
     * @param list - The linked list.
     * @param startIndex - The position in the list at which this iterator 
     * begins.
     */
    public function LinkedListIterator(list:LinkedList, startIndex:int = 0) {      
      currentNode = list.getFirst();
      
      if (currentNode == null) {
        throw new Error("Input list is null!");
      }
      
      // Move current node position to startIndex.
      for (var i:int = 0; i < startIndex; i++) {
        if (currentNode == null) {
          break;
        }
        
        currentNode = currentNode.next;
      }
    }

    /** Peeks at the current node without popping it. */
    public function current():Node {
      return currentNode;
    }
    
    /** Pops and returns the current node. */
    public function next():Node {
      if (!hasNext()) {
        return null;
      }
      
      var next:Node = currentNode;
      currentNode = currentNode.next;
      return next;
    }
    
    /** Returns true if the iterator is not exhausted. */
    public function hasNext():Boolean {
      return (currentNode != null);
    }

  }
}