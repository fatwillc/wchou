package core {
  
  import mx.controls.Image;

  /** An end/exit area of a level. */
  public class EndArea extends Image  {
    
    public function EndArea() {
      super();
      
      width = height = 50.6;
      
      source = "assets/endArea.swf";
      
      cacheAsBitmap = true;
    }
    
  }
}