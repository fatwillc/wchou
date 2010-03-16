package core
{
  import __AS3__.vec.Vector;
  
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  
  import mx.core.Application;
  
  /**
   * Wraps input listeners and provides input state through functions and
   * read-only properties as a singleton object.
   */
  public class InputState
  {
    /** Is the mouse left button currently pressed? */
    public static function get isMouseDown():Boolean { return _isMouseDown; }
    private static var _isMouseDown:Boolean = false;
    
    /** Most recent state of all keys. */
    private static var _currentKeys:Vector.<Boolean> = new Vector.<Boolean>(256, true);
    
    /** State of all keys in the previous global update cycle. */
    private static var _previousKeys:Vector.<Boolean> = new Vector.<Boolean>(256, true);
    
    /** Sets up mouse and keyboard listeners for singleton. */
    public static function initialize(app:Application):void
    {
      app.addEventListener(MouseEvent.MOUSE_DOWN, mouseListener);
      app.addEventListener(MouseEvent.MOUSE_UP, mouseListener);
      
      app.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
      app.stage.addEventListener(KeyboardEvent.KEY_UP, keyListener);
    }
    
    /** Must be called at the end of global update cycle. */
    public static function update():void 
    {
      for (var i:int = 0; i < _currentKeys.length; i++) 
        _previousKeys[i] = _currentKeys[i];
    }
    
    /** Was the key recently pressed? */
    public static function isKeyDown(key:uint):Boolean 
    {
      return _currentKeys[key];
    }
    
    /** Was the key pressed during the last frame? */
    public static function wasKeyDown(key:uint):Boolean 
    {
      return _previousKeys[key];
    }
    
    private static function mouseListener(e:MouseEvent):void 
    {
      _isMouseDown = (e.type == MouseEvent.MOUSE_DOWN);
    }
    
    private static function keyListener(e:KeyboardEvent):void 
    {      
      _currentKeys[e.keyCode] = (e.type == KeyboardEvent.KEY_DOWN);
    }
    
  }
}