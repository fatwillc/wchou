package utils {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Label;
	
	/** A frame rate counter. */
	public class FPS {
		
		protected var timer:Timer;
		protected var label:Label;
		
		protected var frames:int = 0;
		
		/** 
		 * Creates a new FPS counter.
		 * 
		 * @param label The label which will display the framerate. 
		 */
		public function FPS(label:Label)	{		
			if (label == null) {
				throw new Error("Label needs to be initialized!");
			}
				
			this.label = label;
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, tick);			
			timer.start();
			
			label.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function tick(e:TimerEvent):void {
			label.text = "FPS: " + frames;
			
			frames = 0;
		}
		
		private function enterFrame(e:Event):void {			
			frames ++;
		}

	}
}