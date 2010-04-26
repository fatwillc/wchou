package physical
{
  import utils.Vector2;
  
  /**
   * A GameObject component that handles physics state.
   */
  public class PhysicsComponent
  {
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /** 
     * Amount of "bounce" after a collision. 
     */
    public const restitutionCoefficient:Number = 0.8;
    
    /** 
     * Coefficient of friction for linear forces. 
     */
    private const linearDrag:Number = 0.0;
    
    /** 
     * Rotational pseudo-friction coefficient. 
     */
    private const rotationalDrag:Number = 0.02;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////  
    
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
    
    /**
     * Bounding area of this object (for collisions).
     */
    public var boundingCircle:Circle;

    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////  
    
    public function PhysicsComponent(isPinned:Boolean = false, F:Vector2 = null, v:Vector2 = null, p:Vector2 = null, w:Number = 0, mass:Number = 1)
    {
      this.isPinned = isPinned;
      
      this.F = new Vector2();
      if (F != null)
        this.F.copy(F);
      
      this.v = new Vector2();
      if (v != null)
        this.v.copy(v);
      
      this.p = new Vector2();
      if (p != null)
        this.p.copy(p);
      
      this.w = w;
      
      this.mass = mass;
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////////////////////////  
    
    public function step(dT:Number):void
    {
      // Drag forces.
      F.x -= v.x * linearDrag;
      F.y -= v.y * linearDrag;
      w *= 1 - rotationalDrag;
      
      // Apply forces.
      v.acc(F, 1.0/mass);

      // Perform step.
      if (!isPinned) 
      {
        p.x += dT * v.x;
        p.y += dT * v.y;
      }
    }
    
    /**
     * Test for intersection between this physics and another.
     * 
     * @param other - the other PhysicsCOmponent to check intersection with.
     * 
     * @return If intersects, returns contact normal (may not be unit length). 
     *         Otherwise, returns null.
     */
    public function intersects(other:PhysicsComponent):Vector2
    {
      var thisToOther:Vector2 = p.subtract(other.p);
      
      var overlap:Number = thisToOther.length() - (boundingCircle.radius + other.boundingCircle.radius);
      
      if (overlap < 0)
        return thisToOther;
      else
        return null;
    }
    
    /**
     * Clears the force accumulator.
     */
    public function clearForces():void
    {
      F.zero();
    }
    
    /**
     * Clones this PhysicsComponent.
     * 
     * @return A new PhysicsComponent with the same states.
     */
    public function clone():PhysicsComponent
    {
      return new PhysicsComponent(isPinned, F, v, p, w, mass);
    }
  }
}