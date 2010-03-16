package units.asteroids
{
  import core.*;
  
  import mx.effects.Fade;
  
  import utils.Vector2;

  /** An abstract asteroid. Should not be instanced directly. */
  public class Asteroid extends GameObject
  {    
    /** Amount of money rewarded when destroyed by player. */
    public var reward:Number = 0;
    
    private var fadeOut:Fade;
    
    public function Asteroid(radius:Number, position:Vector2)
    {
      super();
      
      _graphics = new AsteroidGraphic();
      _graphics.rotation = Math.random() * 360;
      _graphics.width = _graphics.height = radius * 2;

      graphics.x += position.x - center.x;
      graphics.y += position.y - center.y;
    }
    
    override public function update(dt:Number):void 
    {
      if ((graphics as AsteroidGraphic).isDeathFinished)
      {
        state = ObjectState.DESTROY;
      }
    }

    /** 
     * Destroys the asteroid and returns the resulting set 
     * of smaller, spawned asteroids if any. 
     */
    public function split():Vector.<Asteroid> 
    {
      SoundManager.playRandomExplosion();
      
      state = ObjectState.INACTIVE;
      
      (graphics as AsteroidGraphic).playDeathAnimation();
      
      return null;
    }
  }
}