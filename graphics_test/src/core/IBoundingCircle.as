package core 
{
  import utils.Vector2;
  
  /** A bounding circle. */
  public interface IBoundingCircle
  {
    /** Gets the center of the bounding sphere. */
    function getCenter():Vector2;
    
    /** Gets the radius of the bounding sphere. */
    function getRadius():Number;
  }
}