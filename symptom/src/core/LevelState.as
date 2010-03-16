package core {

  /** Enumeration of possible level states. */
  public class LevelState
  {
    /** 
     * The level is currently being played. 
     */
    public static const PLAYING:String = "playing"
    
    /** 
     * The player has won the level. 
     */
    public static const WIN:String = "win";
    
    /** 
     * The player has lost the level. 
     */
    public static const LOSE:String = "lose";
  }
}