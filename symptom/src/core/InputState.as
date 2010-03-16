package core
{
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.ui.Keyboard;
  
  import mx.core.Application;
  
  /**
   * Wraps input listeners and provides input state as read-only properties.
   * Implemented as a singleton.
   */
  public class InputState
  {
    public static function initialize(application:Application):void {
      application.addEventListener(MouseEvent.MOUSE_DOWN, mouseListener);
      application.addEventListener(MouseEvent.MOUSE_UP, mouseListener);
    }

    /** Is the mouse button currently pressed? */
    public static function get isMouseDown():Boolean {
      return _isMouseDown;
    }
    private static var _isMouseDown:Boolean = false;
    
    /** Was the mouse button pressed last frame? */
    public static function get wasMouseDown():Boolean {
      return _wasMouseDown;
    }
    private static var _wasMouseDown:Boolean = false;
    
    /** 
     * Updates input state "last frame" values. 
     * Must be called during update cycle in game loop.
     */
    public static function update():void {
      _wasMouseDown = _isMouseDown;
    }
    
    protected static function mouseListener(e:MouseEvent):void {
      _isMouseDown = (e.type == MouseEvent.MOUSE_DOWN);
    }
    
  }
}