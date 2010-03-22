package {
	import mx.flash.UIMovieClip;
	import flash.events.Event;
	import flash.display.MovieClip;

	public dynamic class UfoGraphic extends UIMovieClip {
		
		public static const DEATH:String = "death";
		
		public function UfoGraphic() {
			super();
		}

		public function playDeathAnimation():void {
			gotoAndPlay(20);
		}
	}
}