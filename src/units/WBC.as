package units {
  
  import utils.Vector2;

  /** A white blood cell. */
  public class WBC extends Body implements IBoundingSphere  {
    
    /** Maximum attainable speed of a WBC. */
    public static var MAX_SPEED:Number = 40.0;
    
    /** Magnitude of virus-hunting force. */
    public static var ATTRACTION_FORCE:Number = 1.0;

    /** Maximum Euclidean distance at which hunting begins. */
    protected var range:Number = 200.0; // Default range.
    
    private var _radius:Number;
    
    // Avoids redundant computation.
    private var halfWidth:Number;
    private var halfHeight:Number;
    
    [Embed(source='assets/units/wbc/wbc.swf')]
    private var _source:Class;
    
    public function WBC()  {
      super();
      
      this.source = _source;
      
      width = 56.3;
      height = 53.9;
      
      halfWidth = width / 2;
      halfHeight = height / 2;
      
      _radius = width / 2;
      
      cacheAsBitmap = true;
    }
    
    /** Checks whether virus is within range of this WBC and "hunts" it if so. */
    public function hunt(virusCenter:Vector2):void {
      var center:Vector2 = this.center;
      var v:Vector2 = virusCenter.subtract(center);
      var lengthV:Number = v.length();
      
      if (lengthV < range) {
        v.normalize();
        F.acc(v, WBC.ATTRACTION_FORCE);
      }
      
      if (v.length() > WBC.MAX_SPEED) {
        v.normalize(WBC.MAX_SPEED);
      }
    }
    
    public function get center():Vector2 {
      return new Vector2(x + width/2, y + height/2);
    }
    
    public function get radius():Number {
      return _radius;
    }
    
  }
}