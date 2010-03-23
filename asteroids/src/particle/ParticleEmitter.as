package particle
{
  import __AS3__.vec.Vector;
  
  import core.GameObject;
  
  import utils.Vector2;
  
  /**
   * A particle emitter handles timing and orientation of multiple particle
   * emission sources.
   */
  public class ParticleEmitter
  {
    ///////////////////////////////////////////////////////////////////////////
    // PROPERTIES
    ///////////////////////////////////////////////////////////////////////////
    
    /** 
     * Is this emitter currently active? 
     * Only active emitters emit particles.
     * Defaults to true.
     */
    public function get isActive():Boolean { return _isActive; }
    public function set isActive(flag:Boolean):void 
    { 
      emitterAge = 0;
      this._isActive = flag; 
    }
    private var _isActive:Boolean = true;
    
    /** 
     * Name of this emitter.
     * Corresponds to enumeration in ParticleSystem.
     */
    public function get name():String { return _name; }
    private var _name:String;
    
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
     * Add an emission to this particle emitter.
     * 
     * @param emission - the emission to add.
     */
    public function addEmission(emission:ParticleSource):void
    {
      if (emission == null)
        throw new Error("Emission to add must be non-null.");
      
      emissions.push(emission);
    }
    
    /**
     * Change the state of this emitter.
     *  
     * @param isActive - active or deactivate this emitter?
     * @param sourcePosition - the new emission source position.
     */
    public function modify(isActive:Boolean, sourcePosition:Vector2 = null):void
    {
      this._isActive = isActive;
      
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
      
      if (emitterLifespan > 0 && emitterAge > emitterLifespan)
        _isActive = false;
        
      particles = particles.filter(GameObject.destroyFilter, ParticleSystem.container);
      for each (var p:Particle in particles)
        p.step(dt, cameraTransform);
      
      if (isActive) 
        emitParticles(dt);
    }
    
    /** Performs a particle emission from each contained source. */
    private function emitParticles(dt:Number):void 
    {
      for (var i:int = 0; i < emissions.length; i++)
      {
        var e:ParticleSource = emissions[i];
        
        e.timeToEmit -= dt;
        
        if (e.timeToEmit < 0)
        {
          e.timeToEmit = e.emitInterval;
  
          for (var j:int = 0; j < e.particlesPerEmit; j++)
          {
            var p:Particle = new Particle(e.particleType, e.particleSize, e.particleLifespan, sourcePosition, e.velocityFunction.call());
            if (e.particleTint != null)
              p.graphics.transform.colorTransform = e.particleTint;            
            particles.push(p);
            ParticleSystem.container.addChild(p.graphics);
          }
        }
      }
    }
    
  }
}