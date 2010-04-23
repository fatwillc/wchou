package physical
{
  import utils.Vector2;

  /**
   * A simple circle with a center point and fixed radius.
   */
  public class Circle implements IBoundingCircle
  {
    private var _center:Vector2;
    private var _radius:Number;
    
    public function Circle(center:Vector2, radius:Number)
    {
      _center = new Vector2();
      _center.copy(center);
      
      _radius = radius;
    }

    public function getCenter():Vector2
    {
      return _center;
    }
    
    public function getRadius():Number
    {
      return _radius;
    }
  }
}