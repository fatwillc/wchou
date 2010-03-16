package units.wbc
{
  import flash.display.Sprite;
  
  import mx.controls.Image;
  
  import utils.Vector2;
  import utils.Geometry;

  /** 
   * A Hunter is a kind of WBC that actively moves and pursues the virus.
   */ 
  public class Hunter extends WBC
  {
    /** Maximum attainable speed of a WBC. */
    private const MAX_SPEED:Number = 600.0;
    
    /** Magnitude of virus-hunting force. */
    private const F_ATTRACTION:Number = 3.5;
    
    /** Rotational force during hunting. */
    private const F_ROTATION:Number = 50 * Geometry.randomSign();

    /** Maximum Euclidean distance at which hunting begins. */
    private const range:Number = 200.0;
    
    [Embed(source='assets/units/wbc/hunter.swf')]
    private var _source:Class;
    
    public function Hunter() {
      super();
      
      _graphics = new Image();
      (graphics as Image).source = _source;
      graphics.width = 54.0;
      graphics.height = 51.8;
    }
    
    override public function update(dt:Number):void {
      if (Symptom.DEBUG) {
        (graphics.parent as Sprite).graphics.lineStyle(1, 0x0000ff);
        (graphics.parent as Sprite).graphics.drawCircle(center.x, center.y, range);
      }
    }
    
    override public function hunt(dt:Number, virusCenter:Vector2):void {
      var center:Vector2 = this.center;
      var v:Vector2 = virusCenter.subtract(center);
      var lengthV:Number = v.length();
      
      if (lengthV < range) {
        v.normalize();
        F.acc(v, F_ATTRACTION);
        w += dt * F_ROTATION;
      }
      
      if (v.length() > MAX_SPEED) {
        v.normalize(MAX_SPEED);
      }
    }
  }
}