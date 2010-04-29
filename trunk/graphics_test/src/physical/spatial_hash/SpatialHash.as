package physical.spatial_hash
{
  import __AS3__.vec.Vector;
  
  import core.GameObject;
  
  import flash.geom.Rectangle;
  
  import mx.core.UIComponent;
  
  import utils.Tuple2i;
  import utils.Vector2n;
  
  /**
   * A spatial hash maps locations in a rectangular domain to game objects.
   */
  public class SpatialHash
  {
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * The "hash" data structure.
     * Really just a two-dimensional grid.
     */
    private var grid:Vector.<GameObject>;
    
    /**
     * Number of grid rows.
     */
    private var rows:int;
    
    /**
     * Number of grid columns.
     */
    private var cols:int;
    
    /**
     * The physical bounds of the objects being contained.
     */
    private var boundingArea:Rectangle;
    
    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////
    
    public function SpatialHash(boundingArea:Rectangle, objectsToContain:Vector.<GameObject>, maxObjectSize:Number)
    {
      this.boundingArea = boundingArea;
      
      var epsilon:int = 0;
      rows = boundingArea.height / (maxObjectSize + epsilon);
      cols = boundingArea.width  / (maxObjectSize + epsilon);
      
      grid = new Vector.<GameObject>(rows * cols);
      
      for each (var go:GameObject in objectsToContain)
        putObject(go);
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////////////////////////
    
    /**
     * Draws shapes on a given component visualizing the hash grid.
     * Highlights cells containing objects.
     * 
     * @param component - the component to draw on.
     */
    public function visualize(component:UIComponent):void
    {
      var cellWidth:Number  = boundingArea.width  / cols;
      var cellHeight:Number = boundingArea.height / rows;
      
      for (var i:int = 0; i < cols; i++)
      {
        for (var j:int = 0; j < rows; j++)
        {
          if (grid[toGrid(i, j)] == null) 
            component.graphics.lineStyle(1, 0x00ff00, 0.1);
          else
            component.graphics.lineStyle(1, 0xff0000, 0.6);

          component.graphics.drawRect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
        }
      }
    }
    
    /**
     * Returns all non-null neighbors of a given cell.
     * 
     * @param x - the row of the cell.
     * @param y - the column of the cell.
     */ 
    public function getNeighbors(go:GameObject):Vector.<GameObject>
    {
      var gridLocation:Tuple2i = map(go.physics.p);
      var x:int = gridLocation.x;
      var y:int = gridLocation.y;
      
      var neighbors:Vector.<GameObject> = new Vector.<GameObject>();
      
      if (x > 0)
      {
        if (y > 0)
          neighbors.push(grid[toGrid(x-1, y-1)]);
        
        neighbors.push(grid[toGrid(x-1, y)]);
        
        if (y < rows - 1)
          neighbors.push(grid[toGrid(x-1, y+1)]);
      }
      
      if (y > 0)
        neighbors.push(grid[toGrid(x, y-1)]);
        
      if (y < rows - 1)
        neighbors.push(grid[toGrid(x, y+1)]);
      
      if (x < cols - 1)
      {
        if (y > 0)
          neighbors.push(grid[toGrid(x+1, y-1)]);

        neighbors.push(grid[toGrid(x+1, y)]);
        
        if (y < rows - 1)
          neighbors.push(grid[toGrid(x+1, y+1)]);
      }
      
      neighbors = neighbors.filter(function(go:GameObject, i:int, v:Vector.<GameObject>):Boolean { return go != null; });
      
      return neighbors;
    }
    
    /**
     * Adds an object to the spatial hash. 
     * May replace an existing object in the hash.
     */
    private function putObject(go:GameObject):void
    {
      var gridLocation:Tuple2i = map(go.physics.p); 
      grid[toGrid(gridLocation.x, gridLocation.y)] = go;
    }
    
    /**
     * Translates a two-dimensional coordinate to the grid's one-dimensional index representation.
     */
    private function toGrid(x:int, y:int):int 
    { 
      if (x < 0 || x >= cols || y < 0 || y >= rows)
        throw new Error("Coordinates are outside bounds of spatial hash.");
        
      return x + y * cols; 
    }
    
    /**
     * Maps a screen position to a grid cell location.
     * 
     * @param p - the screen position.
     * 
     * @return A tuple containing the corresponding grid row and column.
     */
    private function map(p:Vector2n):Tuple2i
    {
      var x:int = p.x / boundingArea.width  * cols;
      var y:int = p.y / boundingArea.height * rows;
      
      return new Tuple2i(x, y);
    }
  }
}