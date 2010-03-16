package {
	import mx.flash.UIMovieClip;
	import flash.display.MovieClip;

	public dynamic class AsteroidGraphic extends UIMovieClip {
		
		/** Set to true when death animation finishes. */
		private var _isDeathFinished:Boolean = false;
		public function get isDeathFinished():Boolean { return _isDeathFinished; }
		
		public function AsteroidGraphic() {
			super();
		}
		
		public function playDeathAnimation():void {		
			gotoAndPlay(2);
		}
	}
}