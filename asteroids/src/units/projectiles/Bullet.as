package units.projectiles
{
  import mx.controls.Image;
  
  import utils.Vector2;

  /** Bullets are shot from the rocket. */
  public class Bullet extends Projectile
  {
    [Embed(source='assets/units/bullet.swf')]
    private var bullet:Class;
    
    public function Bullet(position:Vector2, inertia:Vector2, direction:Vector2)
    {
      super(position, inertia, direction, 350);
      
      (graphics as Image).source = bullet;
    }
    
  }
}