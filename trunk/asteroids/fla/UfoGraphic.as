package {
	import mx.flash.UIMovieClip;
	import flash.display.MovieClip;

	public dynamic class UfoGraphic extends UIMovieClip {
		
		public var isDead:Boolean = false;
		
		public function UfoGraphic() {
			super();
		}

		public function playDeathAnimation():void {
			gotoAndPlay(20);
		}
	}
}