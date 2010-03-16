package units.rocket
{
  import core.*;
  
  import flash.geom.Matrix;
  import flash.ui.Keyboard;
  
  import mx.core.UIComponent;
  
  import units.rocket.upgradables.*;
  
  import utils.Geometry;
  import utils.Vector2;

  /** The player-controlled space rocket. */
  public class Rocket extends GameObject
  {
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /** Maximum attainable rocket speed. */
    private const MAX_SPEED:Number = 150;
    
    /** Amount of time between hyperspace warp-out and warp-in. */
    private const HYPERSPACE_TIMER:Number = 0.75;
    
    ///////////////////////////////////////////////////////////////////////////
    // UPGRADABLES
    ///////////////////////////////////////////////////////////////////////////   
    
    /** Current rocket acceleration rate. */
    public var acceleration:NumericUpgradable = new AccelerationUpgrade();
    
    /** Current rocket reload rate. */
    public var reload:NumericUpgradable = new ReloadUpgrade();
    
    /** Current rocket hyperspace jump risk. */
    public var hyperspace:NumericUpgradable = new HyperspaceUpgrade();
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////    
    
    /** Amount of time remaining until a bullet can be fired. */
    private var remainingReload:Number = 0;
    
    /** Has the hyperspace drive been activated? */
    private var isHyperspaceActivated:Boolean = false;
    
    /** Current countdown to hyperspace activation (when == HYPERSPACE_TIMER). */
    private var hyperspaceCountdown:Number;
    
    /** The component on which the rocket performs mouse listening. */
    private var listenerComponent:UIComponent;
    
    /** Creates a new rocket. */
    public function Rocket()
    {
      this.listenerComponent = listenerComponent;
      
      _graphics = new ArrowRocket();

      reset();
    }
    
    /** Resets any state pertinent to changing levels. */
    public function reset(position:Vector2 = null):void 
    {
      state = ObjectState.ACTIVE;
      
      v.zero();
      
//      (graphics as RocketGraphic).gotoAndStop(1);
      
      if (position != null)
      {
        graphics.x = position.x;
        graphics.y = position.y;   
      }
    }
    
    override public function update(dt:Number):void 
    {      
      var rg:ArrowRocket = graphics as ArrowRocket;//RocketGraphic;
      
      rotateToMouse();
      
      remainingReload -= dt;

      if (state == ObjectState.ACTIVE) 
      {
        // Rocket movement.
        if (InputState.isMouseDown) 
        {          
          F.acc(direction, acceleration.value());
          rg.togglePropulsion(true);
        } 
        else 
          rg.togglePropulsion(false);
          
        // Hyperspace jump.        
        if (InputState.isKeyDown(Keyboard.SHIFT) && !InputState.wasKeyDown(Keyboard.SHIFT))
        {
//          rg.playWarpOutAnimation();
          isHyperspaceActivated = true;
          state = ObjectState.INACTIVE;    
               
          hyperspaceCountdown = HYPERSPACE_TIMER;
        }
      }
      
      if (isHyperspaceActivated) 
      {
        if (hyperspaceCountdown <= 0) 
        {
//          rg.playWarpInAnimation();
          isHyperspaceActivated = false;
          state = ObjectState.ACTIVE;
          
          var random:Vector2 = Asteroids.randomScreenLocation();
          rg.x = random.x;
          rg.y = random.y;
          
          // Hyperspace risk.
          if (Math.random() < hyperspace.value())
            die();
        } 
        else
          hyperspaceCountdown -= dt;
      }
      
      // Apply constraints.
      if (v.length() > MAX_SPEED)
        v.normalize(MAX_SPEED);
    }
    
    /** 
     * If rocket can fire a bullet, updates rocket state and returns true. 
     * Otherwise, returns false. 
     */
    public function fire():Boolean 
    {
      if (remainingReload <= 0 && state == ObjectState.ACTIVE)
      {
        SoundManager.playRandomBullet();
        
        remainingReload = reload.value();
//        (graphics as RocketGraphic).playFireAnimation();    
        return true;
      }
      return false;
    }
    
    /** Destroys the rocket. */
    public function die():void 
    {
      state = ObjectState.DESTROY;
      
//      (graphics as RocketGraphic).playDeathAnimation();
    }

    /** Rotates rocket to face the current mouse position. */
    private function rotateToMouse():void 
    {
      if (state != ObjectState.ACTIVE)
        return;
      
      var m:Matrix = new Matrix();
      m.rotate(Math.atan2(graphics.mouseY, graphics.mouseX) + Geometry.PI_OVER_TWO);
      m.concat(graphics.transform.matrix);
      graphics.transform.matrix = m;
    }
  }
}