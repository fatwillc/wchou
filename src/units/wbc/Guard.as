package units.wbc
{
  import utils.Vector2;
  
  /**
   * A Guard is a kind of WBC that does not move. 
   * The virus will still die upon contact with a Guard.
   */
  public class Guard extends WBC
  {
    [Embed(source='assets/units/wbc/guard.png')]
    private var _source:Class;
    
    private var _radius:Number;
    
    // Avoids redundant computation.
    private var halfWidth:Number;
    private var halfHeight:Number;
    
    public function Guard() {
      super();
      
      this.source = _source;
      
      width = 83.0;
      height = 94.0;
      
      halfWidth = width / 2;
      halfHeight = height / 2; 
      
      _radius = Math.min(width, height) / 2;
      
      isInteractive = false;
      
      cacheAsBitmap = true; 
    }
    
    override public function hunt(virusCenter:Vector2):void {
      // A guard is stationary; do nothing.
    }
    
    override public function get center():Vector2 {
      return new Vector2(x + halfWidth, y + halfHeight);
    }
    
    override public function get radius():Number {
      return _radius;
    }
    
  }
}