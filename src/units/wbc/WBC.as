package units.wbc {
  
  import core.GameObject;
  import core.ObjectState;
  
  import mx.effects.Fade;
  import mx.events.EffectEvent;
  
  import utils.Vector2;

  /** 
   * An abstract white blood cell. 
   */
  public class WBC extends GameObject  {
        
    /** Checks whether virus is within range of this WBC and "hunts" it if so. */
    public function hunt(virusCenter:Vector2):void {
      // Must be implemented by subclass.
    }
    
  }
}