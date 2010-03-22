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
    public function Projectile(position:Vector2, inertia:Vector2, direction:Vector2, speed:Number)
    {
      super();
      
      _graphics = new Image();

      graphics.x = position.x;
      graphics.y = position.y;
      
      graphics.cacheAsBitmap = true;
      
      v.copy(inertia);
      v.acc(direction, speed);
      
      _lifespan = 1.5;
    }
    
    override public function update(dt:Number, cameraTransform:Vector2):void 
    {
      super.update(dt, cameraTransform);
      
      _age += dt;
      
      // Fade projectile gradually (sqrt curve) so it doesn't disappear
      // suddenly when it dies.
      graphics.alpha = Math.sqrt((_lifespan - _age) / _lifespan);
      
      if (_age > _lifespan) 
        state = ObjectState.DESTROY;
    }    
  }
}