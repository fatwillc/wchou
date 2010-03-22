package particle
{
  import core.GameObject;
  
  import flash.geom.ColorTransform;
  import flash.geom.Transform;
  
  import mx.controls.Image;
  
  import utils.Vector2;

  /**
   * A particle emitted from the particle system.
   * Should not be instanced directly.
   */
  public class Particle extends GameObject
  {
    public static const ORB:String = "orb";
    
    [Embed(source='assets/particle/orb.swf')]
    private static var _orb:Class;
    
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