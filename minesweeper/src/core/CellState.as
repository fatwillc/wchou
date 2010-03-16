package core
{
  /**
   * Enumeration of possible cell states.
   */
  public final class CellState
  {
    /** 
     * Initial, unclicked state.  
     * No information is shown.
     */
    public static const CLOSED:String = "closed";
    
    /**
     * Clicked state for cells without bombs.
     * Is either blank or shows a number of neighboring cells with bombs.
     */
    public static const OPENED:String = "opened";
    
    /**
     * Clicked state for cells with mines.
     * Shows the mine.
     */ 
    public static const MINE:String = "mine";
  }
}