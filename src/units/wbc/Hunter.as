package units.wbc
{
  import utils.Vector2;

  /** 
   * A Hunter is a kind of WBC that actively moves and pursues the virus.
   */ 
  public class Hunter extends WBC
  {
    /** Maximum attainable speed of a WBC. */
    public static var MAX_SPEED:Number = 600.0;
    
    /** Magnitude of virus-hunting force. */
    public static var ATTRACTION_FORCE:Number = 3.5;

    /** Maximum Euclidean distance at which hunting begins. */
    protected var range:Number = 200.0; // Default range.
    
    private var _radius:Number;
    
    // Avoids redundant computation.
    private var halfWidth:Number;
    private var halfHeight:Number;
    
    [Embed(source='assets/units/wbc/hunter.swf')]
    private var _source:Class;
    
    public function Hunter() {
      super();
      
      this.source = _source;
      
      width = 54.0;
      height = 51.8;
      
      halfWidth = width / 2;
      halfHeight = height / 2;
      
      _radius = (width + height) / 4; // Half of the average side length.
      
      cacheAsBitmap = true;
    }
    
    override public function hunt(virusCenter:Vector2):void {
      var center:Vector2 = this.center;
      var v:Vector2 = virusCenter.subtract(center);
      var lengthV:Number = v.length();
      
      if (lengthV < range) {
        v.normalize();
        F.acc(v, ATTRACTION_FORCE);
      }
      
      if (v.length() > MAX_SPEED) {
        v.normalize(MAX_SPEED);
      }
    }
    
    override public function get center():Vector2 {
      return new Vector2(x + halfWidth, y + halfHeight);
    }
    
    override public function get radius():Number {
      return _radius;
    }
    
  }
}