package core 
{
  import flash.display.BitmapData;
  
  import graphical.GraphicsComponent;
  
  import physical.*;

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
     * Handles physics and physical state of object.
     */
    public function get physics():PhysicsComponent { return _physics; }
    protected var _physics:PhysicsComponent;
    
    /**
     * Handles graphics and rendering of object.
     */
    public function get graphics():GraphicsComponent { return _graphics; }
    protected var _graphics:GraphicsComponent;

    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////

    public function GameObject() 
    {
      super();
      
      _physics = new PhysicsComponent();
      _graphics = new GraphicsComponent();
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
      if (state != ObjectState.ACTIVE)
        return;
      
      update(dT);
      
      physics.step(dT);
      
      graphics.update(physics.p, physics.w);
      
      checkBoundaries();
      
      // Kill object if it exceeded its lifespan.
      _age += dT;
      if (_lifespan > 0 && _age > _lifespan)
        state = ObjectState.DESTROY;
    }
    
    /**
     * Blits the graphics of this object to a given bitmap buffer.
     * 
     * @param buffer - the bitmap buffer to blit to.
     */
    public function draw(buffer:BitmapData):void
    {
      if (graphics == null)
      {
        throw new Error("GraphicsComponent has not been initialized.");
        return;
      }
      
      graphics.draw(buffer, physics.p);
    }

    /**
     * Initiates death sequence of the game object.
     */
    public function die():void 
    {
      state = ObjectState.DESTROY;
    }
    
    /** 
     * Confines the object to the dimensions of its graphical parent.
     * Bounces off the edges of those dimensions with a certain restitution factor.
     */
    private function checkBoundaries():void 
    {
      if (graphics.drawable == null || graphics.drawable.parent == null)
        return;
      
      var pX:Number = physics.p.x;
      var pY:Number = physics.p.y;
      var radius:Number = physics.boundingCircle.radius;

      var w:Number = graphics.drawable.parent.width;
      var h:Number = graphics.drawable.parent.height;
      
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