package units
{
  import core.GameObject;
  import core.IBoundingCircle;
  import core.ObjectState;
  
  import particle.*;
  
  import utils.Vector2;

  import flash.geom.ColorTransform;

  /** A Ufo travels in a straight line and occasionally shoots lasers. */
  public class Ufo extends GameObject
  {
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    private const SPEED:Number = 100;
    
    private const RELOAD_TIME:Number = 2.0;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////

    /** Amount of money rewarded when destroyed by player. */    
    public var reward:Number = 250;
    
    /** Amount of time remaining until Ufo will fire (again). */
    private var remainingReload:Number = 0;
    
    public function Ufo(position:Vector2, destination:Vector2)
    {
      super();
      
      _graphics = new UfoGraphic();
      
      _graphics.addEventListener(UfoGraphic.DEATH, function():void { state = ObjectState.DESTROY; });
     
      graphics.x = position.x;
      graphics.y = position.y;
      
      v.copy(destination);
      v.subtract(position);
      v.normalize(SPEED);
    }
    
    override public function update(dt:Number, cameraTransform:Vector2):void 
    {
      super.update(dt, cameraTransform);
      
      remainingReload -= dt;
    }
    
    /** Attempts to fire a laser (depends on reload timer). */
    public function fire():Boolean {
      if (remainingReload <= 0 && state == ObjectState.ACTIVE)
      {
        remainingReload = RELOAD_TIME;
        return true; 
      }
      else
        return false;
    }
    
    /** Destroys the Ufo. */
    override public function die():void {
      state = ObjectState.INACTIVE;
      
      // Particle effects.
      var emitter:ParticleEmitter = new ParticleEmitter("UFO" + Math.random().toString(), center, 0.5);
      var source:ParticleSource = new ParticleSource(Particle.ORB, 1, 5, Number.MAX_VALUE, 0.75, function():Vector2 { return Vector2.randomUnitCircle(Math.random() * 30); }, new ColorTransform(0, 0, 0, 1, 80, 80, 130));
      source.addUpdateFunction(ParticleSource.updateGrow);
      emitter.addSource(source);
      ParticleSystem.addEmitter(emitter);
      
      (graphics as UfoGraphic).playDeathAnimation();
    }
  }
}