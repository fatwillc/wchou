package units.wbc {
  
  import units.Body;
  import units.IBoundingSphere;
  
  import utils.Vector2;

  /** 
   * A white blood cell. 
   * 
   * Implemented as an unenforced abstract class. This means that the programmer
   * must check that subclasses override functions provided in this class. 
   * It seems possible to "hack" runtime enforcement of subclass -
   * [http://joshblog.net/2007/08/19/enforcing-abstract-classes-at-runtime-in-actionscript-3/].
   * For simplicity's sake that method is not applied here.
   */
  public class WBC extends Body implements IBoundingSphere  {
    
    /** Checks whether virus is within range of this WBC and "hunts" it if so. */
    public function hunt(virusCenter:Vector2):void {
      // Must be implemented by subclass.
    }
    
    public function get center():Vector2 {
      // Must be implemented by subclass.
      return null;
    }
    
    public function get radius():Number {
      // Must be implemented by subclass.
      return 0;
    }
    
  }
}