package {
	import mx.flash.UIMovieClip;
	import flash.display.MovieClip;

	public dynamic class ArrowRocket extends UIMovieClip {
		
		public function ArrowRocket() {
			super();
		}
		
		public function togglePropulsion(isOn:Boolean):void {
			if (!propulsion)
				return;
			
			if (isOn)
				propulsion.alpha = 1.0;
			else
				propulsion.alpha = 0;
		}
	}
}