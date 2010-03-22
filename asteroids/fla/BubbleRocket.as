package {
	import mx.flash.UIMovieClip;
	import flash.display.MovieClip;

	public dynamic class BubbleRocket extends UIMovieClip implements IRocket {
		
		public function BubbleRocket() {
			super();
		}
		
		public function reset():void {
			gotoAndStop(1);
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