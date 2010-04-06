package particle
{
  import __AS3__.vec.Vector;
  
  import core.ObjectState;
  
  import utils.Vector2;
  
  /**
   * A particle emitter handles timing and orientation of multiple particle
   * emission sources.
   */
  public class ParticleEmitter
  {
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /** 
     * An reusable array filter that removes graphics of destroyed particles 
     * from its parent and returns it to the ParticleSystem particle object pool.
     */
    private static const particleFilter:Function = function (p:Particle, i:int, v:Vector.<Particle>):Boolean 
    {
      if (p.state == ObjectState.DESTROY)
      {
        (p.graphics.parent).removeChild(p.graphics);
        ParticleSystem.returnParticleToPool(p);
      } 
      
      return p.state != ObjectState.DESTROY;
    };   
    
    ///////////////////////////////////////////////////////////////////////////
    // PROPERTIES
    ///////////////////////////////////////////////////////////////////////////
    
    /** Name of this emitter. */
    public function get name():String { return _name; }
    private var _name:String;
    
    /** 
     * Is this emitter currently active? Defaults to true.
     * Inactive emitters will be garbage collected on the next update cycle.
     */
    public function get state():int { return _state; }
    private var _state:int = EmitterState.ACTIVE;  
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** Current active particles. */
    private var particles:Vector.<Particle> = new Vector.<Particle>(); 
    
    /** Emission source position. */
    private var sourcePosition:Vector2 = new Vector2();    
    
    /** Emissions handled by this emitter. */
    private var emissions:Vector.<ParticleSource> = new Vector.<ParticleSource>();
    
    /** Age of this emitter. */
    private var emitterAge:Number = 0;
    
    /** Lifespan of this emitter. */
    private var emitterLifespan:Number; 
    
    /**
     * Create a new particle emitter.
     * 
     * @param name - the name of this emitter. Should match name used in ParticleSystem.
     * @param sourcePosition - the initial position of emitted particles.
     * @param emitterLifespan - the lifespan of this emitter, defaults to 0 (infinite).
     */ 
    public function ParticleEmitter(name:String, sourcePosition:Vector2, emitterLifespan:Number = 0)
    {
      this._name = name;
      this.sourcePosition.copy(sourcePosition);
      this.emitterLifespan = emitterLifespan;
    }
    
    /**
     * Add a particle source to this particle emitter.
     * 
     * @param source - the source to add.
     */
    public function addSource(source:ParticleSource):void
    {
      if (source == null)
        throw new Error("Emission to add must be non-null.");
      
      emissions.push(source);
    }
    
    /**
     * Change the state of this emitter.
     *  
     * @param isActivate - activate or deactivate this emitter?
     * @param sourcePosition - the new emission source position.
     */
    public function modify(isActivate:Boolean, sourcePosition:Vector2 = null):void
    {
      if (isActivate)
        _state = EmitterState.ACTIVE;
      else
        _state = EmitterState.INACTIVE;
      
      if (sourcePosition != null)
        this.sourcePosition.copy(sourcePosition);
    }
    
    /**
     * Updates emitter state, all contained particle states 
     * and emits a particle if applicable.
     */
    public function update(dt:Number, cameraTransform:Vector2):void 
    {        
      emitterAge += dt;
      
      // Stop emitting particles once emitter is too old.
      if (emitterLifespan > 0 && emitterAge > emitterLifespan)
        _state = EmitterState.INACTIVE;
        
      // Filter particles set to be destroyed.
      particles = particles.filter(particleFilter, ParticleSystem.container);
      
      // If emitter is inactive and there are no more particles to update, set for garbage collection.
      if (particles.length == 0 && _state == EmitterState.INACTIVE)
      {
        _state = EmitterState.DESTROY;
        return;
      }
      
      // Update particles.
      for each (var p:Particle in particles)
        p.step(dt, cameraTransform);
      
      // Emit new particles.
      if (_state == EmitterState.ACTIVE) 
        emitParticles(dt);
    }
    
    /** Performs a particle emission from each contained source. */
    private function emitParticles(dt:Number):void 
    {
      for each (var source:ParticleSource in emissions)
      {        
        source.timeToEmit -= dt;
        
        if (source.timeToEmit < 0)
        {
          source.timeToEmit = source.emitInterval;
  
          for (var j:int = 0; j < source.particlesPerEmit; j++)
          {
            var p:Particle = ParticleSystem.getParticleFromPool();
            p.initialize(source.particleType, 
                         source.particleSize, 
                         source.particleLifespan, 
                         sourcePosition, 
                         source.velocityFunction.call(),
                         source.updateFunctions);
            
            if (source.particleTint != null)
              p.graphics.transform.colorTransform = source.particleTint;     
                     
            particles.push(p);
            ParticleSystem.container.addChild(p.graphics);
          }
        }
      }
    }
    
  }
}