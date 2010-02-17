package core
{
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.ui.Keyboard;
  
  import mx.core.Application;
  
  /**
   * Wraps input listeners and provides input state as read-only properties.
   */
  public class InputState
  {
    public function get isMouseDown():Boolean {
      return _isMouseDown;
    }
    private var _isMouseDown:Boolean = false;
    
    /** Was the mouse button pressed last frame? */
    public var wasMouseDown:Boolean = false;
    
    public function InputState(application:Application) {
      application.addEventListener(MouseEvent.MOUSE_DOWN, mouseListener);
      application.addEventListener(MouseEvent.MOUSE_UP, mouseListener);
    }
    
    /** 
     * Updates input state "last frame" values. 
     * Must be called during update cycle in game loop.
     */
    public function update():void {
      wasMouseDown = _isMouseDown;
    }
    
    protected function mouseListener(e:MouseEvent):void {
      _isMouseDown = (e.type == MouseEvent.MOUSE_DOWN);
    }
    
  }
}