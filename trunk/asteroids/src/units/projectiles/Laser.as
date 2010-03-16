package units.projectiles
{
  import utils.Vector2;
  import mx.controls.Image;

  /** Lasers are shot from ufos. */
  public class Laser extends Projectile
  {
    /** Speed of the laser. */
    private const SPEED:Number = 200;
        
    [Embed(source='assets/units/laser.swf')]
    private var _source:Class;
    
    public function Laser(position:Vector2, direction:Vector2)
    {
      super(position, direction);
      
      (graphics as Image).source = _source;
      
      v.normalize(SPEED);
    }
    
  }
}