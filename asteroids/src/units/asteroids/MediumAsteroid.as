package units.asteroids
{
  import __AS3__.vec.Vector;
  
  import mx.controls.Image;
  
  import utils.Vector2;

  public class MediumAsteroid extends Asteroid
  {    
    private const LINEAR_V:Number = 70;
    private const ANGULAR_V:Number = 50;
    
    [Embed(source='assets/units/asteroids/medium-1.swf')]
    private var medium1:Class;
    [Embed(source='assets/units/asteroids/medium-2.swf')]
    private var medium2:Class;
    [Embed(source='assets/units/asteroids/medium-3.swf')]
    private var medium3:Class;
    
    public function MediumAsteroid(position:Vector2, inertia:Vector2)
    {
      super();
      
      _graphics = new Image();

      switch (int(Math.random() * 3))
      {
        case 0: 
          (graphics as Image).source = medium1;
          break;
        case 1: 
          (graphics as Image).source = medium2;
          break;
        case 2: 
          (graphics as Image).source = medium3;
          break;
      }

      graphics.width = graphics.height = 40;
      
      _graphics.rotation = Math.random() * 360;
      
      graphics.x += position.x - center.x;
      graphics.y += position.y - center.y;

      v = Vector2.randomUnitCircle(LINEAR_V);
      v.acc(inertia, 1);
      
      w = ANGULAR_V;
    }
    
    override public function split():Vector.<Asteroid> 
    {
      super.split();
      
      var A:Vector.<Asteroid> = new Vector.<Asteroid>();
      for (var i:int = 0; i < 3; i++)
      {
        var asteroid:Asteroid = new SmallAsteroid(center, v);
        A.push(asteroid);
      }
      return A;
    }
  }
}