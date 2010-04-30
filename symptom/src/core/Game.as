package core 
{
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import mx.containers.Canvas;
  import mx.controls.Image;
  import mx.core.UIComponent;
  import mx.effects.Fade;
  import mx.effects.easing.Cubic;
  import mx.events.EffectEvent;
  
  import utils.Vector2;
  
  /**
   * A container for all the game logic in Symptom.
   */
  public class Game 
  {      
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /** The ratio of background scroll to foreground scroll. */
    public static const BACKGROUND_PAN_FACTOR:Number = 0.85;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** Inactive games do not process updates called by application. */
    private var isActive:Boolean = false;
    
    /** The current level being played. */
    private var currentLevel:Level;
    
    /** Current distance the level is horizontally displaced/scrolled. */
    private var levelPosition:Number = 0;
    
    /** Foreground element, contains game objects as children on display list. */
    private var foreground:Canvas;
    
    /** A dark fadeable mask that is used to transition between levels. */
    private var levelTransitionMask:UIComponent;
    /** A transition that plays between levels. */
    private var levelTransition:Fade;
    
    ///////////////////////////////////////////////////////////////////////////
    // ASSETS
    ///////////////////////////////////////////////////////////////////////////
    
    /** Number of assets currently loading. */
    private var resourcesLoading:int = 0;
    
    /** Background image of the level. */
    private var backgroundImage:Image;
    
    /** 
     * Creates a new game.
     * 
     * @param container - the top level component that will house the game
     * display objects as children on its display list.
     */
    public function Game(container:UIComponent) 
    {
      levelTransitionMask = new Canvas();
      levelTransitionMask.width = Symptom.WIDTH;
      levelTransitionMask.height = Symptom.HEIGHT;
      levelTransitionMask.setStyle("backgroundColor", 0x333333);
      container.addChildAt(levelTransitionMask, 0);
      
      levelTransition = new Fade();
      levelTransition.alphaFrom = 1.0;
      levelTransition.alphaTo = 0.0;
      levelTransition.easingFunction = Cubic.easeOut;
      levelTransition.duration = 1000;
      
      foreground = new Canvas();
      foreground.height = 400;
      foreground.horizontalScrollPolicy = foreground.verticalScrollPolicy = "off";
      container.addChildAt(foreground, 0);
      
      backgroundImage = new Image();
      backgroundImage.addEventListener(Event.COMPLETE, loadComplete);
    }
    
    public function update(dt:Number):void 
    {
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
    
    public function render(buffer:BitmapData):void {
      if (!isActive)
        return;
      
      // Render background.
      var backBmp:BitmapData = Bitmap(backgroundImage.content).bitmapData;
      
      var backgroundPosition:Number = levelPosition * BACKGROUND_PAN_FACTOR;
      while (backgroundPosition < -backBmp.width) {
        backgroundPosition += backBmp.width;
      }
      
      buffer.copyPixels(backBmp, new Rectangle(-backgroundPosition, 0, backBmp.width + backgroundPosition, Symptom.HEIGHT), new Point());
      buffer.copyPixels(backBmp, new Rectangle(0, 0, -backgroundPosition, Symptom.HEIGHT), new Point(backBmp.width + backgroundPosition, 0));
    }
      
    /** Starts a new game to play. */
    public function play(level:Level = null):void 
    {   
      // Get the level to play.       
      currentLevel = (level != null) ? level : Level.getLevel(0);
      
      // Set up foreground.
      foreground.removeAllChildren();
      foreground.width = currentLevel.length;
      foreground.x = foreground.y = 0;
      
      // Load level data.
      for each (var img:Image in currentLevel.images)
        foreground.addChild(img);
      for each (var go:GameObject in currentLevel.getAllObjects())
        foreground.addChild(go.graphics);
      
      // Set up background.
      levelPosition = 0;
      resourcesLoading += 1;
      backgroundImage.load(currentLevel.style);
    }
    
    /** Ends the game. */
    private function endGame(isWin:Boolean):void 
    {
      isActive = false;
      
      // If player won and next level exists, advance to it. 
      // Otherwise, reload first level.
      // Execute this logic once the transition is done playing, and then
      // remove the event listener so it doesn't trigger again inadvertently.
      var fn:Function = function():void 
      { 
        var next:Level = Level.getLevel(currentLevel.nextLevel);
        
        if (isWin && next != null) 
          play(next); 
        else
          play();
        
        levelTransition.removeEventListener(EffectEvent.EFFECT_END, arguments.callee);
      }
        
      levelTransition.addEventListener(EffectEvent.EFFECT_END, fn);
      levelTransition.play([levelTransitionMask], true);
    }
    
    /** 
     * Decrements resourcesLoading counter. 
     * If there are no more resources to load, activate game.
     */
    private function loadComplete(e:Event):void {
      resourcesLoading -= 1;
      
      if (resourcesLoading == 0) {
        isActive = true;
        levelTransition.play([levelTransitionMask]);
      }
    }
    
    /** 
     * Pans the foreground (and background, accordingly) so that the virus
     * never travels past the left half of the viewable screen.
     */
    private function scrollScreen():void 
    {
      var epsilon:Number = 10;
      var virusCenter:Vector2 = currentLevel.virusPosition;
      
      if (virusCenter.x > Symptom.WIDTH/2 && foreground.x > -foreground.width + Symptom.WIDTH + epsilon) 
      {
        var delta:Number = Math.min(0, Symptom.WIDTH/2 - virusCenter.x - foreground.x);
        
        levelPosition += delta;
        
        foreground.x += delta;
      }
    }

  }
}