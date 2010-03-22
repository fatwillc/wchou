package particle
{
  /** 
   * A particle emission source. 
   * 
   * Basically a struct-like object that allows a single ParticleEmitter to 
   * emit multiple kinds of particles with different types, etc. Would be 
   * semantically cleaner implemented as a private inner class to 
   * ParticleEmitter, if AS3 supported that kind of thing.
   */
  internal class Emission
  {
    /** The type of particle to emit. */
    public function get particleType():String { return _particleType; }
    private var _particleType:String;

    /** The interval at which a particle is emitted. */    
    public function get emitInterval():Number { return _emitInterval; }
    private var _emitInterval:Number;
 
    /** The lifespan of emitted particles. */    
    public function get particleLifespan():Number { return _particleLifespan; }
    private var _particleLifespan:Number;
    
    public function Emission(particleType:String, emitInterval:Number, particleLifespan:Number)
    {
      this._particleType = particleType;
      this._emitInterval = emitInterval;
      this._particleLifespan = particleLifespan;
    }

  }
}