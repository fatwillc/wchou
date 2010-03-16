package units.asteroids
{
  import __AS3__.vec.Vector;
  
  import mx.controls.Image;
  
  import utils.Vector2;

  public class LargeAsteroid extends Asteroid
  {
    private const ANGULAR_V:Number = 20;
    
    public function LargeAsteroid(position:Vector2)
    {
      super(40, position);
      
      v = Vector2.randomUnitCircle();
      v.normalize(30);
    
      w = ANGULAR_V;
    }
    
    override public function split():Vector.<Asteroid> 
    {
      super.split();
      
      var A:Vector.<Asteroid> = new Vector.<Asteroid>();
      for (var i:int = 0; i < 3; i++)
      {
        var asteroid:Asteroid = new MediumAsteroid(center);
        A.push(asteroid);
      }
      return A;
    }
    
  }
}