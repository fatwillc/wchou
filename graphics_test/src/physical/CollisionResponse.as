package physical
{
  import utils.Vector2;
  
  /**
   * A collision response is a tuple containing all the necessary information
   * to resolve a collision between two objects.
   */
  public class CollisionResponse
  {
    /**
     * Impulse magnitude.
     */
    public function get impulse():Number { return _impulse; }
    private var _impulse:Number;
    
    /**
     * Collision contact normal.
     */
    public function get contactNormal():Vector2 { return _contactNormal; }
    private var _contactNormal:Vector2;
    
    public function CollisionResponse(j:Number, n:Vector2)
    {
      _impulse = j;
      
      _contactNormal = n;
    }
  }
}