package core
{
  /** An enumeration of possible states of game objects. */
  public class ObjectState
  {
    /** Object is fully interactive. */
    public static const ACTIVE:int = -1948148;
    
    /** 
     * Object is not interactive with level and other objects but still present. 
     * E.g. used for transitionary periods after rocket is destroyed to show 
     * destruction animation before removal from scene.
     */
    public static const INACTIVE:int = 1794415;
    
    /** Object is to be removed. */
    public static const DESTROY:int = -1313321;
  }
}