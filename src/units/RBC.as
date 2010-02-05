package units {
  
  import utils.Geometry;
  import utils.Vector2;

  /** A red blood cell. */
  public class RBC extends Body implements IBoundingSphere {

    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////

    /** The DNA color. */
    private var _dna:int;
    /** The cell color. */      
    private var _color:int;
    
    private var _radius:Number;
    
    ///////////////////////////////////////////////////////////////////////////
    // EMBEDDED ASSETS
    ///////////////////////////////////////////////////////////////////////////    
    
    [Embed(source='assets/units/rbc/BB.swf')]
    private var BB:Class;
    [Embed(source='assets/units/rbc/BG.swf')]
    private var BG:Class;
    [Embed(source='assets/units/rbc/BR.swf')]
    private var BR:Class;
    [Embed(source='assets/units/rbc/BY.swf')]
    private var BY:Class;
    
    [Embed(source='assets/units/rbc/GB.swf')]
    private var GB:Class;
    [Embed(source='assets/units/rbc/GG.swf')]
    private var GG:Class;
    [Embed(source='assets/units/rbc/GR.swf')]
    private var GR:Class;
    [Embed(source='assets/units/rbc/GY.swf')]
    private var GY:Class;
    
    [Embed(source='assets/units/rbc/RB.swf')]
    private var RB:Class;
    [Embed(source='assets/units/rbc/RG.swf')]
    private var RG:Class;
    [Embed(source='assets/units/rbc/RR.swf')]
    private var RR:Class;
    [Embed(source='assets/units/rbc/RY.swf')]
    private var RY:Class;
    
    [Embed(source='assets/units/rbc/YB.swf')]
    private var YB:Class;
    [Embed(source='assets/units/rbc/YG.swf')]
    private var YG:Class;
    [Embed(source='assets/units/rbc/YR.swf')]
    private var YR:Class;
    [Embed(source='assets/units/rbc/YY.swf')]
    private var YY:Class;
    
    public function RBC()  {
      super();
      
      width = height = 52.2;
      
      _radius = width / 2;
      
      setColors(Color.RED, Color.RED);
      
      cacheAsBitmap = true;
    }
    
    /** Set cell and DNA color. */
    public function setColors(color:int, dna:int):void {
      this._color = color;
      this._dna = dna;
      
      switch (_color) {
        case Color.RED: 
          switch (_dna) {
            case Color.RED:    source = RR; break;
            case Color.BLUE:   source = RB; break;
            case Color.GREEN:  source = RG; break;
            case Color.YELLOW: source = RY; break;
            default: throw new Error("Unrecognized 'dna' parameter.");
          }
          break;
          
        case Color.BLUE: 
          switch (_dna) {
            case Color.RED:    source = BR; break;
            case Color.BLUE:   source = BB; break;
            case Color.GREEN:  source = BG; break;
            case Color.YELLOW: source = BY; break;
            default: throw new Error("Unrecognized 'dna' parameter.");
          }
          break;
          
        case Color.GREEN: 
          switch (_dna) {
            case Color.RED:    source = GR; break;
            case Color.BLUE:   source = GB; break;
            case Color.GREEN:  source = GG; break;
            case Color.YELLOW: source = GY; break;
            default: throw new Error("Unrecognized 'dna' parameter.");
          }
          break;
          
        case Color.YELLOW: 
          switch (_dna) {
            case Color.RED:    source = YR; break;
            case Color.BLUE:   source = YB; break;
            case Color.GREEN:  source = YG; break;
            case Color.YELLOW: source = YY; break;
            default: throw new Error("Unrecognized 'dna' parameter.");
          }
          break;
          
        default:
          throw new Error("Unrecognized 'dna' parameter.");
      }
    }
    
    /** The DNA color. */
    public function get dna():int {
      return _dna;
    }
    
    /** The cell color. */
    public function get color():int {
      return _color;
    }
    
    public function get center():Vector2 {
      var c:Vector2 = new Vector2(x, y);
      
      var currentRotation:Number = rotation * Geometry.DEGREES_TO_RADIANS;
      
      var direction:Vector2 = new Vector2();
      direction.x = Math.sin(currentRotation);
      direction.y = -Math.cos(currentRotation);
      direction.normalize(1.0);
      
      c.x -= (direction.x + direction.y) * _radius;
      c.y -= (direction.y - direction.x) * _radius;
      
      return c;
    }
    
    public function get radius():Number {
      return _radius;
    }
  }
}