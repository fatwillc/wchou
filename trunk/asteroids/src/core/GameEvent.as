package core
{
  import flash.events.Event;
  
  /** A custom event that is dispatched in this game. */
  public final class GameEvent extends Event
  {
    /** Player has won the level. */
    public static const WIN:String = "win";
    
    /** Player has lost the level. */
    public static const LOSE:String = "lose";
    
    public function GameEvent(type:String)
    {
      super(type);
    }
  }
}