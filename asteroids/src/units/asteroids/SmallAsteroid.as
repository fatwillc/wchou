package units.asteroids
{
  import mx.controls.Image;
  
  import utils.Vector2;

  public class SmallAsteroid extends Asteroid
  {
    private const ANGULAR_V:Number = 150;
    
    public function SmallAsteroid(position:Vector2)
    {
      super(10, position);
      
      v = Vector2.randomUnitCircle();
      v.normalize(110);
      
      w = ANGULAR_V;
      
      reward = 50;
    }
    
  }
}