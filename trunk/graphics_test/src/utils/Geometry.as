package utils
{
  /** 
   * Static constants and utility functions for math & geometry. 
   */
  public class Geometry 
  {
    public static const degreesToRadians:Number = 0.0175;
    
    public static const piOverTwo:Number = 1.571;
    
    public static const cos30:Number = 0.866;
    
    /** 
     * Returns -1 and +1 with equal probability. 
     */
    public static function randomSign():int 
    {
      return (Math.random() < 0.5) ? -1 : 1;
    }
  }
}