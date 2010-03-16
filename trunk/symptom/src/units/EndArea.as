package units {
  
  import core.GameObject;
  import core.ObjectState;
  import mx.controls.Image;

  /** An end/exit area of a level. */
  public class EndArea extends GameObject  {
    
    public function EndArea() {
      super();
      
      _graphics = new Image();
      (graphics as Image).source = "assets/units/endArea.swf";
      graphics.width = graphics.height = 50.6;
      graphics.cacheAsBitmap = true;
      
      isPinned = true;
      
      state = ObjectState.INACTIVE;
    }
    
    override public function get radius():Number {
      return 0.5 * super.radius;
    }
    
  }
}