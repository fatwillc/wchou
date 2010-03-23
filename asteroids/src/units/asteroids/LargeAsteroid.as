package units.asteroids
{
  import __AS3__.vec.Vector;
  
  import flash.events.Event;
  
  import mx.controls.Image;
  
  import utils.Vector2;

  public class LargeAsteroid extends Asteroid
  {
    private const LINEAR_V:Number = 30;
    private const ANGULAR_V:Number = 20;
    
    [Embed(source='assets/units/asteroids/large.swf')]
    private var large:Class;
    
    public function LargeAsteroid(position:Vector2)
    {
      super();
      
      _graphics = new Image();
      (graphics as Image).source = large;
      
      graphics.width = graphics.height = 80;
      
      _graphics.rotation = Math.random() * 360;
      
      graphics.x += position.x - center.x;
      graphics.y += position.y - center.y;
              
      v = Vector2.randomUnitCircle(LINEAR_V);
    
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