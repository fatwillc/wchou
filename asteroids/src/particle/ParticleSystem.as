package particle
{
  import __AS3__.vec.Vector;
  
  import flash.geom.ColorTransform;
  
  import mx.core.UIComponent;
  
  import utils.Vector2;
  
  /**
   * Handles creation of particle emitters and updates of particles.
   * Implemented as a singleton.
   */
  public class ParticleSystem
  {
    ///////////////////////////////////////////////////////////////////////////
    // PREDEFINED PARTICLE EMITTERS
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
    
    /** Pool of particle objects (object pool pattern). */
    private static var particlePool:Vector.<Particle>;
    
    /** Maximum number of objects in particle object pool. */
    private static var MAX_ACTIVE_PARTICLES:int = 100;
    
    /**
     * Initialize the particle system.
     * 
     * @particleContainer - the component on which particles graphics will be 
     * drawn. Must be already initialized.
     */
    public static function initialize(particleContainer:UIComponent):void
    {
      _container = particleContainer;
      
      // Initialize particle object pool.
      particlePool = new Vector.<Particle>(MAX_ACTIVE_PARTICLES);      
      for (var i:int = 0; i < particlePool.length; i++) 
        particlePool[i] = new Particle();
      
      reset();
    }
    
    /** Resets particle system state and removes all emitters. */
    public static function reset():void
    {
      emitters = new Object();
      
      // Initialize pre-defined emitters.
      
      var rocketEmitter:ParticleEmitter = new ParticleEmitter(ROCKET_PROPULSION, new Vector2());
      var rocketSource:ParticleSource = new ParticleSource(Particle.ORB, 15, 1, 0.02, 0.3, function():Vector2 { return Vector2.randomUnitCircle(30); }, new ColorTransform(0, 0, 0, 1));
      rocketSource.addUpdateFunction(ParticleSource.updateShrink);
      rocketEmitter.addSource(rocketSource);
      rocketEmitter.modify(false);
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
      for each (var e:ParticleEmitter in emitters) 
      {
        if (e != null)
        {
          // Garbage collect emitters set to be destroyed.
          if (e.state == EmitterState.DESTROY)
          {
            delete emitters[e.name];
            e = null;
          }
          else
            e.update(dt, cameraTransform);
        }
      }
    }
    
    /**
     * Adds a new emitter to the particle system.
     *
     * @param emitter - the emitter to add.
     */
    public static function addEmitter(e:ParticleEmitter):void
    {
      if (emitters[e.name] != null)
        throw new Error("Emitter with the same name already exists.");
        
      emitters[e.name] = e;
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
    
    /**
     * Gets a particle from the particle object pool.
     * If none are currently available, return null.
     */
    public static function getParticleFromPool():Particle
    {
      
      for (var i:int = 0; i < particlePool.length; i++)
      {
        if (particlePool[i] != null)
        {
          var p:Particle = particlePool[i];
          particlePool[i] = null;
          return p;
        }
      }
      
      return null;
    }
    
    /** 
     * Returns a particle to the particle object pool.
     * Throws an error if provided particle is already in the pool.
     * Throws an error if the particle pool is already full.
     * 
     * @param p - the particle to return.
     */
    public static function returnParticleToPool(p:Particle):void
    {
      var emptySlot:int = -1;
      
      for (var i:int = 0; i < particlePool.length; i++)
      {        
        if (particlePool[i] == p)
          throw new Error("Particle already exists in pool.");
        
        if (particlePool[i] == null) 
          emptySlot = i;
      }      
      
      if (emptySlot >= 0)
        particlePool[i] = p;
      else
        throw new Error("Particle pool is full.");
    }
  }
}