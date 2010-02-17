package units {
  
  import flash.events.MouseEvent;
  import flash.geom.Matrix;
  
  import utils.Geometry;
  import utils.LinkedList.Node;
  import utils.Vector2;

  /** The player-controlled virus. */
  public class Virus extends Body implements IBoundingSphere {
    
    ///////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    
    /** Force of virus movement. */
    public static const F_MOVE:Number = 6.0;
    /** Maximum attainable speed of the virus. */
    public static const MAX_SPEED:Number = 400.0;
    
    /** Offset to center of virus body. */
    private const centerOffset:Number = 6;
    /** Radius of virus's bounding sphere. */
    private const _radius:Number = 14;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** The virus's current DNA color. */
    public var dna:int;
  
    /** The list node of the virus's currently infected body, if any. */
    public var infected:Node;
    
    /** Pointer to main application. */
    protected var symptom:Symptom;
    
    /** The direction the virus is currently facing. */
    private var _direction:Vector2 = new Vector2();
    
    // Avoids redundant computation.
    private var halfWidth:Number;
    private var halfHeight:Number;
    
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
    
    [Embed(source='assets/virus/arrow.swf')]
    private var arrow:Class;
    
    public function Virus(symptom:Symptom)  {
      super();
      
      this.symptom = symptom;
      
      width = 43.3;
      height = 49.4;
      
      mass = 0.5;
      
      rotation = 90;
      
      halfWidth = width / 2;
      halfHeight = height / 2;
      
      changeDNA(Color.RED);
      
      resume();
    }
    
    /** Freezes all virus-dependent actions. */
    public function pause():void {
      symptom.removeEventListener(MouseEvent.MOUSE_MOVE, rotateToMouse);
    }
    
    /** Unfreezes all virus-dependent actions. */
    public function resume():void {
      symptom.addEventListener(MouseEvent.MOUSE_MOVE, rotateToMouse);
    }
    
    /** Resets the state of the virus. */
    public function reset():void {
      F.x = F.y = v.x = v.y = 0;
      
      changeDNA(Color.RED);
      
      rotation = 90;
    }
    
    /** Changes the virus's DNA color. */
    public function changeDNA(dna:int):void {
      this.dna = dna;
      
      switch (dna) {
        case Color.RED: 
          source = red; break;
        case Color.BLUE: 
          source = blue; break;
        case Color.GREEN: 
          source = green; break;
        case Color.YELLOW: 
          source = yellow; break;
        default:
          throw new Error("Unrecognized 'dna' parameter.");
      }
    }
    
    /** Toggles the visual state of the virus between normal and infecting. */
    public function toggleInfect(isInfect:Boolean):void {
      if (isInfect) {
        source = null;
      } else {
        changeDNA(dna);
      }
    }
    
    /** Rotates virus to face the current mouse position. */
    protected function rotateToMouse(e:MouseEvent):void {
      var m:Matrix = new Matrix();
      
      var currentRotation:Number = rotation * Geometry.DEGREES_TO_RADIANS;
      
      // Virus-center-to-mouse vector in virus's local coordinates.
      var vx:Number = mouseX - halfWidth;
      var vy:Number = mouseY - halfHeight;
      
      // Since Flex takes the top-left corner of the image as the rotation axis by default, 
      // need to translate to set center, and translate back after rotation.
      m.translate(-halfWidth, -halfHeight);
      m.rotate(Math.atan2(vy, vx) + Geometry.PI_OVER_TWO);
      m.translate(halfWidth, halfHeight);
      
      // Concat world transform onto local transform.
      m.concat(transform.matrix);
      
      transform.matrix = m;
      
      // Set virus direction.
      currentRotation = rotation * Geometry.DEGREES_TO_RADIANS;

      _direction.x = Math.sin(currentRotation);
      _direction.y = -Math.cos(currentRotation);
      _direction.normalize(1.0);
    }
    
    /** The direction the virus is currently facing. */
    public function get direction():Vector2 {
      return _direction;
    }
    
    public function get center():Vector2 {
      var c:Vector2 = new Vector2(x, y);
      
      c.x -= _direction.x * halfHeight + _direction.y * halfWidth;
      c.y -= _direction.y * halfHeight - _direction.x * halfWidth;
      
      c.x -= _direction.x * centerOffset;
      c.y -= _direction.y * centerOffset;
      
      return c;
    }
    
    public function get radius():Number {
      return _radius;
    }
  }
}