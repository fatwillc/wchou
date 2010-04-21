package utils
{
  import core.IBoundingCircle;
  
  /** Static constants and utility functions for math & geometry. */
  public class Geometry  {
    
    public static const DEGREES_TO_RADIANS:Number = 0.0175;
    public static const PI_OVER_TWO:Number = 1.571;
    public static const COS_30:Number = 0.866;
    
    /** Returns -1 and +1 with equal probability. */
    public static function randomSign():int {
      var random:Number = Math.random();
      
      if (random < 0.5)
        return -1;
      else
        return 1;
    }
    
    /**
     * Tests intersection of two spheres.
     * 
     * @param centerA Center point of first sphere.
     * @param radiusA Radius of first sphere.
     * @param centerB Center point of second sphere.
     * @param radiusB Radius of second sphere.
     * 
     * @return If spheres intersect, return the contact normal scaled by penetration distance. Otherwise, return null.
     */
    public static function intersect(a:IBoundingCircle, b:IBoundingCircle):Vector2 {        
      var d:Vector2 = b.getCenter().subtract(a.getCenter());
      
      var l:Number = d.length();
      if (l < a.getRadius() + b.getRadius()) {
        d.normalize(a.getRadius() + b.getRadius() - l);
        return d;
      }
      
      return null;
    }
    
  }
}