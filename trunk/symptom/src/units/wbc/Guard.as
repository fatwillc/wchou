package units.wbc
{
  import mx.controls.Image;
  
  import utils.Vector2;
  
  /**
   * A Guard is a kind of WBC that does not move. 
   * The virus will still die upon contact with a Guard.
   */
  public class Guard extends WBC
  {
    [Embed(source='assets/units/wbc/guard.png')]
    private var _source:Class;
    
    public function Guard() 
    {
      super();
      
      _graphics = new Image();
      (graphics as Image).source = _source;
      graphics.width = 83.0;
      graphics.height = 94.0;
      graphics.cacheAsBitmap = true; 
      
      isPinned = true;      
    }
    
    override public function get radius():Number 
    {
      return 27;
    }
  }
}