package units.projectiles
{
  import utils.Vector2;
  import mx.controls.Image;

  /** Bullets are shot from the rocket. */
  public class Bullet extends Projectile
  {
    /** Speed of the bullet. */
    private const SPEED:Number = 300;
    
    [Embed(source='assets/units/bullet.swf')]
    private var _source:Class;
    
    public function Bullet(position:Vector2, direction:Vector2)
    {
      super(position, direction);
      
      (graphics as Image).source = _source;
      
      v.normalize(SPEED);
    }
    
  }
}