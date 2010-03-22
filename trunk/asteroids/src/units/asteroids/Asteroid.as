package units.asteroids
{
  import core.*;
  
  import mx.effects.Fade;
  import mx.events.EffectEvent;

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
      
      state = ObjectState.DESTROY;
      
      return null;
    }
  }
}