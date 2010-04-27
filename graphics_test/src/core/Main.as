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
  import mx.containers.HBox;
  import mx.controls.Button;
  import mx.controls.Label;
  import mx.controls.TextInput;
  import mx.core.UIComponent;
  
  import physical.CollisionResponse;
  import physical.PhysicsComponent;
  
  import utils.*;
  
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
     * Is collision processing currently enabled?
     */
    private var _isCollisions:Boolean = false;
    
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
    
    /**
     * Toggles collision processing on and off when clicked.
     */
    private var btnToggleCollisions:Button;
    
    /**
     * For displaying current FPS.
     */
    private var lblFps:Label;

    /**
     * Computes and displays current FPS to a Label.
     */
    private var fpsDisplay:FPS;

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
      var controlPanel:HBox = new HBox();
      controlPanel.x = 5;
      controlPanel.y = 5;
      addChild(controlPanel);
     
      lblFps = new Label();
      lblFps.width = 60;
      controlPanel.addChild(lblFps);
      fpsDisplay = new FPS(lblFps);
      
      txtNumSimulationObjects = new TextInput();
      txtNumSimulationObjects.text = defaultNumSimulationObjects.toString();
      txtNumSimulationObjects.width = 75;
      txtNumSimulationObjects.height = 20;
      txtNumSimulationObjects.addEventListener(Event.CHANGE, updateNumSimulationObjects);
      controlPanel.addChild(txtNumSimulationObjects);
      
      btnToggleRenderMethod = new Button();
      btnToggleRenderMethod.label = "DISPLAY LIST";
      btnToggleRenderMethod.width = 100;
      btnToggleRenderMethod.height = 20;   
      btnToggleRenderMethod.addEventListener(MouseEvent.CLICK, toggleRenderMethod);
      controlPanel.addChild(btnToggleRenderMethod);
      
      btnToggleCollisions = new Button();
      btnToggleCollisions.label = "COLLISIONS OFF";
      btnToggleCollisions.width = 125;
      btnToggleCollisions.height = 20;   
      btnToggleCollisions.addEventListener(MouseEvent.CLICK, toggleCollisions);
      controlPanel.addChild(btnToggleCollisions);
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////////////////////////
    
    private function onEnterFrame(e:Event):void
    {
      // Calculate dt.
      var currentTime:uint = getTimer();
      var dT:Number = Math.abs(currentTime - lastTime) / 1000.0;
      lastTime = currentTime;
      
      displayListContainer.graphics.clear();
      
      // Clear draw buffer.
      if (isRenderBlit)
        blitBackBuffer.fillRect(new Rectangle(0, 0, blitBackBuffer.width, blitBackBuffer.height), 0x333333);
      
      if (_isCollisions)
        processCollisions(dT);
      
      // Update (and draw) objects.
      for each (var go:GameObject in objects)
      {
        go.step(dT);
        
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
      
      // Update FPS counter.
      fpsDisplay.update(dT);
    }
    
    /**
     * Toggles rendering method between blit and display list.
     */
    private function toggleRenderMethod(e:MouseEvent):void
    {
      isRenderBlit = !isRenderBlit;
    }    
    
    /**
     * Toggles collision processing on and off.
     */
    private function toggleCollisions(e:MouseEvent):void
    {
      _isCollisions = !_isCollisions;
      
      if (_isCollisions)
        btnToggleCollisions.label = "COLLISIONS ON";
      else
        btnToggleCollisions.label = "COLLISIONS OFF";
    }
    
    /**
     * Processes collisions for all current game objects.
     * Uses Gauss-Seidel velocity-level collision resolution.
     * Assumes no interpenetration currently exists.
     * 
     * @param dT - size of the current timestep.
     */
    private function processCollisions(dT:Number):void
    {
      // Maximum number of collision passes.
      var maxIters:int = 3;
      
      // Current number of pair-wise resolution passes.
      var currIters:int = 0;
      
      // Have no collisions occured during this pass?
      var noCollisions:Boolean = false;
      
      // For all pairs of objects, check if a collision occurs 
      // during the next timestep. If so, apply a correction impulse.
      while (currIters < maxIters && !noCollisions)
      {
        noCollisions = true;
        
        for (var i:int = 0; i < objects.length; i++)
        {
          var p:GameObject = objects[i];
          var nextP:PhysicsComponent = p.physics.clone();
          nextP.step(dT);
          
          for (var j:int = i + 1; j < objects.length; j++)
          {
            var q:GameObject = objects[j];
            var nextQ:PhysicsComponent = q.physics.clone();
            nextQ.step(dT);
            
            var response:CollisionResponse = nextP.computeCollision(nextQ);
            if (response != null)
            {
              noCollisions = false;
              
              p.physics.v.acc(response.contactNormal,  response.impulse);
              q.physics.v.acc(response.contactNormal, -response.impulse);
            }
          }
        }
        
        currIters += 1;
      }
    }
    
    /**
     * Changes the number of current simulation objects based on 
     * the contents of TextField "txtNumSimulationObjects".
     */
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
          ball.graphics.drawable.transform.colorTransform = new ColorTransform(0, 0, 0, 1, Math.random() * 255, Math.random() * 255, Math.random() * 255);
          
          objects.push(ball);
          displayListContainer.addChild(ball.graphics.drawable);
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