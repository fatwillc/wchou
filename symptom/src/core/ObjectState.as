package core
{
  /** Enumeration of possible object states. */
  public final class ObjectState
  {
    /**
     * An active object is interactive with other active objects.
     * This is the default state of game objects.
     */ 
    public static const ACTIVE:uint = 1013245;
    
    /** 
     * An inactive object does not interact (e.g. collide) with other objects. 
     */
    public static const INACTIVE:uint = 1693539;
    
    /**
     * A destroyed object is pending removal from the game. 
     */
    public static const DESTROY:uint = 1698404;
  }
}