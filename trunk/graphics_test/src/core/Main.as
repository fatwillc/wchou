package core
{
  import __AS3__.vec.Vector;
  
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Rectangle;
  import flash.utils.getTimer;
  
  import mx.containers.Canvas;
  import mx.core.UIComponent;
  
  import physical.CollisionResponse;
  import physical.PhysicsComponent;
  import physical.quadtree.*;
  
  import ui.ControlPanel;
  
  import utils.*;
  
  public class Main extends Canvas
  {
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    private static const defaultNumSimulationObjects:int = 100;
    
    ///////////////////////////////////////////////////////////////////////////
    // COMPONENTS
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
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** 
     * All current active objects.
     */
    private var objects:Vector.<GameObject>;
    
    /** 
     * The game time when the last frame was drawn.
     */
    private var lastTime:uint;
     
    /**
     * If true, renders game objects via blitting. 
     * Otherwise renders via Flash display list.
     */
    private var isRenderBlit:Boolean = false;
    
    /**
     * Is collision processing currently enabled?
     */
    private var isCollisions:Boolean = false;
    
    /**
     * Is broad-phase processing currently enabled?
     */
    private var isBroadPhase:Boolean = false;
    
    /**
     * Spatial subdivision and collision acceleration structure.
     */
    private var quadtree:Quadtree;
    
    /**
     * Computes and displays current FPS to a Label.
     */
    private var fpsDisplay:FPS;    

    /**
     * Provides interface to actively modify simulation variables.
     */
    private var controlPanel:ControlPanel;

    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR & INITIALIZATION METHODS
    ///////////////////////////////////////////////////////////////////////////

    public function Main(width:Number, height:Number, numObjects:int = defaultNumSimulationObjects)
    {
      super();
      
      this.width = width;
      this.height = height;
      
      initializeUI();

      initializeDisplays();
      
      // Set up simulation objects.
      objects = new Vector.<GameObject>();
      updateNumSimulationObjects();
      
      // Start simulation.
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function initializeDisplays():void
    {
      blitFrontBuffer = new UIComponent();
      blitBackBuffer = new BitmapData(width, height);
      displayListContainer = new Canvas();
      displayListContainer.width  = width;
      displayListContainer.height = height;
      displayListContainer.horizontalScrollPolicy = displayListContainer.verticalScrollPolicy = "off";
      
      // Default display mechanism: display lists.
      addChild(displayListContainer);      
    }
    
    private function initializeUI():void
    {
      controlPanel = new ControlPanel();
      controlPanel.x = controlPanel.y = 5;
      addChild(controlPanel);
      
      controlPanel.txtNumSimulationObjects.text = defaultNumSimulationObjects.toString();
      controlPanel.txtNumSimulationObjects.addEventListener(Event.CHANGE, updateNumSimulationObjects);
      
      controlPanel.btnToggleRenderMethod.addEventListener(MouseEvent.CLICK, toggleRenderMethod);
      
      controlPanel.btnToggleCollisions.addEventListener(MouseEvent.CLICK, toggleCollisions);
      
      controlPanel.btnToggleBroadPhase.addEventListener(MouseEvent.CLICK, toggleBroadPhase);
      
      fpsDisplay = new FPS(controlPanel.lblFps);
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////////////////////////

    private function onEnterFrame(e:Event):void
    {
      // TODO Make this init check prettier.
       if (!controlPanel.initialized)
        return;
      
      // Calculate dt.
      var currentTime:uint = getTimer();
      var dT:Number = Math.abs(currentTime - lastTime) / 1000.0;
      lastTime = currentTime;
      
      // Clear any drawn shapes.
      graphics.clear();
      
      // Clear draw buffer.
      if (isRenderBlit)
        blitBackBuffer.fillRect(new Rectangle(0, 0, blitBackBuffer.width, blitBackBuffer.height), 0x333333);

      if (isBroadPhase) 
      {
        quadtree = new Quadtree(new Rectangle(0, 0, width, height), objects);
        quadtree.visualize(this);
      }
      
      if (isCollisions)
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
      
      if (isRenderBlit)
      {
        controlPanel.btnToggleRenderMethod.label = "blit";
        removeChild(displayListContainer);
        addChildAt(blitFrontBuffer, 0);
      }
      else
      {
        controlPanel.btnToggleRenderMethod.label = "display list"
        removeChild(blitFrontBuffer);
        addChildAt(displayListContainer, 0);
      }
    }
    
    /**
     * Toggles collision processing on and off.
     */
    private function toggleCollisions(e:MouseEvent):void
    {
      isCollisions = !isCollisions;
      
      if (isCollisions)
      {
        controlPanel.btnToggleBroadPhase.enabled = true;
        controlPanel.btnToggleCollisions.label = "collisions on";
      }
      else
      {
        controlPanel.btnToggleBroadPhase.enabled = false;
        controlPanel.btnToggleCollisions.label = "collisions off";
      }
    }
    
    /**
     * Toggles broad-phase collision detection.
     */
    private function toggleBroadPhase(e:MouseEvent):void
    {
      isBroadPhase = !isBroadPhase;
      
      if (isBroadPhase)
      {
        controlPanel.btnToggleBroadPhase.label = "quadtree";
        controlPanel.boxQuadtreeLeafLoad.visible = controlPanel.boxQuadtreeLeafLoad.includeInLayout = true;        
      }
      else
      {
        controlPanel.btnToggleBroadPhase.label = "broad-phase off";
        controlPanel.boxQuadtreeLeafLoad.visible = controlPanel.boxQuadtreeLeafLoad.includeInLayout = false;        
      }
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
      
      while (currIters < maxIters && !noCollisions)
      {
        noCollisions = true;
        
        ///////////////////////////////////////////////////
        // Pair-wise collisions
        if (!isBroadPhase)
        {
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
        }
        ///////////////////////////////////////////////////
        // Quadtree collisions
        else
        {
          for each (var leaf:QuadtreeNode in quadtree.leaves)
          {
            for (var i:int = 0; i < leaf.containedObjects.length; i++)
            {
              var p:GameObject = leaf.containedObjects[i];
              var nextP:PhysicsComponent = p.physics.clone();
              nextP.step(dT);    
              
              for (var j:int = i + 1; j < leaf.containedObjects.length; j++)
              {
                var q:GameObject = leaf.containedObjects[j];
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
      var inputNumber:int = parseInt(controlPanel.txtNumSimulationObjects.text);
      
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

          objects.push(ball);
          displayListContainer.addChild(ball.graphics.drawable);
        }
        else
        {
          // Pop an object.
          displayListContainer.removeChild(objects.pop().graphics.drawable);
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