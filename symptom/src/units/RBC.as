package units 
{
  import core.GameObject;
  import core.Color;
  
  import mx.controls.Image;

  /** A red blood cell. */
  public class RBC extends GameObject 
  {
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////

    /** The DNA color. */
    private var _dna:int;
    
    /** The cell color. */      
    private var _color:int;
    
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
    
    public function RBC() 
    {
      super(5);
      
      _graphics = new Image();
      graphics.width = graphics.height = 52.2;
      graphics.cacheAsBitmap = true;
      
      setColors(Color.RED, Color.RED);
    }
    
    /** Set cell and DNA color. */
    public function setColors(color:int, dna:int):void 
    {
      this._color = color;
      this._dna = dna;
      
      (graphics as Image).source = getSource(_color, _dna);
    }
    
    /** Gets the embedded class resource associated with a specified cell and dna color. */
    private function getSource(color:int, dna:int):Class 
    {
      switch (color) {
        case Color.RED: 
          switch (dna) {
            case Color.RED:    return RR;
            case Color.BLUE:   return RB; break;
            case Color.GREEN:  return RG; break;
            case Color.YELLOW: return RY; break;
            default: throw new Error("Unrecognized 'dna' parameter.");
          }
          break;
          
        case Color.BLUE: 
          switch (dna) {
            case Color.RED:    return BR; break;
            case Color.BLUE:   return BB; break;
            case Color.GREEN:  return BG; break;
            case Color.YELLOW: return BY; break;
            default: throw new Error("Unrecognized 'dna' parameter.");
          }
          break;
          
        case Color.GREEN: 
          switch (dna) {
            case Color.RED:    return GR; break;
            case Color.BLUE:   return GB; break;
            case Color.GREEN:  return GG; break;
            case Color.YELLOW: return GY; break;
            default: throw new Error("Unrecognized 'dna' parameter.");
          }
          break;
          
        case Color.YELLOW: 
          switch (dna) {
            case Color.RED:    return YR; break;
            case Color.BLUE:   return YB; break;
            case Color.GREEN:  return YG; break;
            case Color.YELLOW: return YY; break;
            default: throw new Error("Unrecognized 'dna' parameter.");
          }
          break;
          
        default:
          throw new Error("Unrecognized 'dna' parameter.");
      }
    }
    
    /** The DNA color. */
    public function get dna():int 
    {
      return _dna;
    }
    
    /** The cell color. */
    public function get color():int 
    {
      return _color;
    }
  }
}