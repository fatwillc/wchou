package utils.LinkedList
{
  /** A simple test for LinkedList. */
  public class LinkedListTest
  {

    public static function test():void {
      trace("Testing LinkedList & LinkedListIterator...");

      var start:int = 0;
      var end:int = 10;

      trace("=========================");
      trace("TEST 1");
      trace("=========================");
      trace("Push integers " + start + " to " + end + ", inclusive...");
      var list:LinkedList = new LinkedList();
      for (var i:int = start; i <= end; i++) {
        list.addLast(i);
      }
      
      trace("Checking list elements...");
      var counter:int = 0;
      var iterator:LinkedListIterator;
      var node:Node;
      
      iterator = new LinkedListIterator(list);
      while (iterator.hasNext()) {
        node = iterator.next();
        
        assertEquals(counter, node.data);
        counter ++;
      }
      
      trace("Pop nodes in odd-numbered slots...");
      iterator = new LinkedListIterator(list);
      while (iterator.hasNext()) {
        iterator.next();
        node = iterator.next();
        if (node != null) {
          list.remove(node);
        }
      }
      
      counter = 0;
      iterator = new LinkedListIterator(list);
      while (iterator.hasNext()) {
        node = iterator.next();
        
        assertEquals(counter, node.data);
        counter += 2;
      }
      
      trace("=========================");
      trace("TEST 2");
      trace("=========================");
      trace("Pushing a single string list...");
      list = new LinkedList();
      var s:String = "A single string";
      list.addLast(s);
      
      iterator = new LinkedListIterator(list);
      while (iterator.hasNext()) {
        node = iterator.next();
        
        assertEquals(s, node.data);
      }
      
      trace("Popping once...");
      iterator = new LinkedListIterator(list);
      list.remove(iterator.next());
      
      try {
        iterator = new LinkedListIterator(list);
      } catch (e:Error) {
        trace("Error caught: successful!");
      }
    }
    
    public static function assertEquals(x:Object, y:Object):void {
      if (x != y) {
        throw new Error("Equality assertion failed: " + x + " , " + y);
      }
    }
  }
}