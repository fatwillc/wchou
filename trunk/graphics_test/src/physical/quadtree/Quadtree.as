package physical.quadtree
{
  import __AS3__.vec.Vector;
  
  import core.GameObject;
  import core.ObjectState;
  
  import flash.geom.Rectangle;
  
  import mx.core.UIComponent;
  
  /**
   * Wraps a quadtree for ease of construction and access.
   */
  public class Quadtree
  {
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * Maximum depth (height) of the quadtree.
     */
    public static const maxTreeDepth:int = 8;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * Maximum load per leaf.
     */
    [Bindable]
    public static var leafLoad:int = 10;
    
    /**
     * The set of leaf nodes of the contained quadtree in no particular order.
     */
    public var leaves:Vector.<QuadtreeNode>;
    
    /**
     * The root node of the contained quadtree.
     */
    private var root:QuadtreeNode;
    
    /**
     * Creates a new quadtree.
     * 
     * @param boundingArea - the physical bounds of the objects being contained.
     * @param objectsToContain - the objects to distribute in the quadtree.
     */
    public function Quadtree(boundingArea:Rectangle, objectsToContain:Vector.<GameObject>)
    {
      root = new QuadtreeNode(boundingArea);
      
      for each (var go:GameObject in objectsToContain)
      {
        if (go.state == ObjectState.ACTIVE)
          root.addObject(go);
      }
      
      leaves = new Vector.<QuadtreeNode>();
      root.getLeaves(leaves);
    }
    
    /**
     * Wraps QuadtreeNode.visualize().
     */
    public function visualize(component:UIComponent):void
    {
      root.visualize(component);
    }
  }
}