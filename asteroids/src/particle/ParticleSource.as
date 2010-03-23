package particle
{
  import __AS3__.vec.Vector;
  
  import flash.geom.ColorTransform;
  
  import utils.Vector2;
  
  /** 
   * A particle emission source. 
   */
  public class ParticleSource
  {
    ///////////////////////////////////////////////////////////////////////////
    // REQUIRED FIELDS
    ///////////////////////////////////////////////////////////////////////////
    
    /** The type of particle to emit. */
    public function get particleType():String { return _particleType; }
    private var _particleType:String;
    
    /** The (square) side length of the emitted particles. */
    public function get particleSize():Number { return _particleSize; }
    private var _particleSize:Number;
    
    /** The number of particles per emission event. */
    public function get particlesPerEmit():int { return _particlesPerEmit; }
    private var _particlesPerEmit:int;

    /** The time interval at which a particle is emitted. */    
    public function get emitInterval():Number { return _emitInterval; }
    private var _emitInterval:Number;
 
    /** The lifespan of an emitted particle. */    
    public function get particleLifespan():Number { return _particleLifespan; }
    private var _particleLifespan:Number;
    
    /** The function that determines an emitted particle's initial velocity. */
    public function get velocityFunction():Function { return _velocityFunction; }
    private var _velocityFunction:Function;
    
    ///////////////////////////////////////////////////////////////////////////
    // OPTIONAL FIELDS
    ///////////////////////////////////////////////////////////////////////////
    
    /** Tint of emitted particles. */
    public function get particleTint():ColorTransform { return _particleTint; }
    private var _particleTint:ColorTransform;
    
    /** 
     * Update functions of emitted particles. 
     * 
     * An update function is generally an operation that changes the properties
     * of the particle as it ages, e.g. decreasing the graphics object's alpha value.
     */
    public function get updateFunctions():Vector.<Function> { return _updateFunctions; }
    private var _updateFunctions:Vector.<Function> = new Vector.<Function>();
    
    ///////////////////////////////////////////////////////////////////////////
    // PREDEFINED UPDATE FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////
    
    public static const updateFade:Function = function():void { 
      this.graphics.alpha = Math.max(0, (this.lifespan - this.age) / this.lifespan);
    };
    
    public static const updateShrink:Function = function():void {
      if (this.graphics.width > 1 && this.graphics.height > 1) 
      {
        this.graphics.width -= 1;
        this.graphics.height -= 1;
      }
    };
    
    public static const updateGrow:Function = function():void {
      this.graphics.width += 1;
      this.graphics.height += 1;
    };  
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** Amount of time until the next emission. */
    public var timeToEmit:Number = 0;
    
    /**
     * Create a new particle emission.
     * 
     * @param particleType - the type of particle to emit.
     * @param parrticleSize - the (square) side length of the emitted particles.
     * @param particlesPerEmit - the number of particles per emission event.
     * @param emitInterval - the time interval at which a particle is emitted.
     * @param particleLifespan - the lifespan of an emitted particle.
     * @param velocityFunction - the function that determines an emitted particle's initial velocity.
     * @param particleTint - tint of emitted particles.
     */
    public function ParticleSource(particleType:String, 
                                   particleSize:Number, 
                                   particlesPerEmit:int, 
                                   emitInterval:Number, 
                                   particleLifespan:Number, 
                                   velocityFunction:Function,
                                   particleTint:ColorTransform = null)
    {
      // Check the signature of velocityFunction.
      if (!(velocityFunction.call() is Vector2))
        throw new Error("Velocity function must have a return type of Vector2.");
      
      this._particleType = particleType;
      this._particleSize = particleSize;
      this._particlesPerEmit = particlesPerEmit;
      this._emitInterval = emitInterval;
      this._particleLifespan = particleLifespan;
      this._velocityFunction = velocityFunction;
      
      this._particleTint = particleTint;
      
      this._updateFunctions.push(updateFade);
    }

    /**
     * Adds a new update function to be executed on particle update.
     * 
     * @param fn - the update function to add.
     */
    public function addUpdateFunction(fn:Function):void 
    {
      _updateFunctions.push(fn);
    }

  }
}