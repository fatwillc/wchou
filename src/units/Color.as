package units {
  
  /** An enumeration (AS3 does not have built-in enum) of possible DNA colors of cells and the virus. */
  public final class Color  {
    
    public static const RED:int    = 0;
    public static const BLUE:int   = 1;
    public static const GREEN:int  = 2; 
    public static const YELLOW:int = 3;
    
    public static function toString(code:int):String {
      var name:String;
      
      switch (code) {
        case RED:    name = "Red"; break;
        case BLUE:   name = "Blue"; break;
        case GREEN:  name = "Green"; break;
        case YELLOW: name = "Yellow"; break;
        default: throw new Error("Unrecognized color code.");
      }
      
      return name;
    }

    public static function fromString(name:String):int {
      var code:int;
      
      switch (name.toLowerCase()) {
        case "red":    code = RED; break;
        case "blue":   code = BLUE; break;
        case "green":  code = GREEN; break;
        case "yellow": code = YELLOW; break;
        default: throw new Error("Unrecognized color name.");
      }
      
      return code;
    }

  }
}