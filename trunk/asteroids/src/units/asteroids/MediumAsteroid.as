package units.asteroids
{
  import __AS3__.vec.Vector;
  
  import mx.controls.Image;
  
  import utils.Vector2;

  public class MediumAsteroid extends Asteroid
  {
    private const ANGULAR_V:Number = 50;
    
    public function MediumAsteroid(position:Vector2)
    {
      super(20, position);
      
      v = Vector2.randomUnitCircle();
      v.normalize(70);
      
      w = 50;
    }
    
    override public function split():Vector.<Asteroid> 
    {
      super.split();
      
      var A:Vector.<Asteroid> = new Vector.<Asteroid>();
      for (var i:int = 0; i < 3; i++)
      {
        var asteroid:Asteroid = new SmallAsteroid(center);
        A.push(asteroid);
      }
      return A;
    }
    
  }
}