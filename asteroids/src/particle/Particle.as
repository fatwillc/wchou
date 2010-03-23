package particle
{
  import __AS3__.vec.Vector;
  
  import core.GameObject;
  
  import mx.controls.Image;
  
  import utils.Vector2;

  /**
   * A particle emitted from the particle system.
   */
  public class Particle extends GameObject
  {
    ///////////////////////////////////////////////////////////////////////////
    // PARTICLE TYPES
    ///////////////////////////////////////////////////////////////////////////
    
    public static const ORB:String = "orb";
    
    [Embed(source='assets/particle/orb.swf')]
    private static var _orb:Class;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** Current update functions of this particle, run on each update. */
    private var updateFunctions:Vector.<Function>;
    
    public function Particle(type:String, size:Number, lifespan:Number, position:Vector2, velocity:Vector2, updateFunctions:Vector.<Function>)
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
      
      graphics.width = graphics.height = size;
      
      graphics.x = position.x - graphics.width / 2;
      graphics.y = position.y - graphics.height / 2;
      
      v.copy(velocity);
      
      this.updateFunctions = updateFunctions;
    }
    
    override public function update(dt:Number, cameraTransform:Vector2):void 
    {
      super.update(dt, cameraTransform);
      
      for each (var fn:Function in updateFunctions)
        fn.call(this);
    }
    

  }
}