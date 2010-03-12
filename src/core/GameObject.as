package core {
  
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.geom.Matrix;
  import flash.geom.Point;
  
  import mx.effects.Fade;
  import mx.events.EffectEvent;
  import mx.flash.UIMovieClip;
  
  import utils.Geometry;
  import utils.Vector2;

  /** An interactive object and Newtonian body (sans rotational forces). */
  public class GameObject implements IBoundingCircle  {
    
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /** Coefficient of friction. */
    private const F_DRAG:Number = 0.01;
    
    /** Coefficient of restitution (amount of bounce after a collision). */
    private const RESTITUTION:Number = 0.5;
      
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
      
    /** Current state of this object. */
    public var state:String = ObjectState.ACTIVE;
    
    /** If true, will be pinned to current position. */
    public var isPinned:Boolean = false;
    
    /** Current aggregate force vector. */
    public var F:Vector2;
    
    /** Current velocity. */
    public var v:Vector2;
    
    /** Mass of the object. */
    public var mass:Number;
    
    ///////////////////////////////////////////////////////////////////////////
    // PROPERTIES & OTHER
    ///////////////////////////////////////////////////////////////////////////
    
    /** Visual representation of object. */
    public function get graphics():DisplayObject { return _graphics; }
    protected var _graphics:Sprite;
    
    /** Death transition/animation. */
    private var deathFade:Fade;
    
    public function GameObject(mass:Number = 1.0) {
      super();
      
      F = new Vector2();
      v = new Vector2();
      this.mass = mass;
      
      deathFade = new Fade();
      deathFade.alphaFrom = 1;
      deathFade.alphaTo = 0;
      deathFade.addEventListener(EffectEvent.EFFECT_END, function():void { state = ObjectState.DESTROY; });
    }
    
    /** Steps position by a specified timestep. */
    public function step(dt:Number):void {
      // Drag force.
      F.x -= v.x * F_DRAG;
      F.y -= v.y * F_DRAG;
      
      // Apply forces.
      v.acc(F, 1.0/mass);
      
      checkBoundaries();
      
      // Perform step.
      if (!isPinned) {
        _graphics.x += dt * v.x;
        _graphics.y += dt * v.y;
      }
      
      if (Symptom.DEBUG && graphics.parent != null) {
        // Draw bounding circle.
        (graphics.parent as Sprite).graphics.lineStyle(1, 0xff0000);
        (graphics.parent as Sprite).graphics.drawCircle(center.x, center.y, radius);
      }
    }
    
    /** 
     * Confines the object to the dimensions of its graphical parent.
     * Bounces off the edges of those dimensions with a certain restitution factor.
     */
    private function checkBoundaries():void {
      if (graphics.parent == null)
        return;
      
      var c:Vector2 = center;
      var r:Number = radius;
      
      if (c.x - r < 0) {
        graphics.x += r - c.x;
        v.x *= -RESTITUTION;
      }
      
      if (c.x + r > graphics.parent.width) {
        graphics.x -= c.x + r - graphics.parent.width;
        v.x *= -RESTITUTION;
      }
      
      if (c.y - r < 0) {
        graphics.y += r - c.y;
        v.y *= -RESTITUTION;
      } 
      
      if (c.y + r > graphics.parent.height) {
        graphics.y -= c.y + r - graphics.parent.height;
        v.y *= -RESTITUTION;
      }
    }
    
    /** Applies custom subclass forces and actions. */
    public function update(dt:Number):void {
      // To be implemented by subclasses.
    }

    /**
     * Initiates death sequence of the game object.
     * Default behavior is a quick fade out and removal.
     */
    public function die():void {
      state = ObjectState.INACTIVE;
      deathFade.play([graphics]);
    }
    
    public function get direction():Vector2
    {
      var currentRotation:Number = graphics.rotation * Geometry.DEGREES_TO_RADIANS;
      
      var dir:Vector2 = new Vector2();
      dir.x = Math.sin(currentRotation);
      dir.y = -Math.cos(currentRotation);
      dir.normalize(1.0);
      
      return dir;
    }    
    
    public function get center():Vector2 {
      // Standard Flex components define rotation wrt the top left corner,
      // but imported SWCs define rotation wrt the center of the UIMovieClip.
      if (graphics is UIMovieClip)
      {
        return new Vector2(graphics.x, graphics.y);
      } 
      else
      {
        var center:Vector2 = new Vector2(graphics.x, graphics.y);
        
        var u:Vector2 = direction;
        var v:Vector2 = new Vector2(u.y, -u.x);
        center.acc(u, -graphics.height / 2);
        center.acc(v, -graphics.width / 2);
        
        return center;
      }
    }
    
    public function get radius():Number
    {
      return Math.min(graphics.width, graphics.height) / 2;
    }
    
    /** 
     * Rotates graphics object about its center. 
     * 
     * @param angle - The amount to rotate in degrees.
     */
    protected function rotateAboutCenter(angle:Number):void 
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
    
  }
}