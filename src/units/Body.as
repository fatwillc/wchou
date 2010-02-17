package units {
  
  import mx.controls.Image;
  
  import utils.Vector2;

  /** A Newtonian body (sans rotational forces). */
  public class Body extends Image  {
    
    /** Current aggregate force vector. */
    public var F:Vector2;
    
    /** Current velocity. */
    public var v:Vector2;
    
    /** Mass of the body. */
    public var mass:Number;
    
    /** 
     * Is this body interactive with other bodies? 
     * If not, will not collide with anything in the level and will
     * permanently be pinned to initial position.
     */
    public var isInteractive:Boolean = true;
    
    public function Body(mass:Number = 1.0) {
      super();
      
      F = new Vector2();
      v = new Vector2();
      this.mass = mass;
    }
    
    /** Steps position by a specified timestep. */
    public function step(dt:Number):void {
      x += dt * v.x;
      y += dt * v.y;
    }
    
    /** Applies acceleration to velocity. */
    public function applyF():void {
      v.acc(F, 1.0/mass);
    }
    
  }
}