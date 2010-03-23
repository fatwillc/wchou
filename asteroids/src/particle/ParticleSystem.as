package particle
{
  import mx.core.UIComponent;
  
  import utils.Vector2;
  
  /**
   * Handles creation of particle emitters and updates of particles.
   * Implemented as a singleton.
   */
  public class ParticleSystem
  {
    ///////////////////////////////////////////////////////////////////////////
    // AVAILABLE PARTICLE EMITTERS
    ///////////////////////////////////////////////////////////////////////////
    
    /** Emits rocket exhaust. */
    public static const ROCKET_PROPULSION:String = "rocket_propulsion";
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** The component on which particle graphics are drawn. */
    public static function get container():UIComponent { return _container; }
    private static var _container:UIComponent;
    
    /** Associate array mapping emitter names (see enum above) to current emitters. */
    private static var emitters:Object;
    
    /**
     * Initialize the particle system.
     * 
     * @particleContainer - the component on which particles graphics will be 
     * drawn. Must be already initialized.
     */
    public static function initialize(particleContainer:UIComponent):void
    {
      _container = particleContainer;
      
      emitters = new Object();
      
      // Initialize pre-defined emitters.
      
      var rocketEmitter:ParticleEmitter = new ParticleEmitter(ROCKET_PROPULSION, new Vector2());
      rocketEmitter.addEmission(new ParticleSource(Particle.ORB, 15, 1, 0.02, 0.3, function():Vector2 { return Vector2.randomUnitCircle(30); }));
      rocketEmitter.modify(false);
      emitters[ROCKET_PROPULSION] = rocketEmitter;
    }
    
    /** Resets particle system state and removes all emitters. */
    public static function reset():void
    {
      emitters = new Object();
    }
    
    /**
     * Updates the state of the particle system.
     * 
     * @param dt - time elapsed since last timestep.
     * @param cameraTransform - translation vector that represents camera transformation.
     */
    public static function update(dt:Number, cameraTransform:Vector2):void 
    {
      for each (var emitter:ParticleEmitter in emitters) 
        emitter.update(dt, cameraTransform);
    }
    
    /**
     * Adds a new emitter to the particle system.
     *
     * @param emitter - the emitter to add.
     */
    public static function addEmitter(emitter:ParticleEmitter):void
    {
      if (emitters[emitter.name] != null)
        throw new Error("Emitter with the same name already exists.");
        
      emitters[emitter.name] = emitter;
    }
    
    /**
     * Modify the state of an emitter.
     * 
     * @param emitterName - the name of the emitter.
     * @param isActive - the active state to set the emitter to.
     * @param sourcePosition - the emitter's new emission source position.
     */
    public static function modifyEmitter(emitterName:String, isActive:Boolean, sourcePosition:Vector2 = null):void
    {
      var emitter:ParticleEmitter = emitters[emitterName];
      
      if (emitter == null)
        throw new Error("Emitter with name " + emitterName + " does not exist in particle system.");
        
      emitter.modify(isActive, sourcePosition);
    }
  }
}