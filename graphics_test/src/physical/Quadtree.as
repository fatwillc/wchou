package physical
{
  import __AS3__.vec.Vector;
  
  import core.GameObject;
  
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;
  
  import mx.core.UIComponent;
  
  /**
   * A quadtree that contains game objects in leaf nodes.
   */
  public class Quadtree
  {
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * Maximum load per leaf.
     */
    public static const maxChildrenPerLeaf:int = 10;
    
    /**
     * Maximum depth (height) of the quadtree.
     */
    public static const maxDepth:int = 4;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * Is this quadtree node a leaf?
     */
    public function get isLeaf():Boolean 
    { 
      return topLeft == null; // Other sub-quadtrees assumed to be the same.
    }
    
    /**
     * Game objects contained within this node.
     * Empty if this node is a leaf.
     */
    public var containedObjects:Vector.<GameObject>;
    
    /**
     * The upper-left child node.
     */
    public var topLeft:Quadtree;
    
    /**
     * The upper-right child node.
     */
    public var topRight:Quadtree;
    
    /**
     * The lower-left child node.
     */
    public var bottomLeft:Quadtree;
    
    /**
     * The lower-right child node.
     */
    public var bottomRight:Quadtree;
    
    /**
     * This node's bounding rectangle.
     */
    public var bounds:Rectangle;
    
    /**
     * The depth of this node with respect to the quadtree root.
     */
    private var depth:int;
    
    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////
    
    public function Quadtree(boundingArea:Rectangle, depth:int = 0)
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
        
        if (containedObjects.length > maxChildrenPerLeaf && depth < maxDepth)
          subdivide();
      }
      else
        distributeObject(go);
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
      
      topLeft     = new Quadtree(tl, depth + 1);
      topRight    = new Quadtree(tr, depth + 1);
      bottomLeft  = new Quadtree(bl, depth + 1);
      bottomRight = new Quadtree(br, depth + 1);
      
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