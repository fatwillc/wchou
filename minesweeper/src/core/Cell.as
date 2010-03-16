package core
{
  import flash.events.MouseEvent;

  /** 
   * A cell may contain a mine or information about mines in neighboring cells.
   */
  public class Cell
  {
    /** 
     * Side length of a cell.
     */
    public static const sideLength:int = 15;
    
    /**
     * Does this cell contain a mine?
     */
    public var isMine:Boolean = false;
    
    /**
     * Number of cells containing mines adjacent to this cell.
     */ 
    public var neighborMines:int = 0;

    /** 
     * The current state of this cell.
     */    
    public function get state():String { return _state; }
    private var _state:String = CellState.CLOSED;

    /** 
     * The visual representation of this cell.
     */    
    public function get graphics():CellGraphic { return _graphics; }
    private var _graphics:CellGraphic;
    
    /**
     * Pointer to the game.
     * 
     * Just for calling some global-effect functions in Minesweeper.mxml.
     * Such function calls can also be implemented via event dispatches, though 
     * it is arguable which is "cleaner" in the context of such simple usage.
     */
    private var minesweeper:Minesweeper;

    /**
     * The row number of this cell in the containing grid.
     */    
    public function get x():int { return _x; }
    private var _x:int;
    
    /**
     * The column number of this cell in the containing grid.
     */
    public function get y():int { return _y; }
    private var _y:int;
    
    /**
     * Creates a new cell.
     * 
     * @param minesweeper - the main game.
     * @param x - the row number of the cell.
     * @param y - the column number of the cell.
     */ 
    public function Cell(minesweeper:Minesweeper, x:int, y:int)
    {
      super();
      
      this.minesweeper = minesweeper;
      this._x = x;
      this._y = y;
      
      _graphics = new CellGraphic();
      
      _graphics.addEventListener(MouseEvent.CLICK, click);
    }
    
    /**
     * Resets the state of this cell.
     */
    public function reset():void 
    {
      isMine = false;
      
      neighborMines = 0;
      
      _state = CellState.CLOSED;
      
      stateChanged();
    }
    
    /**
     * Opens this cell.
     */
    public function open():void
    {
      _state = isMine ? CellState.MINE : CellState.OPENED;
      
      stateChanged();
    }
    
    /**
     * Performs actions corresponding to the player clicking this cell.
     * I.e. losing the game if this cell contains a mine or opens the cell otherwise.
     */
    private function click(e:MouseEvent = null):void
    {
      if (_state == CellState.OPENED)
        return;
    
      if (isMine) 
      {
        _state = CellState.MINE;
        minesweeper.lose();
        stateChanged();
      }
      else
      {
        minesweeper.cascadeOpen(_x, _y);
        minesweeper.checkWin();
      }
    }
    
    /**
     * Performs actions when the cell state changes, i.e. updates the graphics.
     */
    private function stateChanged():void
    {
      _graphics.setState(_state, neighborMines);
    }
  }
}