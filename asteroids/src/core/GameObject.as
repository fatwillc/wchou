package core 
{  
  import flash.display.DisplayObject;
  import flash.display.Graphics;
  import flash.geom.Matrix;
  import flash.geom.Point;
  
  import mx.core.UIComponent;
  import mx.flash.UIMovieClip;
  
  import utils.Geometry;
  import utils.Vector2;

  /** A game object with pseudo-Newtonian properties. */
  public class GameObject implements IBoundingSphere
  {
    public static const K:Number = 1.0;
    
    /** The current state of this game object. @see ObjectState for more details. */
    public var state:String = ObjectState.ACTIVE;
    
    /** The visual representation of this game object. */
    protected var _graphics:DisplayObject;
    public function get graphics():DisplayObject { return _graphics; }
    
    /** Aggregate force. */
    protected var F:Vector2 = new Vector2();
    public function get force():Vector2 { return F; }
    
    /** Velocity. */
    protected var v:Vector2 = new Vector2();
    public function get velocity():Vector2 { return v; }
    
    /** Mass. */
    protected var m:Number;
    public function get mass():Number { return m; }
    
    /** Angular velocity. */
    protected var w:Number = 0;
    
    public function GameObject(mass:Number = 1.0) 
    {
      super();
      
      m = mass;
    }
    
    /**
     * Updates the state of this game object, including all timestepping calculations.
     * 
     * @param dt - Width of time step.
     * @param input - Current input state.
     */
    final public function step(dt:Number):void 
    {
      F.zero();
      
      update(dt);
      
      // Apply forces.      
      v.acc(F, 1.0/m);
      
      // Perform Euler step.
      graphics.x += dt * v.x;
      graphics.y += dt * v.y;

      rotateAboutCenter(dt * w);
      
      if (Asteroids.DEBUG) 
      {
        // Draw bounding spheres.
        if (graphics.parent != null)
        {
          var g:Graphics = (graphics.parent as UIComponent).graphics;
          
          g.lineStyle(1, 0x00ff00, 0.5);
          g.drawCircle(center.x, center.y, radius);
        }
      }
    }
    
    /** 
     * Custom update and force accumulation actions for subclasses go here.
     */
    public function update(dt:Number):void 
    {
      // To be implemented by subclasses.
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
    
    public function get center():Vector2
    {
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
      // Make bounding sphere radius a bit smaller than the shorter side.
      return 0.9 * Math.min(graphics.width, graphics.height) / 2;
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
  }
}