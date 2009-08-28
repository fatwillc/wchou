package core {
	
	import mx.controls.Image;	
	import utils.Vector2;

	public class Body extends Image	{
		
		public var F:Vector2;
		public var v:Vector2;
		
		public var mass:Number;
		
		public function Body() {
			super();
			
			F = new Vector2();
			v = new Vector2();
			mass = 1.0;
		}
		
		public function step(dt:Number):void {
			x += dt * v.x;
			y += dt * v.y;
		}
		
		public function applyF():void {
			v.acc(F, 1.0/mass);
		}
		
	}
}