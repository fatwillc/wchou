package units.asteroids
{
  import flash.events.Event;
  
  import mx.controls.Image;
  
  import utils.Vector2;

  public class SmallAsteroid extends Asteroid
  {
    private const LINEAR_V:Number = 110;
    private const ANGULAR_V:Number = 150;
    
    [Embed(source='assets/units/asteroids/small-1.swf')]
    private var small1:Class;
    [Embed(source='assets/units/asteroids/small-2.swf')]
    private var small2:Class;
    
    public function SmallAsteroid(position:Vector2)
    {
      super();
      
      _graphics = new Image();
      
      switch (int(Math.random() * 2))
      {
        case 0: 
          (_graphics as Image).source = small1;
          break;
        case 1: 
          (_graphics as Image).source = small2;
          break;
      }
      
      graphics.width = graphics.height = 25;
      
      _graphics.rotation = Math.random() * 360;
      
      graphics.x += position.x - center.x;
      graphics.y += position.y - center.y;
      
      v = Vector2.randomUnitCircle();
      v.normalize(LINEAR_V);
      
      w = ANGULAR_V;
      
      reward = 50;
    }
  }
}