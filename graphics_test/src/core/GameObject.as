package core 
{
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import mx.flash.UIMovieClip;
  
  import physical.*;
  
  import utils.Geometry;
  import utils.Vector2;

  /** 
   * The base class for interactive game objects.
   */
  public class GameObject
  {
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
      
    /** 
     * Current state of this object. 
     */
    public var state:uint = ObjectState.ACTIVE;

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

    /**
     * Physics state and handler of object.
     */
    public function get physics():PhysicsComponent { return _physics; }
    protected var _physics:PhysicsComponent;

    /** 
     * Visual representation of object. 
     */
    public function get graphics():DisplayObject { return _graphics; }
    protected var _graphics:DisplayObject;
    
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
      
      _physics = new PhysicsComponent();
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////////////////////////
     
    /** 
     * Applies custom subclass forces and actions.
     * 
     * @param dT - size of the timestep.
     */
    public function update(dT:Number):void 
    {
      // To be implemented by subclasses.
    }
    
    /** 
     * Steps position by a specified timestep and updates state. 
     * 
     * @param dT - size of the timestep.
     */
    public function step(dT:Number):void 
    {
      // Subclass force accumulations, etc.
      update(dT);
      
      physics.step(dT);
      
      // TODO Modularize this into a GraphicsComponent.
      moveGraphicsToP();
      
      // TODO Modularize this into a GraphicsComponent.
      if (Math.abs(physics.w) > 0)         
        rotateAboutCenter(physics.w);
      
      checkBoundaries();
      
      // Kill object if it exceeded its lifespan.
      _age += dT;
      if (_lifespan > 0 && _age > _lifespan)
        state = ObjectState.DESTROY;
      
      physics.clearForces();
    }
    
    /**
     * Blits the graphics of this object to a given bitmap buffer.
     * 
     * @param buffer - the bitmap buffer to blit to.
     */
    public function draw(buffer:BitmapData):void
    {
      if (cachedGraphicsBitmap == null)
      {
        cachedGraphicsBitmap = new BitmapData(graphics.width, graphics.height, true, 0x000000);
        cachedGraphicsBitmap.draw(graphics, null, graphics.transform.colorTransform);
      }
      
      var sourceRect:Rectangle = new Rectangle(0, 0, graphics.width, graphics.height);
      var destPoint:Point = new Point(physics.p.x - graphics.width/2, physics.p.y - graphics.height/2);
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
        graphics.x = physics.p.x;
        graphics.y = physics.p.y;
      } 
      else
      {
        if (physics.w == 0)
        {
          graphics.x = physics.p.x - graphics.width / 2;
          graphics.y = physics.p.y - graphics.height / 2;
        }
        else
        {
          // TODO Test this.
          
          var graphicsOrigin:Vector2 = new Vector2();
          graphicsOrigin.copy(physics.p);
          
          var u:Vector2 = getDirection();
          var v:Vector2 = new Vector2(u.y, -u.x);
          graphicsOrigin.acc(u, graphics.height / 2);
          graphicsOrigin.acc(v, graphics.width / 2);
          
          graphics.x = graphicsOrigin.x;
          graphics.y = graphicsOrigin.y;
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
      // Standard Flex components define rotation wrt the top left corner,
      // but imported SWCs define rotation wrt the center of the UIMovieClip.
      if (graphics is UIMovieClip)
      {
        graphics.rotation += theta;
      }
      else
      {
        var offset:Point = new Point(graphics.width / 2, graphics.height / 2);
        
        var m:Matrix = new Matrix();
        
        m.translate(-offset.x, -offset.y);
        m.rotate(theta * Geometry.DEGREES_TO_RADIANS);
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
      
      var pX:Number = physics.p.x;
      var pY:Number = physics.p.y;
      var radius:Number = physics.boundingCircle.radius;

      var w:Number = graphics.parent.width;
      var h:Number = graphics.parent.height;
      
      if (pX - radius < 0) 
      {
        physics.p.x += radius - pX;
        physics.v.x *= -physics.restitutionCoefficient;
      }
      
      if (pX + radius > w) 
      {
        physics.p.x -= pX + radius - w;
        physics.v.x *= -physics.restitutionCoefficient;
      }
      
      if (pY - radius < 0) 
      {
        physics.p.y += radius - pY;
        physics.v.y *= -physics.restitutionCoefficient;
      } 
      
      if (pY + radius > h) 
      {
        physics.p.y -= pY + radius - h;
        physics.v.y *= -physics.restitutionCoefficient;
      }
    }
  }
}