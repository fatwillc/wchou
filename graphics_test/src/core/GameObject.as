package core 
{
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.geom.ColorTransform;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import mx.flash.UIMovieClip;
  
  import utils.Geometry;
  import utils.Vector2;

  /** 
   * The base class for interactive game objects.
   */
  public class GameObject implements IBoundingCircle 
  {
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /** 
     * Coefficient of friction for linear forces. 
     */
    private const LINEAR_DRAG:Number = 0.0;
    
    /** 
     * Rotational pseudo-friction coefficient. 
     */
    private const ROTATIONAL_DRAG:Number = 0.02;
    
    /** 
     * Coefficient of restitution (amount of bounce after a collision). 
     */
    private const RESTITUTION:Number = 0.8;
      
    ///////////////////////////////////////////////////////////////////////////
    // PHYSICAL STATE VARIABLES
    ///////////////////////////////////////////////////////////////////////////
      
    /** 
     * Current state of this object. 
     */
    public var state:uint = ObjectState.ACTIVE;
    
    /** 
     * If true, will be pinned to current position. 
     */
    public var isPinned:Boolean = false;
    
    /** 
     * Current aggregate force vector. 
     */
    public var F:Vector2;
    
    /** 
     * Current velocity. 
     */
    public var v:Vector2;
    
    /** 
     * Current position. 
     */
    public var p:Vector2; 
    
    /** 
     * Current angular velocity in degrees. 
     */
    public var w:Number;
    
    /** 
     * Mass of the object. 
     */
    public var mass:Number;
    
    ///////////////////////////////////////////////////////////////////////////
    // LIFESPAN VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** 
     * The current age of this object. 
     * The object destroys itself once its age exceeds its lifespan.
     */
    public function get age():Number { return _age; }
    protected var _age:Number = 0;
    
    /** 
     * The lifespan of this object. 
     * A value <= 0 represents an infinite lifespan. 
     * 
     * @default 0
     */
    public function get lifespan():Number { return _lifespan; }
    protected var _lifespan:Number = 0;

    ///////////////////////////////////////////////////////////////////////////
    // GRAPHICS VARIABLES
    ///////////////////////////////////////////////////////////////////////////

    /** 
     * Visual representation of object. 
     */
    public function get graphics():Sprite { return _graphics; }
    protected var _graphics:Sprite;
    
    /**
     * Bitmap data of the graphics object.
     * If null, constructed on next draw() cycle.
     */
    private var cachedGraphicsBitmap:BitmapData;
    
    /**
     * Clears the current cached graphics bitmap data for recomputation on next draw() cycle.
     */
    public function clearGraphicsCache():void 
    {
      cachedGraphicsBitmap = null;
    }

    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////

    public function GameObject() 
    {
      super();
      
      F = new Vector2();
      v = new Vector2();
      p = new Vector2();
      w = 0;
      mass = 1;
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////////////////////////
     
    /** 
     * Applies custom subclass forces and actions. 
     */
    public function update(dt:Number):void 
    {
      // To be implemented by subclasses.
    }
    
    /** 
     * Steps position by a specified timestep and updates state. 
     */
    public function step(dt:Number):void 
    {
      // Subclass force accumulations, etc.
      update(dt);
      
      // Drag forces.
      F.x -= v.x * LINEAR_DRAG;
      F.y -= v.y * LINEAR_DRAG;
      w *= 1 - ROTATIONAL_DRAG;
      
      // Apply forces.
      v.acc(F, 1.0/mass);

      // Perform step.
      var center:Vector2 = getCenter();
      if (!isPinned) 
      {
        p.x += dt * v.x;
        p.y += dt * v.y;
        
        moveGraphicsToP();
        
        if (Math.abs(w) > 0)         
          rotateAboutCenter(w);
      }
      
      checkBoundaries();
      
      // Kill object if it exceeded its lifespan.
      _age += dt;
      if (_lifespan > 0 && _age > _lifespan)
        state = ObjectState.DESTROY;
      
      // Clear forces.
      F.zero();
    }
    
    public function draw(buffer:BitmapData):void
    {
      if (cachedGraphicsBitmap == null)
      {
        cachedGraphicsBitmap = new BitmapData(graphics.width, graphics.height, true, 0x000000);
        cachedGraphicsBitmap.draw(graphics, null, graphics.transform.colorTransform);
      }
      
      var sourceRect:Rectangle = new Rectangle(0, 0, graphics.width, graphics.height);
      var destPoint:Point = new Point(p.x - graphics.width/2, p.y - graphics.height/2);
      buffer.copyPixels(cachedGraphicsBitmap, sourceRect, destPoint, cachedGraphicsBitmap, new Point(), true);
    }

    /**
     * Initiates death sequence of the game object.
     */
    public function die():void 
    {
      state = ObjectState.DESTROY;
    }
    
    /** 
     * Gets the current direction this object is facing (with respect to (width/2, 0) object coordinates). 
     */
    public function getDirection():Vector2
    {
      var currentRotation:Number = graphics.rotation * Geometry.DEGREES_TO_RADIANS;
      
      var dir:Vector2 = new Vector2();
      dir.x = Math.sin(currentRotation);
      dir.y = -Math.cos(currentRotation);
      dir.normalize(1.0);
      
      return dir;
    }  
    
    /** 
     * Move the graphics object such that its center lies at p. 
     */
    public function moveGraphicsToP():void
    {
      // Standard Flex components define rotation wrt the top left corner,
      // but imported SWCs define rotation wrt the center of the UIMovieClip.
      if (graphics is UIMovieClip)
      {
        graphics.x = p.x;
        graphics.y = p.y;
      } 
      else
      {
        if (w == 0)
        {
          graphics.x = p.x - graphics.width / 2;
          graphics.y = p.y - graphics.height / 2;
        }
        else
        {
          // TODO Test this.
          
          var graphicsOrigin:Vector2 = new Vector2(p.x, p.y);
          
          var u:Vector2 = getDirection();
          var v:Vector2 = new Vector2(u.y, -u.x);
          graphicsOrigin.acc(u, graphics.height / 2);
          graphicsOrigin.acc(v, graphics.width / 2);
          
          graphics.x = graphicsOrigin.x;
          graphics.y = graphicsOrigin.y;
        }
      }
    }   
    
    public function getCenter():Vector2 
    {
      return p;
    }
    
    public function getRadius():Number
    {
      return Math.min(graphics.width, graphics.height) / 2;
    }
    
    /** 
     * Rotates graphics object about its center. 
     * 
     * @param angle - The amount to rotate in degrees.
     */
    private function rotateAboutCenter(angle:Number):void 
    {            
      // Standard Flex components define rotation wrt the top left corner,
      // but imported SWCs define rotation wrt the center of the UIMovieClip.
      if (graphics is UIMovieClip)
      {
        graphics.rotation += angle;
      }
      else
      {
        var offset:Point = new Point(graphics.width / 2, graphics.height / 2);
        
        var m:Matrix = new Matrix();
        
        m.translate(-offset.x, -offset.y);
        m.rotate(angle * Geometry.DEGREES_TO_RADIANS);
        m.translate(offset.x, offset.y);
        
        m.concat(graphics.transform.matrix);
        
        graphics.transform.matrix = m;
      }
    }    
    
    /** 
     * Confines the object to the dimensions of its graphical parent.
     * Bounces off the edges of those dimensions with a certain restitution factor.
     */
    private function checkBoundaries():void 
    {
      if (graphics.parent == null)
        return;
      
      var center:Vector2 = getCenter();
      var radius:Number = getRadius();

      var w:Number = graphics.parent.width;
      var h:Number = graphics.parent.height;
      
      if (center.x - radius < 0) 
      {
        p.x += radius - center.x;
        v.x *= -RESTITUTION;
      }
      
      if (center.x + radius > w) 
      {
        p.x -= center.x + radius - w;
        v.x *= -RESTITUTION;
      }
      
      if (center.y - radius < 0) 
      {
        p.y += radius - center.y;
        v.y *= -RESTITUTION;
      } 
      
      if (center.y + radius > h) 
      {
        p.y -= center.y + radius - h;
        v.y *= -RESTITUTION;
      }
    }
    
  }
}