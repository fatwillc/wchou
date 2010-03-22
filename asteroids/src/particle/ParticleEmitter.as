package particle
{
  import __AS3__.vec.Vector;
  
  import utils.Vector2;
  
  /**
   * A particle emitter handles timing and orientation of particle emissions
   * as a single particle "source".
   */
  public class ParticleEmitter
  {
    /** 
     * Is this emitter currently active? Only active emitters emit particles.
     * Defaults to false.
     */
    public var isActive:Boolean = false;
    
    /**
     * Should this emitter be destroyed on the next update cycle?
     * Set when the emitter's lifespan runs out.
     */
    public var toDestroy:Boolean = true;
    
    /** 
     * Name of this emitter.
     * Corresponds to enumeration in ParticleSystem.
     */
    public function get name():String { return _name; }
    private var _name:String;
    
    /** Emission source position. */
    private var sourcePosition:Vector2 = new Vector2();
    
    /** Emissions handled by this emitter. */
    private var emissions:Vector.<Emission> = new Vector.<Emission>();
    /** Time til next emission for each emission in "emissions". */
    private var timeToEmit:Vector.<Number> = new Vector.<Number>();
    
    /** Age of this emitter. */
    private var emitterAge:Number = 0;
    /** Lifespan of this emitter. */
    private var emitterLifespan:Number;
    
    /**
     * Create a new particle emitter.
     * 
     * @param emitterLifespan - the lifespan of this emitter, defaults to 0 (infinite).
     */ 
    public function ParticleEmitter(name:String, emitterLifespan:Number = 0)
    {
      this._name = name;
      this.emitterLifespan = emitterLifespan;
    }
    
    /**
     * Updates emitter state and emits a particle if applicable.
     * 
     * @param dt - time elapsed since last timestep.
     */
    public function update(dt:Number):void 
    {
      if (!isActive)
        return;
        
      emitterAge += dt;
      if (emitterLifespan > 0 && emitterAge > emitterLifespan)
      {
        toDestroy = true;
      }
        
      for (var i:int = 0; i < emissions.length; i++)
      {
        var emission:Emission = emissions[i];
        
        timeToEmit[i] -= dt;
        
        if (timeToEmit[i] < 0)
        {
          timeToEmit[i] = emission.emitInterval;
          
          var emitVelocity:Vector2 = Vector2.randomUnitCircle();
          emitVelocity.normalize(30);
          
          ParticleSystem.emitParticle(emission.particleType, emission.particleLifespan, sourcePosition, emitVelocity);
        }
      }
    }
    
    /**
     * Change the state of this emitter.
     * Must be called after emitter initialization to activate and 
     * set emitter source position.
     *  
     * @param isActive - active or deactivate this emitter?
     * @param sourcePosition - the new emission source position.
     */
    public function modify(isActive:Boolean, sourcePosition:Vector2 = null):void
    {
      this.isActive = isActive;
      
      if (sourcePosition != null)
        this.sourcePosition.copy(sourcePosition);
    }
    
    /**
     * Add an emission to this particle emitter.
     * 
     * @param emission - the emission to add.
     */
    public function addEmission(emission:Emission):void
    {
      if (emission == null)
        throw new Error("Emission to add must be non-null.");
      
      emissions.push(emission);
      timeToEmit.push(0);
    }

  }
}