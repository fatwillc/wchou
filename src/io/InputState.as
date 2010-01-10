package io
{
	import mx.core.Application;	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * Wraps input listeners and provides input state as read-only properties.
	 */
	public class InputState
	{
		/** Is the up key currently pressed? */
		public function get isUpPressed():Boolean {
			return _isUpPressed;
		}
		private var _isUpPressed:Boolean = false;		
		
		/** Is the down key currently pressed? */
		public function get isDownPressed():Boolean {
			return _isDownPressed;
		}
		private var _isDownPressed:Boolean = false;
		
		/** Is the left key currently pressed? */
		public function get isLeftPressed():Boolean {
			return _isLeftPressed;
		}
		private var _isLeftPressed:Boolean = false;
		
		/** Is the right key currently pressed? */
		public function get isRightPressed():Boolean {
			return _isRightPressed;
		}
		private var _isRightPressed:Boolean = false;		
		
		/** Is the space bar currently pressed? */
		public function get isSpacePressed():Boolean {
			return _isSpacePressed;
		}
		private var _isSpacePressed:Boolean = false;
		
		/** 
		 * Was the space bar pressed last frame? 
		 * Must be updated manually in main game loop.
		 */
		public var wasSpacePressed:Boolean = false;
		
		public function InputState(application:Application) {
			application.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
			application.stage.addEventListener(KeyboardEvent.KEY_UP, keyListener);
		}
			
		/** Keyboard event listener. */
		protected function keyListener(e:KeyboardEvent):void {
			var isKeyDown:Boolean = (e.type == KeyboardEvent.KEY_DOWN);
			
			if (e.keyCode == 87) { // W
				_isUpPressed = isKeyDown;
			} else if (e.keyCode == 83) { // S
				_isDownPressed = isKeyDown;
			} else if (e.keyCode == 65) { // A
				_isLeftPressed = isKeyDown;
			} else if (e.keyCode == 68) { // D
				_isRightPressed = isKeyDown;
			} else if (e.keyCode == Keyboard.SPACE) {
				_isSpacePressed = isKeyDown;
			}
		}

	}
}