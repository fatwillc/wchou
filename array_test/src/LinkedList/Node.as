package LinkedList {
  
  /** A doubly-linked list node. */
  public class Node {
    
    public var data:Object;
    
    public var prev:Node;
    public var next:Node;
    
    public function Node(data:Object) {
      this.data = data;
    }
    
  }
}