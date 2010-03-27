package core {
  import mx.containers.Canvas;
  import mx.controls.Image;
  import mx.core.UIComponent;
  import mx.effects.Fade;
  import mx.effects.easing.Cubic;
  import mx.events.EffectEvent;
  
  import ui.TilingCanvas;
  
  import utils.Vector2;
  
  /**
   * A container for all the game logic in Symptom.
   */
  public class Game {      
    
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /** The ratio of background scroll to foreground scroll. */
    public static const BACKGROUND_PAN_FACTOR:Number = 0.85;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** Foreground element, contains game objects as children on display list. */
    private var foreground:Canvas;
    
    /** Background element. Pans slower than the foreground by a factor of BACKGROUND_PAN_FACTOR. */
    private var background:TilingCanvas;
    
    /** The current level being played. */
    private var currentLevel:Level;
    
    /** Inactive games do not process updates called by application. */
    private var isActive:Boolean = false;
    
    /** A transition that plays between levels. */
    private var levelTransition:Fade;
    
    /** 
     * Creates a new game.
     * 
     * @param container - the top level component that will house the game
     * display objects as children on its display list.
     */
    public function Game(container:UIComponent) {
      foreground = new Canvas();
      foreground.height = 400;
      foreground.horizontalScrollPolicy = foreground.verticalScrollPolicy = "off";
      container.addChildAt(foreground, 0);
      
      background = new TilingCanvas();
      background.height = 400;
      background.horizontalScrollPolicy = background.verticalScrollPolicy = "off";
      container.addChildAt(background, 0);
      
      levelTransition = new Fade();
      levelTransition.alphaFrom = 0;
      levelTransition.alphaTo = 1.0;
      levelTransition.easingFunction = Cubic.easeOut;
      levelTransition.duration = 1000;
    }
    
    public function update(dt:Number):void {
      foreground.graphics.clear();
      
      if (!isActive)
        return;
      
      // Check for victory or loss.
      if (currentLevel.state == LevelState.WIN)
        endGame(true);
      else if (currentLevel.state == LevelState.LOSE)
        endGame(false);
        
      // Update level.
      currentLevel.update(dt);
      
      // Scroll screen according to virus position.
      scrollScreen();
    }
      
    /** Starts a new game to play. */
    public function play(level:Level = null):void {   
      // Get the level to play.       
      currentLevel = (level != null) ? level : Level.getLevel(0);
      
      // Set up foreground.
      foreground.removeAllChildren();
      foreground.alpha = 0;
      foreground.width = currentLevel.length;
      foreground.x = foreground.y = 0;
      
      // Set up background.
      background.width = foreground.width / BACKGROUND_PAN_FACTOR;
      background.x = background.y = 0;
      background.setTileImage(currentLevel.style);
      
      // Load level data.
      for each (var img:Image in currentLevel.images)
        foreground.addChild(img);
      for each (var go:GameObject in currentLevel.getAllObjects())
        foreground.addChild(go.graphics);
      
      // Start game.
      levelTransition.play([foreground, background]);
      isActive = true;
    }
    
    /** Ends the game. */
    public function endGame(isWin:Boolean):void {
      isActive = false;
      
      // If player won and next level exists, advance to it. 
      // Otherwise, reload first level.
      // Execute this logic once the transition is done playing, and then
      // remove the event listener so it doesn't trigger again inadvertently.
      var fn:Function = function():void { 
        var next:Level = Level.getLevel(currentLevel.nextLevel);
        
        if (isWin && next != null) {
          play(next); 
        } else {
          play();
        }
        
        levelTransition.removeEventListener(EffectEvent.EFFECT_END, arguments.callee);
        }
        
      levelTransition.addEventListener(EffectEvent.EFFECT_END, fn);
      levelTransition.play([foreground, background], true);
    }
    
    /** 
     * Pans the foreground (and background, accordingly) so that the virus
     * never travels past the left half of the viewable screen.
     */
    private function scrollScreen():void {
      var epsilon:Number = 10;
      var virusCenter:Vector2 = currentLevel.virusPosition;
      
      if (virusCenter.x > Symptom.WIDTH/2 && foreground.x > -foreground.width + Symptom.WIDTH + epsilon) {
        var delta:Number = Math.min(0, Symptom.WIDTH/2 - virusCenter.x - foreground.x);
        
        foreground.x += delta;
        background.x += delta * BACKGROUND_PAN_FACTOR;
      }
    }

  }
}