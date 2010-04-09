package units.wbc
{
  import core.GameObject;

  import utils.Vector2;

  /**
   * An abstract white blood cell.
   */
  public class WBC extends GameObject
  {
    public function WBC()
    {
      super(5);
    }
    
    /** Checks whether virus is within range of this WBC and "hunts" it if so. */
    public function hunt(dt:Number, virusCenter:Vector2):void
    {
      // Must be implemented by subclass.
    }

  }
}