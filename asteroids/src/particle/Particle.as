package particle
{
  import core.GameObject;
  
  import mx.controls.Image;
  
  import utils.Vector2;

  /**
   * A particle emitted from the particle system.
   */
  internal class Particle extends GameObject
  {
    public static const ORB:String = "orb";
    
    public static const ROCK:String = "rock";
    
    [Embed(source='assets/particle/orb.swf')]
    private static var _orb:Class;
    
    [Embed(source='assets/units/asteroids/small-1.swf')]
    private static var _rock1:Class;
    [Embed(source='assets/units/asteroids/small-2.swf')]
    private static var _rock2:Class;
    
    public function Particle(type:String, lifespan:Number, position:Vector2, velocity:Vector2)
    {
      super();
      
      _lifespan = lifespan;
      
      switch (type) 
      {
        case ORB:
          var img:Image = new Image();
          img.source = _orb;
          _graphics = img;
          break;
        case ROCK:
          var img:Image = new Image();
          
          switch ((Math.random() * 2) as int)  
          {
            case 0: img.source = _rock1; break;
            case 1: img.source = _rock2; break;
          }
          
          _graphics = img;
          break;
        default:
          throw new Error("Unrecognized particle type.");
      }
      
      graphics.width = 15;
      graphics.height = 15;
      
      graphics.x = position.x - graphics.width / 2;
      graphics.y = position.y - graphics.height / 2;
      
      v.copy(velocity);
    }
    
    override public function update(dt:Number, cameraTransform:Vector2):void 
    {
      super.update(dt, cameraTransform);
      
      // TODO Modularize properties that change as a particle ages.
      
      graphics.alpha = (lifespan - age) / lifespan;
      
      graphics.width -= 1;
      graphics.height -= 1;
    }
  }
}