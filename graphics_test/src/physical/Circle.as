package physical
{
  import utils.Vector2n;

  /**
   * A simple circle with a center point and fixed radius.
   */
  public class Circle
  { 
    /** 
     * The center of the circle.
     */   
    public var center:Vector2n;
    
    /**
     * The circle's radius.
     */
    public var radius:Number;

    public function Circle(center:Vector2n, radius:Number)
    {
      this.radius = radius;
      
      this.center = center;
    }
  }
}