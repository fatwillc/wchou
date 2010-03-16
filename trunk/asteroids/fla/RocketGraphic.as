package {
	import mx.flash.UIMovieClip;
	import flash.display.MovieClip;

	public dynamic class RocketGraphic extends UIMovieClip {
		
		public function RocketGraphic() {
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
		
		public function playFireAnimation():void {
			gotoAndPlay(2);
		}
		
		public function playWarpOutAnimation():void {
			gotoAndPlay(17);
		}
		
		public function playWarpInAnimation():void {
			gotoAndPlay(35);
		}
		
		public function playDeathAnimation():void {
			gotoAndPlay(53);
		}
	}
}