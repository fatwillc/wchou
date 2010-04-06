package particle
{
  import __AS3__.vec.Vector;
  
  import core.GameObject;
  import core.ObjectState;
  
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
    
    public static const ORB:int = -1046942;
    
    [Embed(source='assets/particle/orb.swf')]
    private static var _orb:Class;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    public var objectID:Number = Math.random();
    
    /** Current update functions of this particle, run on each update. */
    private var updateFunctions:Vector.<Function>;
    
    /** 
     * Default particle constructor. 
     * State initialization must be called via initialize(). 
     */
    public function Particle()
    {
      super();
      
      _graphics = new Image();
    }
    
    /**
     * Initializes the state of this particle. 
     * Must be called before usage in a particle system.
     */ 
    public function initialize(type:int, size:Number, lifespan:Number, position:Vector2, velocity:Vector2, updateFunctions:Vector.<Function>):void
    {
      ///////////////////////////////////////////
      // Reset state.
      
      state = ObjectState.ACTIVE;
      _age = 0;
      
      ///////////////////////////////////////////
      // Set initialization parameters.
      
      _lifespan = lifespan;
      
      switch (type) 
      {
        case ORB:
          (graphics as Image).source = _orb;
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