package {
	import mx.flash.UIMovieClip;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public dynamic class CellGraphic extends UIMovieClip {
		
		public function CellGraphic() {
			super();
		}
		
		public function setState(cellState:String, number:int = 0):void {		
			switch (cellState) {
				case "closed":
					gotoAndStop(1);
					break;
				case "opened":
					if (number > 0) {
						gotoAndStop(3);
						count.text = number.toString();
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
				case "mine":
					gotoAndStop(6);
					break;
			}
		}
	}
}