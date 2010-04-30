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
  
  import physical.BroadPhase;
  import physical.PhysicsComponent;
  import physical.quadtree.*;
  import physical.spatial_hash.SpatialHash;
  
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
     * Provides interface to actively modify simulation variables.
     */
    private var controlPanel:ControlPanel;    
    
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
     * If true, simulation is paused.
     */
    private var isPaused:Boolean = true;
    
    /** 
     * All current active objects.
     */
    private var objects:Vector.<GameObject>;
    
    /** 
     * The game time when the last frame was drawn.
     */
    private var lastTime:uint;
    
    ///////////////////////////////////////////////////////////////////////////
    // SIMULATION SWITCHES
    ///////////////////////////////////////////////////////////////////////////
    
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
     * The current broad-phase method being used.
     */
    private var broadPhase:int = BroadPhase.NONE;
    
    /**
     * Draw broad-phase data structure visualizations?
     */
    private var isVisualizeBroadPhase:Boolean = false;

    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR & INITIALIZATION METHODS
    ///////////////////////////////////////////////////////////////////////////

    public function Main(width:Number, height:Number, numObjects:int = defaultNumSimulationObjects)
    {
      super();
      
      this.width = width;
      this.height = height;
      
      initializeDisplays();

      initializeUI();
      
      // Set up simulation objects.
      objects = new Vector.<GameObject>();
      updateNumSimulationObjects();
      
      // Add pause/unpause listeners.
      addEventListener(MouseEvent.MOUSE_OUT,  togglePause);
      addEventListener(MouseEvent.MOUSE_OVER, togglePause);
      
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
      
      controlPanel.btnToggleBroadPhaseVisualization.addEventListener(MouseEvent.CLICK, toggleVisualizeBroadPhase);
      
      controlPanel.txtQuadtreeLeafLoad.text = Quadtree.leafLoad.toString();
      controlPanel.txtQuadtreeLeafLoad.addEventListener(Event.CHANGE, updateLeafLoad);
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // SIMULATION METHODS
    ///////////////////////////////////////////////////////////////////////////

    /**
     * Toggles between simulation pause and unpause states.
     */
    private function togglePause(e:MouseEvent):void
    {
      if (e.type == MouseEvent.MOUSE_OUT)
        isPaused = true;
      else if (e.type == MouseEvent.MOUSE_OVER)
        isPaused = false;
    }

    /**
     * The main simulation loop.
     */
    private function onEnterFrame(e:Event):void
    {
      // TODO Make this init check prettier.
      if (!controlPanel.initialized)
        return;
      
      // Calculate dt.
      var currentTime:uint = getTimer();
      var dT:Number = Math.abs(currentTime - lastTime) / 1000.0;
      lastTime = currentTime;
      
      if (isPaused)
        return;
      
      graphics.clear();
      
      // Clear draw buffer.
      if (isRenderBlit)
        blitBackBuffer.fillRect(new Rectangle(0, 0, blitBackBuffer.width, blitBackBuffer.height), 0x333333);
      
      if (isCollisions)
        processCollisions(dT);
      
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
      
      controlPanel.lblFps.update(dT);
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
      // TODO Improve DRY wrt collision algorithms.
      
      /////////////////////////////////////////////////////////////////////////
      // Construct broad-phase data structure, if applicable.
      if (broadPhase == BroadPhase.QUADTREE) 
      {
        var quadtree:Quadtree = new Quadtree(new Rectangle(0, 0, width, height), objects);
        
        if (isVisualizeBroadPhase)
          quadtree.visualize(this);
      }
      else if (broadPhase == BroadPhase.SPATIAL_HASH)
      {
        var objectSize:Number = objects[0].physics.boundingCircle.radius * 2;
        var spatialHash:SpatialHash = new SpatialHash(new Rectangle(0, 0, width, height), objects, objectSize);
        
        if (isVisualizeBroadPhase)
          spatialHash.visualize(this);
      }
      
      // Maximum number of collision passes.
      var maxIters:int = 3;
      
      // Current number of pair-wise resolution passes.
      var currIters:int = 0;
      
      // Have no collisions occured during this pass?
      var noCollisions:Boolean = false;
      
      while (currIters < maxIters && !noCollisions)
      {
        noCollisions = true;
        
        ///////////////////////////////////////////////////////////////////////
        // Pair-wise collisions
        if (broadPhase == BroadPhase.NONE)
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
              
              var response:Vector2n = nextP.computeCollision(nextQ);
              if (response != null)
              {
                noCollisions = false;
                
                p.physics.v.acc(response,  1);
                q.physics.v.acc(response, -1);
              }
            }
          }
        }
        ///////////////////////////////////////////////////////////////////////
        // Quadtree collisions
        else if (broadPhase == BroadPhase.QUADTREE)
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
                
                var response:Vector2n = nextP.computeCollision(nextQ);
                if (response != null)
                {
                  noCollisions = false;
                  
                  p.physics.v.acc(response,  1);
                  q.physics.v.acc(response, -1);
                }
              }
            }
          }
        }
        ///////////////////////////////////////////////////////////////////////
        // Spatial hash collisions
        else if (broadPhase == BroadPhase.SPATIAL_HASH)
        {
          for each (var p:GameObject in objects)
          {
            var neighbors:Vector.<GameObject> = spatialHash.getNeighbors(p);
            var nextP:PhysicsComponent = p.physics.clone();
            nextP.step(dT); 
              
            for each (var q:GameObject in neighbors)
            {
              var nextQ:PhysicsComponent = q.physics.clone();
              nextQ.step(dT);
              
              var response:Vector2n = nextP.computeCollision(nextQ);
              if (response != null)
              {
                noCollisions = false;
                
                p.physics.v.acc(response,  1);
                q.physics.v.acc(response, -1);
              }
            }
          }
        }
        
        currIters += 1;
      }
    }
    
    /**
     * Gets a random position on the viewable screen.
     */
    private function randomScreenPosition():Vector2n 
    {
      return new Vector2n(Math.random() * width, Math.random() * height);
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // UI METHODS
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * Toggles rendering method between blit and display list.
     */
    private function toggleRenderMethod(e:MouseEvent = null):void
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
    private function toggleCollisions(e:MouseEvent = null):void
    {
      isCollisions = !isCollisions;
      
      if (isCollisions)
      {
        controlPanel.btnToggleBroadPhase.visible = controlPanel.btnToggleBroadPhase.includeInLayout = true;
        controlPanel.btnToggleCollisions.label = "collisions on";
      }
      else
      {
        while (broadPhase != BroadPhase.NONE)
          toggleBroadPhase();
          
        controlPanel.btnToggleBroadPhase.visible = controlPanel.btnToggleBroadPhase.includeInLayout = false;
        controlPanel.btnToggleCollisions.label = "collisions off";
      }
    }
    
    /**
     * Toggles broad-phase collision detection.
     */
    private function toggleBroadPhase(e:MouseEvent = null):void
    {
      switch (broadPhase)
      {
        case BroadPhase.NONE:
          broadPhase = BroadPhase.QUADTREE;
          controlPanel.btnToggleBroadPhase.label = "quadtree";
          controlPanel.boxQuadtreeLeafLoad.visible = controlPanel.boxQuadtreeLeafLoad.includeInLayout = true;
          controlPanel.btnToggleBroadPhaseVisualization.visible = controlPanel.btnToggleBroadPhaseVisualization.includeInLayout = true;
          break;
        case BroadPhase.QUADTREE:
          broadPhase = BroadPhase.SPATIAL_HASH;
          controlPanel.btnToggleBroadPhase.label = "spatial hash";
          controlPanel.boxQuadtreeLeafLoad.visible = controlPanel.boxQuadtreeLeafLoad.includeInLayout = false;               
          break;
        case BroadPhase.SPATIAL_HASH:
          broadPhase = BroadPhase.NONE;
          controlPanel.btnToggleBroadPhase.label = "broad-phase off";
          controlPanel.btnToggleBroadPhaseVisualization.visible = controlPanel.btnToggleBroadPhaseVisualization.includeInLayout = false;
          break;       
      }
    }
    
    /**
     * Toggles visualization of broad-phase data structures.
     */
    private function toggleVisualizeBroadPhase(e:MouseEvent = null):void
    {
      isVisualizeBroadPhase = !isVisualizeBroadPhase;
      
      if (isVisualizeBroadPhase)
        controlPanel.btnToggleBroadPhaseVisualization.label = "visuals on";
      else
        controlPanel.btnToggleBroadPhaseVisualization.label = "visuals off";
    }
    
    private function updateLeafLoad(e:Event = null):void
    {
      var newValue:int = parseInt(controlPanel.txtQuadtreeLeafLoad.text);
      Quadtree.leafLoad = Math.max(1, isNaN(newValue) ? 1 : newValue);
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
  }
}