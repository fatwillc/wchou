package units {
  
  import utils.Vector2;
  
  /** A bounding sphere. */
  public interface IBoundingSphere  {
    
    /** Gets the center of the bounding sphere. */
    function get center():Vector2;
    
    /** Gets the radius of the bounding sphere. */
    function get radius():Number;

  }
}