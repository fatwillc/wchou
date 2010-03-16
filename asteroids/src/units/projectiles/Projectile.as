package units.projectiles
{
  import core.*;
  
  import mx.controls.Image;
  
  import utils.Vector2;

  /** 
   * An abstract projectile. 
   * The graphics of a projectile is a square image control.
   * Should not be instanced directly. 
   */
  public class Projectile extends GameObject
  {
    /** Amount of time in seconds from birth to death. */
    protected var lifeSpan:Number = 1.25;

    /** Current age in seconds. */
    protected var age:Number = 0;
    
    public function Projectile(position:Vector2, direction:Vector2)
    {
      super();
      
      _graphics = new Image();

      graphics.x = position.x;
      graphics.y = position.y;
      
      graphics.cacheAsBitmap = true;
      
      v.copy(direction);
    }
    
    override public function update(dt:Number):void 
    {
      age += dt;
      
      graphics.alpha = Math.sqrt((lifeSpan - age) / lifeSpan);
      
      if (age > lifeSpan) 
        state = ObjectState.DESTROY;
    }    
  }
}