package {
	import mx.flash.UIMovieClip;
	import flash.display.MovieClip;

	public dynamic class CellGraphic extends UIMovieClip {
		
		public function CellGraphic() {
			super();
		}
		
		public function setState(cellState:String, number:int = 0):void {
			switch (cellState) {
				case "opened":
					if (number > 0) {
						count.text = number;
						gotoAndStop(3);
					} else {
						gotoAndStop(2);
					}
					break;
				case "flag":
					gotoAndStop(4);
					break;
				case "question":
					gotoAndStop(5);
					break;
			}
		}
	}
}