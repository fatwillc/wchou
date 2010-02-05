package utils
{
  /** Static constants and utility functions for math & geometry. */
  public class Geometry  {
    
    public static const DEGREES_TO_RADIANS:Number = 0.0175;
    public static const PI_OVER_TWO:Number = 1.571;
    public static const COS_30:Number = 0.866;
    
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
    public static function intersect(centerA:Vector2, radiusA:Number, centerB:Vector2, radiusB:Number):Vector2 {        
      var d:Vector2 = centerB.subtract(centerA);
      
      var l:Number = d.length();
      if (l < radiusA + radiusB) {
        d.normalize(radiusA + radiusB - l);
        return d;
      }
      
      return null;
    }
    
  }
}