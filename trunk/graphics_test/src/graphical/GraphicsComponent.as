package graphical
{
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import mx.flash.UIMovieClip;
  
  import utils.Geometry;
  import utils.Vector2;
  
  public class GraphicsComponent
  {
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    /////////////////////////////////////////////////////////////////////////// 
    
    /** 
     * Visual representation of object.
     * Must be set manually. 
     */
    public var drawable:DisplayObject;
    
    /**
     * Bitmap data of the graphics object.
     * If null, constructed on next draw() cycle.
     */
    private var cachedGraphicsBitmap:BitmapData;
    
    /**
     * Clears the current cached graphics bitmap data for recomputation on next draw() cycle.
     */
    private function clearGraphicsCache():void 
    {
      cachedGraphicsBitmap = null;
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR
    /////////////////////////////////////////////////////////////////////////// 
    
    public function GraphicsComponent()
    {
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    /////////////////////////////////////////////////////////////////////////// 
    
    public function update(position:Vector2, rotation:Number):void
    {
      if (drawable == null)
        return;
      
      moveGraphics(position, rotation);
      
      rotateAboutCenter(rotation);
    }
    
    public function draw(buffer:BitmapData, position:Vector2):void
    {
      if (drawable == null)
        return;
      
      if (cachedGraphicsBitmap == null)
      {
        cachedGraphicsBitmap = new BitmapData(drawable.width, drawable.height, true, 0x000000);
        cachedGraphicsBitmap.draw(drawable, null, drawable.transform.colorTransform);
      }
      
      var sourceRect:Rectangle = new Rectangle(0, 0, drawable.width, drawable.height);
      var destPoint:Point = new Point(position.x - drawable.width/2, position.y - drawable.height/2);
      buffer.copyPixels(cachedGraphicsBitmap, sourceRect, destPoint, cachedGraphicsBitmap, new Point(), true);
    }
    
    /** 
     * Move the graphics object such that its center lies at a given position. 
     * 
     * @param position - location to move to.
     * @param currentRotation - the current rotation of the object in degrees. 
     *        Necessary for finding center in object coordinates.
     */
    private function moveGraphics(position:Vector2, currentRotation:Number):void
    {
      // Standard Flex components define rotation wrt the top left corner,
      // but imported SWCs define rotation wrt the center of the UIMovieClip.
      if (drawable is UIMovieClip)
      {
        drawable.x = position.x;
        drawable.y = position.y;
      } 
      else
      {
        if (currentRotation == 0)
        {
          drawable.x = position.x - drawable.width / 2;
          drawable.y = position.y - drawable.height / 2;
        }
        else
        {
          // TODO Test this.
          var graphicsOrigin:Vector2 = new Vector2();
          graphicsOrigin.copy(position);
          
          var u:Vector2 = getDirection();
          var v:Vector2 = new Vector2(u.y, -u.x);
          graphicsOrigin.acc(u, drawable.height / 2);
          graphicsOrigin.acc(v, drawable.width / 2);
          
          drawable.x = graphicsOrigin.x;
          drawable.y = graphicsOrigin.y;
        }
      }
    }    
    
    /** 
     * Rotates graphics object about its center. 
     * 
     * @param theta - The amount to rotate in degrees.
     */
    private function rotateAboutCenter(theta:Number):void 
    {
      if (theta == 0)
        return;
      
      // Standard Flex components define rotation wrt the top left corner,
      // but imported SWCs define rotation wrt the center of the UIMovieClip.
      if (drawable is UIMovieClip)
      {
        drawable.rotation += theta;
      }
      else
      {
        var offset:Point = new Point(drawable.width / 2, drawable.height / 2);
        
        var m:Matrix = new Matrix();
        
        m.translate(-offset.x, -offset.y);
        m.rotate(theta * Geometry.degreesToRadians);
        m.translate(offset.x, offset.y);
        
        m.concat(drawable.transform.matrix);
        
        drawable.transform.matrix = m;
      }
    } 
    
    /** 
     * Gets the current direction this object is facing (with respect to (width/2, 0) object coordinates). 
     */
    public function getDirection():Vector2
    {
      var currentRotation:Number = drawable.rotation * Geometry.degreesToRadians;
      
      var dir:Vector2 = new Vector2();
      dir.x = Math.sin(currentRotation);
      dir.y = -Math.cos(currentRotation);
      dir.normalize(1.0);
      
      return dir;
    }
  }
}