package utils.LinkedList {
  
  /** 
   * **************************************************************************
   * IMPORTANT: 
   * Use is deprecated. It turns out that AS3.Vector is at least twice as 
   * performant for every operation, even when taking into account filtering 
   * elements and resizing itself on pushes.
   * **************************************************************************
   * 
   * A doubly linked list. 
   * 
   * Used for memory efficiency and convenience (particularly in deletion)
   * compared to arrays. I suppose it is arguable and context-dependent
   * whether the pointer-storage overhead of linked list is less than
   * the potential wasted space of empty cells in fixed-size arrays, not to
   * mention contiguous vs. non-contiguous memory access.
   */
  public class LinkedList  {
    
    protected var first:Node = null;
    protected var last:Node = null;
    
    private var _length:int = 0;
    
    /** Gets the first node in the list. */
    public function getFirst():Node {
      return first;
    }
    
    /** The number of nodes in the list. */
    public function get length():int {
      return _length; 
    }
    
    /** Effectively removes all nodes from the list. */
    public function clear():void {
      first = last = null;
      
      _length = 0;
    }
    
    /** Adds a node to the start of the list. */
    public function addFirst(data:Object):void {
      if (last == null) {
        // Length == 0.
        first = last = new Node(data);
      } else {
        // Length >= 1.
        var n:Node = new Node(data);
        
        n.next = first;
        first.prev = n;
        
        first = n;
      }
      
      _length += 1;
    }
    
    /** Adds a node to the end of the list. */
    public function addLast(data:Object):void {
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
      
      _length += 1;
    }
    
    /** Removes a node from the list. */
    public function remove(o:Node):void {
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
      _length -= 1;
    }

  }
}