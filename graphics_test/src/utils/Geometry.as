package utils
{
  /** Static constants and utility functions for math & geometry. */
  public class Geometry 
  {
    public static const DEGREES_TO_RADIANS:Number = 0.0175;
    public static const PI_OVER_TWO:Number = 1.571;
    public static const COS_30:Number = 0.866;
    
    /** Returns -1 and +1 with equal probability. */
    public static function randomSign():int 
    {
      var random:Number = Math.random();
      
      if (random < 0.5)
        return -1;
      else
        return 1;
    }
  }
}