package physical
{
  import utils.Vector2n;
  
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
    public function get contactNormal():Vector2n { return _contactNormal; }
    private var _contactNormal:Vector2n;
    
    public function CollisionResponse(j:Number, n:Vector2n)
    {
      _impulse = j;
      
      _contactNormal = n;
    }
  }
}