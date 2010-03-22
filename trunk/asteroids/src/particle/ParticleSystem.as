package particle
{
  import __AS3__.vec.Vector;
  
  import core.GameObject;
  
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
    private static var container:UIComponent;
    
    /** Current active particles. */
    private static var particles:Vector.<GameObject>; 
    
    /** 
     * Associate array mapping emitter names (see enum above) to emitters. 
     */
    private static var emitters:Object = new Object();
    
    /**
     * Initialize the particle system.
     * 
     * @particleContainer - the component on which particles graphics will be 
     * drawn. Must be already initialized.
     */
    public static function initialize(particleContainer:UIComponent):void
    {
      container = particleContainer;
      
      particles = new Vector.<GameObject>();
      
      // Initialize pre-defined emitters.
      var rocketEmitter:ParticleEmitter = new ParticleEmitter(ROCKET_PROPULSION);
      rocketEmitter.addEmission(new Emission(Particle.ORB, 0.02, 0.3));
      emitters[ROCKET_PROPULSION] = rocketEmitter;
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
      { 
        if (emitter.toDestroy) 
          emitters[emitter.name] = null;  
        else
          emitter.update(dt);
      }
      
      particles = particles.filter(GameObject.destroyFilter, container);
      for each (var p:GameObject in particles)
        p.step(dt, cameraTransform);
    }
    
    /**
     * Modify the state of an emitter.
     * Returns true if successful, false otherwise.
     * 
     * @param emitterName - the name of the emitter.
     * @param isActive - the active state to set the emitter to.
     * @param sourcePosition - the emitter's new emission source position.
     * 
     * @return true if successful, false otherwise.
     */
    public static function modifyEmitter(emitterName:String, isActive:Boolean, sourcePosition:Vector2 = null):Boolean
    {
      var emitter:ParticleEmitter = emitters[emitterName];
      
      if (emitter == null)
        return false;
        
      emitter.modify(isActive, sourcePosition);
      
      return true;
    }
    
    /**
     * Emits a particle.
     * 
     * @param type - the particle type.
     * @param lifespan - the particle's lifespan.
     * @param position - the particle's initial position.
     * @param velocity - the particle's initial velocity.
     */
    public static function emitParticle(type:String, lifespan:Number, position:Vector2, velocity:Vector2):void 
    {
      var p:Particle = new Particle(type, lifespan, position, velocity);
      particles.push(p);
      container.addChild(p.graphics);
    }
  }
}