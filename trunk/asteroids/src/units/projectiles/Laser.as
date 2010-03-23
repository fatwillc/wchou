package units.projectiles
{
  import mx.controls.Image;
  
  import utils.Vector2;

  /** Lasers are shot from ufos. */
  public class Laser extends Projectile
  {
    [Embed(source='assets/units/laser.swf')]
    private var laser:Class;
    
    public function Laser(position:Vector2, inertia:Vector2, direction:Vector2)
    {
      super(position, inertia, direction, 250);
      
      (graphics as Image).source = laser;
    }
  }
}