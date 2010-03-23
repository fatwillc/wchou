package units.asteroids
{
  import core.*;
  
  import particle.*;
  
  import utils.Vector2;
  
  import flash.geom.ColorTransform;

  /** An abstract asteroid. Should not be instanced directly. */
  public class Asteroid extends GameObject
  {    
    /** Amount of money rewarded when destroyed by player. */
    public var reward:Number = 0;
    
    /** 
     * Destroys the asteroid and returns the resulting set 
     * of smaller, spawned asteroids if any. 
     */
    public function split():Vector.<Asteroid> 
    {
      SoundManager.playRandomExplosion();
            
      // Particle effects.
      var emitter:ParticleEmitter = new ParticleEmitter("ASTEROID" + Math.random().toString(), center, 0.5);
      var source:ParticleSource = new ParticleSource(Particle.ORB, 15, 7, Number.MAX_VALUE, 0.5, function():Vector2 { return Vector2.randomUnitCircle(Math.random() * 50); }, new ColorTransform(0, 0, 0, 1, 150, 150, 150));
      source.addUpdateFunction(ParticleSource.updateShrink);
      emitter.addSource(source);
      ParticleSystem.addEmitter(emitter);
      
      state = ObjectState.DESTROY;
      
      return null;
    }
  }
}