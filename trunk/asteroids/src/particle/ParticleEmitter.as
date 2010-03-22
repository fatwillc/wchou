package particle
{
  import utils.Vector2;
  
  /**
   * A particle emitter handles timing and orientation of particle emissions
   * as a single particle "source".
   */
  public class ParticleEmitter
  {
    /** 
     * Is this emitter currently active?
     * Only active emitters emit particles.
     */
    public var isActive:Boolean = true;
    
    /** Current time remaning until next emission. */
    private var timeToEmit:Number = Number.POSITIVE_INFINITY;
    
    /** Time interval between emissions. */
    private var emitInterval:Number;
    
    /** Emission source position. */
    private var sourcePosition:Vector2 = new Vector2();
    
    /**
     * Create a new particle emitter.
     * 
     * @param emitInterval - the period at which particles are emitted.
     */ 
    public function ParticleEmitter(emitInterval:Number)
    {
      this.emitInterval = this.timeToEmit = emitInterval;
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
      
      timeToEmit -= dt;
      
      if (timeToEmit < 0)
      {
        timeToEmit = emitInterval;
        
        var emitVelocity:Vector2 = Vector2.randomUnitCircle();
        emitVelocity.normalize(30);
        
        ParticleSystem.emitParticle(Particle.ORB, 0.3, sourcePosition, emitVelocity);
      }
    }
    
    /**
     * Change the state of this emitter.
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

  }
}