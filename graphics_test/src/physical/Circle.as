package physical
{
  import utils.Vector2;

  /**
   * A simple circle with a center point and fixed radius.
   */
  public class Circle
  {    
    public var center:Vector2;
    public var radius:Number;
    
    public function Circle(center:Vector2, radius:Number)
    {
      this.radius = radius;
      this.center = center;
    }
  }
}