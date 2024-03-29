package core
{
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  
  import mx.core.Application;
  
  /**
   * Wraps input listeners and provides input state as read-only properties.
   * Implemented as a singleton.
   */
  public class InputState
  {
    private static var currentKeys:Vector.<Boolean> = new Vector.<Boolean>(256);
    private static var previousKeys:Vector.<Boolean> = new Vector.<Boolean>(256);
    
    /** Sets up event listeners on specified application. */
    public static function initialize(application:Application):void 
    {
      application.addEventListener(MouseEvent.MOUSE_DOWN, mouseListener);
      application.addEventListener(MouseEvent.MOUSE_UP, mouseListener);
      
      application.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
      application.stage.addEventListener(KeyboardEvent.KEY_UP, keyListener);
    }
    
    /** Is the specified key currently pressed? */
    public static function isKeyDown(keyCode:uint):Boolean 
    {
      if (keyCode >= currentKeys.length)
        throw new Error("Unrecognized key code.");
      
      return currentKeys[keyCode]; 
    }    
    
    /** Was the specified key pressed last frame? */
    public static function wasKeyDown(keyCode:uint):Boolean 
    {
      if (keyCode >= previousKeys.length)
        throw new Error("Unrecognized key code.");
      
      return previousKeys[keyCode]; 
    }
    
    /** Is the mouse button currently pressed? */
    public static function get isMouseDown():Boolean { return _isMouseDown; }
    private static var _isMouseDown:Boolean = false;
    
    /** Was the mouse button pressed last frame? */
    public static function get wasMouseDown():Boolean { return _wasMouseDown; }
    private static var _wasMouseDown:Boolean = false;
    
    /** 
     * Updates input state "last frame" values. 
     * Must be called during update cycle in game loop.
     */
    public static function update():void 
    {
      _wasMouseDown = _isMouseDown;
      
      for (var i:int = 0; i < previousKeys.length; i++)
        previousKeys[i] = currentKeys[i];
    }
    
    private static function mouseListener(e:MouseEvent):void 
    {
      _isMouseDown = (e.type == MouseEvent.MOUSE_DOWN);
    }
      
    private static function keyListener(e:KeyboardEvent):void 
    {
      currentKeys[e.keyCode] = (e.type == KeyboardEvent.KEY_DOWN);
    }
    
  }
}