package physical.spatial_hash
{
  import __AS3__.vec.Vector;
  
  import core.GameObject;
  
  import flash.geom.Rectangle;
  
  /**
   * A spatial hash maps locations in a rectangular domain to game objects.
   */
  public class SpatialHash
  {
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
    
    private var boundingArea:Rectangle;
    
    public function SpatialHash(boundingArea:Rectangle, maxObjectSize:Number)
    {
      this.boundingArea = boundingArea;
      
      var epsilon:int = 2;
      
      rows = boundingArea.width  / (maxObjectSize + epsilon);
      cols = boundingArea.height / (maxObjectSize + epsilon);
      
      grid = new Vector.<GameObject>(rows * cols);
    }
    
    /**
     * Returns all non-null neighbors of a given cell.
     * 
     * @param x - the row of the cell.
     * @param y - the column of the cell.
     */ 
    public function getNeighbors(x:int, y:int):Vector.<GameObject>
    {
      if (x < 0 || x >= rows || y < 0 || y >= cols)
        throw new Error("Specified coordinates outside hash domain.");
      
      var neighbors:Vector.<GameObject> = new Vector.<GameObject>();
      
      if (x > 0)
      {
        if (y > 0)
          neighbors.push(grid[toGrid(x-1, y-1)]);
        
        neighbors.push(grid[toGrid(x-1, y)]);
        
        if (y < cols)
          neighbors.push(grid[toGrid(x-1, y+1)]);
      }
      
      if (y > 0)
        neighbors.push(grid[toGrid(x, y-1)]);
        
      if (y < cols)
        neighbors.push(grid[toGrid(x, y+1)]);
      
      if (x < rows)
      {
        if (y > 0)
          neighbors.push(grid[toGrid(x+1, y-1)]);

        neighbors.push(grid[toGrid(x+1, y)]);
        
        if (y < cols)
          neighbors.push(grid[toGrid(x+1, y+1)]);
      }
      
      neighbors = neighbors.filter(function(go:GameObject, i:int, v:Vector.<GameObject>):Boolean { return go != null; });
      
      return neighbors;
    }
    
    /**
     * Adds an object to the spatial hash. 
     * May replace an existing object in the hash.
     */
    public function putObject(go:GameObject):void
    {
      var x:int = int(go.physics.p.x / boundingArea.width)  * rows;
      var y:int = int(go.physics.p.y / boundingArea.height) * cols;
      
      if (x < 0 || x >= rows || y < 0 || y >= rows)
        throw new Error("Object falls outside of hash domain.");
        
      grid[toGrid(x, y)] = go;
    }
    
    /**
     * Clears the hash of all (key, value) pairs.
     */
    public function clear():void
    {
      grid = new Vector.<GameObject>();
    }
    
    /**
     * Translates a two-dimensional coordinate to the grid's one-dimensional index representation.
     */
    private function toGrid(x:int, y:int):int { return x + cols * y; }
  }
}