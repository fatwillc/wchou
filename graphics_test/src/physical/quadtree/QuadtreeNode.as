package physical.quadtree
{
  import __AS3__.vec.Vector;
  
  import core.GameObject;
  
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;
  
  import mx.core.UIComponent;
  
  /**
   * A quadtree that contains game objects in leaf nodes.
   */
  public class QuadtreeNode
  {
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * Is this quadtree node a leaf?
     */
    private function get isLeaf():Boolean 
    { 
      return topLeft == null; // Other sub-quadtrees assumed to be the same.
    }
    
    /**
     * Game objects contained within this node.
     * Empty if this node is a leaf.
     */
    public var containedObjects:Vector.<GameObject>;
    
    /**
     * This node's bounding rectangle.
     */
    private var bounds:Rectangle;
    
    /**
     * The depth of this node with respect to the quadtree root.
     */
    private var depth:int;
    
    /**
     * The upper-left child node.
     */
    private var topLeft:QuadtreeNode;
    
    /**
     * The upper-right child node.
     */
    private var topRight:QuadtreeNode;
    
    /**
     * The lower-left child node.
     */
    private var bottomLeft:QuadtreeNode;
    
    /**
     * The lower-right child node.
     */
    private var bottomRight:QuadtreeNode;
    
    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////
    
    public function QuadtreeNode(boundingArea:Rectangle, depth:int = 0)
    {
      this.containedObjects = new Vector.<GameObject>();
      
      this.bounds = boundingArea;
      
      this.depth = depth;
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////////////////////////
    
    public function visualize(component:UIComponent):void
    {
      component.graphics.lineStyle(1, 0x00FF00, 0.1);
      component.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
      
      if (!isLeaf)
      {
        topLeft.visualize(component);
        topRight.visualize(component);
        bottomLeft.visualize(component);
        bottomRight.visualize(component);
      }
    }
    
    /**
     * Does the bounds of this quadtree node intersect the bounds of a given game object?
     * 
     * @param go - the game object to test bound intersection with.
     */
    public function intersects(go:GameObject):Boolean
    {
      var d:DisplayObject = go.graphics.drawable;
      return bounds.intersects(d.getRect(d.parent));
    }
    
    /**
     * Adds a game object to this node's object container.
     * 
     * @param go - the game object to add.
     */
    public function addObject(go:GameObject):void
    {
      if (isLeaf)
      {
        containedObjects.push(go);
        
        if (containedObjects.length > Quadtree.leafLoad && depth < Quadtree.maxTreeDepth)
          subdivide();
      }
      else
        distributeObject(go);
    }
    
    /**
     * Gets all the leaves of the quadtree rooted at this node and pushes them into a given vector.
     * Uses recursive DFS to traverse tree.
     * 
     * @param leavesSoFar - aggregate vector to store leaves in.
     */
    public function getLeaves(leavesSoFar:Vector.<QuadtreeNode>):void
    {
      if (isLeaf)
        leavesSoFar.push(this);
      else
      {
        topLeft.getLeaves(leavesSoFar);
        topRight.getLeaves(leavesSoFar);
        bottomLeft.getLeaves(leavesSoFar);
        bottomRight.getLeaves(leavesSoFar);
      }
    }
    
    /**
     * Subdivides this quadtree node and distributes all contained objects.
     */
    private function subdivide():void
    {
      // Subdivide bounding area and distribute children.
      var halfWidth:Number  = bounds.width  / 2;
      var halfHeight:Number = bounds.height / 2;
      
      var tl:Rectangle = new Rectangle(bounds.x,             bounds.y,              halfWidth, halfHeight);
      var tr:Rectangle = new Rectangle(bounds.x + halfWidth, bounds.y,              halfWidth, halfHeight);
      var bl:Rectangle = new Rectangle(bounds.x,             bounds.y + halfHeight, halfWidth, halfHeight);
      var br:Rectangle = new Rectangle(bounds.x + halfWidth, bounds.y + halfHeight, halfWidth, halfHeight);
      
      topLeft     = new QuadtreeNode(tl, depth + 1);
      topRight    = new QuadtreeNode(tr, depth + 1);
      bottomLeft  = new QuadtreeNode(bl, depth + 1);
      bottomRight = new QuadtreeNode(br, depth + 1);
      
      for each (var child:GameObject in containedObjects)
        distributeObject(child);
      
      containedObjects = null;
    }
    
    /**
     * Distributes a given game object into each overlapping child node.
     */
    private function distributeObject(go:GameObject):void
    {
      if (topLeft.intersects(go))
        topLeft.addObject(go);
   
      if (topRight.intersects(go))    
        topRight.addObject(go);

      if (bottomLeft.intersects(go))
        bottomLeft.addObject(go);
        
      if (bottomRight.intersects(go))
        bottomRight.addObject(go);
    }
  }
}