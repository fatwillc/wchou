package particle
{
  /**
   * Particle emitter state enumeration.
   * 
   * Values are generated randomly within the int value range.
   */
  public final class EmitterState
  {
    /** The emitter is emitting and updating particles. */
    public static const ACTIVE:int = 90162;

    /** The emitter is no longer emitting but still updating particles. */
    public static const INACTIVE:int = -989984;
    
    /** 
     * The emitter is no longer emitting, has no particles to update 
     * and is ready for destruction. 
     */
    public static const DESTROY:int = -548488;
  }
}