package units {
  
  import core.GameObject;
  import core.Color;
  import core.IBoundingCircle;
  import core.InputState;
  import core.ObjectState;
  import core.SoundManager;
  
  import flash.events.TimerEvent;
  import flash.geom.Matrix;
  import flash.utils.Timer;
  
  import mx.controls.Image;
  
  import utils.Geometry;
  import utils.Vector2;

  /** The player-controlled virus. */
  public class Virus extends GameObject {
    
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /** Force of virus movement. */
    private static const F_MOVE:Number = 6.0;
    /** Maximum attainable speed of the virus. */
    private static const MAX_SPEED:Number = 400.0;
    /** Window of time immediately following cell infection for launching. */
    private static const LAUNCH_TIME_MS:Number = 2000.0;

    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** The virus's current DNA color. */
    private var _dna:int;
    public function get dna():int { return _dna; }
  
    /** The virus's currently infected body, if any. */
    private var infected:GameObject;
    public function get isInfecting():Boolean { return infected != null; }
  
    /** Timer for virus launch. */
    private var launchTimer:Timer;
    
    /** The direction the virus is currently facing. */
    private var _direction:Vector2 = new Vector2();

    ///////////////////////////////////////////////////////////////////////////
    // EMBEDDED ASSETS
    ///////////////////////////////////////////////////////////////////////////
    
    [Embed(source='assets/virus/virus_red.swf')]
    private var red:Class;
    [Embed(source='assets/virus/virus_blue.swf')]
    private var blue:Class;
    [Embed(source='assets/virus/virus_green.swf')]
    private var green:Class;
    [Embed(source='assets/virus/virus_yellow.swf')]
    private var yellow:Class;
    
    public function Virus()  {
      super(0.5);
     
      _graphics = new Image();
     
      graphics.width = 43.3;
      graphics.height = 49.4;      
      graphics.rotation = 90;
      
      changeDNA(Color.RED);
      
      var launchDelay:Number = 100;
      launchTimer = new Timer(launchDelay, LAUNCH_TIME_MS / launchDelay);
      launchTimer.addEventListener(TimerEvent.TIMER, launch);
    } 
    
    public function infect(rbc:RBC):void {                  
      SoundManager.playRandomInfect();
      
      infected = rbc;
      rbc.graphics.alpha = 0.5;
      
      changeDNA(rbc.dna);
      toggleInfect(true);

      launchTimer.start();
    }
    
    /** Resets the state of the virus. */
    public function reset():void {
      F.x = F.y = v.x = v.y = 0;
      
      changeDNA(Color.RED);
      
      graphics.rotation = 90;
    }   
    
    override public function update(dt:Number):void {
      if (infected != null) {
        if (InputState.isMouseDown && !InputState.wasMouseDown) {
          launch();
        } else {
          // If infecting, move virus to infected object center.
          graphics.x += infected.center.x - center.x;
          graphics.y += infected.center.y - center.y;
      
          F.zero();
          v.zero();
        }
      } else {
        // Normal movement.
        if (InputState.isMouseDown) {
          var move:Vector2 = new Vector2(direction.x * F_MOVE, direction.y * F_MOVE);
          
          // Taper acceleration as virus approaches max speed.
          if (direction.dot(v) > 0) {
            move.scale((MAX_SPEED - v.length())/Virus.MAX_SPEED);
          }
          
          F.x += move.x;
          F.y += move.y;
        }
      }
        
      if (v.length() > Virus.MAX_SPEED) {
        v.normalize(Virus.MAX_SPEED);
      }
      
      rotateToMouse();
    } 

    /** Checks launch timer expiration and handles launching. */
    private function launch(e:TimerEvent = null):void {
      var img:Image = graphics as Image;
      
      if (e != null) {
        // A non-null argument means that this function was called
        // automatically by a timer. In that case, only expire the launch
        // when the timer expires.
        
        // Draw direction indicator.
        img.graphics.clear();
        img.graphics.beginFill(0xffffff, 0.75);
        img.graphics.drawCircle(graphics.width / 2, -10, 3);
        
        if (launchTimer.currentCount < launchTimer.repeatCount) {
          return;
        }
      }
      
      SoundManager.playRandomLaunch();
      
      v.acc(direction, MAX_SPEED);
      img.graphics.clear();
      toggleInfect(false);

      infected.die();
      infected = null;
      
      launchTimer.reset();
    }
    
    /** Changes the virus's DNA color. */
    private function changeDNA(dna:int):void {
      this._dna = dna;
      
      switch (dna) {
        case Color.RED: 
          (graphics as Image).source = red; break;
        case Color.BLUE: 
          (graphics as Image).source = blue; break;
        case Color.GREEN: 
          (graphics as Image).source = green; break;
        case Color.YELLOW: 
          (graphics as Image).source = yellow; break;
        default:
          throw new Error("Unrecognized 'dna' parameter.");
      }
    }
    
    /** Toggles the visual state of the virus between normal and infecting. */
    private function toggleInfect(isInfect:Boolean):void {
      if (isInfect) {
        (graphics as Image).source = null;
      } else {
        changeDNA(_dna);
      }
    }
    
    /** Rotates virus to face the current mouse position. */
    private function rotateToMouse():void {
      var m:Matrix = new Matrix();
      
      var currentRotation:Number = graphics.rotation * Geometry.DEGREES_TO_RADIANS;
 
      var halfWidth:Number = graphics.width / 2;
      var halfHeight:Number = graphics.height / 2;      
      
      // Virus-center-to-mouse vector in virus's local coordinates.
      var vx:Number = graphics.mouseX - halfWidth;
      var vy:Number = graphics.mouseY - halfHeight;
      
      // Since Flex takes the top-left corner of the image as the rotation axis by default, 
      // need to translate to set center, and translate back after rotation.
      m.translate(-halfWidth, -halfHeight);
      m.rotate(Math.atan2(vy, vx) + Geometry.PI_OVER_TWO);
      m.translate(halfWidth, halfHeight);
      
      // Concat world transform onto local transform.
      m.concat(graphics.transform.matrix);
      
      graphics.transform.matrix = m;
      
      // Set virus direction.
      currentRotation = graphics.rotation * Geometry.DEGREES_TO_RADIANS;

      _direction.x = Math.sin(currentRotation);
      _direction.y = -Math.cos(currentRotation);
      _direction.normalize(1.0);
    }
    
    /** The direction the virus is currently facing. */
    public function get direction():Vector2 {
      return _direction;
    }
  }
}