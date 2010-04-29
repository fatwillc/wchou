package physical
{
  /**
   * Enumeration of broad phase methods.
   */
  public final class BroadPhase
  {
    /**
     * Represents the absence of any broad phase mechanism.
     */
    public static const NONE:uint = 33123854;
    
    /**
     * Uses a quadtree for spatial subdivision.
     */
    public static const QUADTREE:uint = 112243520;
    
    /**
     * Uses spatial hashing to implement spatial locality.
     */
    public static const SPATIAL_HASH:uint = 139193864;
  }
}