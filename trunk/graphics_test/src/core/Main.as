package core
{
  import __AS3__.vec.Vector;
  
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.ColorTransform;
  import flash.geom.Rectangle;
  import flash.utils.getTimer;
  
  import mx.containers.Canvas;
  import mx.controls.Button;
  import mx.core.UIComponent;
  
  import utils.*;
  import mx.controls.TextInput;
  
  public class Main extends Canvas
  {
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    private static const defaultNumSimulationObjects:int = 100;
    
    ///////////////////////////////////////////////////////////////////////////
    // RENDERING VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * If true, renders game objects via blitting. 
     * Otherwise renders via Flash display list.
     */
    public function get isRenderBlit():Boolean { return _isRenderBlit; }
    public function set isRenderBlit(value:Boolean):void 
    {
      if (value)
      {
        btnToggleRenderMethod.label = "BLIT";
        removeChild(displayListContainer);
        addChildAt(blitFrontBuffer, 0);
      }
      else
      {
        btnToggleRenderMethod.label = "DISPLAY LIST"
        removeChild(blitFrontBuffer);
        addChildAt(displayListContainer, 0);
      }
      
      _isRenderBlit = value;
    }
    private var _isRenderBlit:Boolean = false;
    
    /**
     * Toggles rendering method between blit and display list.
     */
    private function toggleRenderMethod(e:MouseEvent):void
    {
      isRenderBlit = !isRenderBlit;
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // RENDERING COMPONENTS
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * The visible bitmap buffer which displays the render contents of each frame's blitted bitmap graphics.
     * Used for rendering via blitting.
     */
    private var blitFrontBuffer:UIComponent;
    
    /** 
     * The invisible bitmap buffer that accumulates bitmap graphics per frame before displaying it on the front-buffer. 
     * Used for rendering via blitting.
     */
    private var blitBackBuffer:BitmapData;
    
    /**
     * Component that holds all game objects' graphics as children in display list.
     * Used for rendering via Flash display list.
     */
    private var displayListContainer:Canvas;
    
    ///////////////////////////////////////////////////////////////////////////
    // SIMULATION VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** 
     * All current active objects.
     */
    private var objects:Vector.<GameObject>;
    
    /** 
     * The game time when the last frame was drawn.
     */
    private var lastTime:uint;

    ///////////////////////////////////////////////////////////////////////////
    // UI COMPONENTS
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * Toggles rendering method when clicked.
     */
    private var btnToggleRenderMethod:Button;
    
    /**
     * Sets the number of active simulation objects.
     */
    private var txtNumSimulationObjects:TextInput;

    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR & INITIALIZATION METHODS
    ///////////////////////////////////////////////////////////////////////////

    public function Main(width:Number, height:Number, numObjects:int = defaultNumSimulationObjects)
    {
      super();
      
      this.width = width;
      this.height = height;
      
      // Set up display mechanisms.
      blitFrontBuffer = new UIComponent();
      blitBackBuffer = new BitmapData(width, height);
      displayListContainer = new Canvas();
      displayListContainer.width  = width;
      displayListContainer.height = height;
      displayListContainer.horizontalScrollPolicy = displayListContainer.verticalScrollPolicy = "off";
      
      // Default display mechanism: display lists.
      addChild(displayListContainer);

      initializeUI();
      
      objects = new Vector.<GameObject>();
      
      updateNumSimulationObjects();
      
      // Start simulation.
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function initializeUI():void
    {
      btnToggleRenderMethod = new Button();
      btnToggleRenderMethod.label = "DISPLAY LIST";
      btnToggleRenderMethod.x = 5;
      btnToggleRenderMethod.y = 5;
      btnToggleRenderMethod.width = 100;
      btnToggleRenderMethod.height = 30;   
      btnToggleRenderMethod.addEventListener(MouseEvent.CLICK, toggleRenderMethod);
      addChild(btnToggleRenderMethod);
      
      txtNumSimulationObjects = new TextInput();
      txtNumSimulationObjects.text = defaultNumSimulationObjects.toString();
      txtNumSimulationObjects.x = width - 60;
      txtNumSimulationObjects.y = 10;
      txtNumSimulationObjects.width = 50;
      txtNumSimulationObjects.height = 20;
      txtNumSimulationObjects.addEventListener(Event.CHANGE, updateNumSimulationObjects);
      addChild(txtNumSimulationObjects);
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////////////////////////
    
    private function onEnterFrame(e:Event):void
    {
      // Calculate dt.
      var currentTime:uint = getTimer();
      var dt:Number = Math.abs(currentTime - lastTime) / 1000.0;
      lastTime = currentTime;
      
      displayListContainer.graphics.clear();
      
      // Clear buffer.
      if (isRenderBlit)
      {
        blitBackBuffer.fillRect(new Rectangle(0, 0, blitBackBuffer.width, blitBackBuffer.height), 0x333333);
      }
      
      // Update (and draw) objects.
      for each (var go:GameObject in objects)
      {
        go.step(dt);
        
        if (isRenderBlit)
          go.draw(blitBackBuffer);
      }
      
      // Blit to front buffer.
      if (isRenderBlit)
      {
        blitFrontBuffer.graphics.clear();
        blitFrontBuffer.graphics.beginBitmapFill(blitBackBuffer);
        blitFrontBuffer.graphics.drawRect(0, 0, blitBackBuffer.width, blitBackBuffer.height);
        blitFrontBuffer.graphics.endFill();
      }
    }
    
    private function updateNumSimulationObjects(e:Event = null):void
    {
      var inputNumber:int = parseInt(txtNumSimulationObjects.text);
      
      if (isNaN(inputNumber))
        return;
        
      var diffObjects:int = inputNumber - objects.length;
      
      if (inputNumber <= 0 || diffObjects == 0)
        return;

      for (var i:int = 0; i < Math.abs(diffObjects); i++)
      {
        if (diffObjects > 0)
        {
          // Push a new object.
          var ball:Ball = new Ball(randomScreenPosition());
          ball.graphics.transform.colorTransform = new ColorTransform(0, 0, 0, 1, Math.random() * 255, Math.random() * 255, Math.random() * 255);
          
          objects.push(ball);
          displayListContainer.addChild(ball.graphics);
        }
        else
        {
          // Pop an object.
          displayListContainer.removeChild(objects.pop().graphics);
        }
      }
    }
    
    /**
     * Gets a random position on the viewable screen.
     */
    private function randomScreenPosition():Vector2 
    {
      return new Vector2(Math.random() * width, Math.random() * height);
    }

  }
}