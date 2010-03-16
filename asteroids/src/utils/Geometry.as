package utils
{
  import core.GameObject;
  import core.IBoundingSphere;
  
  import flash.geom.Matrix;
  
  /** Static constants and utility functions for math & geometry. */
  public class Geometry  
  {
    public static const DEGREES_TO_RADIANS:Number = 0.0175;
    public static const PI_OVER_TWO:Number = 1.571;
    public static const COS_30:Number = 0.866;
    
    /**
     * Tests intersection of two spheres.
     * 
     * @param a - First bounding sphere.
     * @param b - Second bounding sphere.
     * 
     * @return If spheres intersect, return the contact normal scaled by penetration distance. Otherwise, return null.
     */
    public static function intersect(a:IBoundingSphere, b:IBoundingSphere):Vector2 
    {
      var d:Vector2 = b.center.subtract(a.center);
      
      var l:Number = d.length();
      if (l < a.radius + b.radius) 
      {
        d.normalize(a.radius + b.radius - l);
        return d;
      }
      
      return null;
    }

  }
}