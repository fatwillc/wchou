package units {
	
	import utils.Vector2;

	public class WBC extends Body implements IBoundingSphere	{
		
		public static var WIDTH:Number = 56.3;
		public static var HEIGHT:Number = 53.9;
		
		public static var MAX_SPEED:Number = 40.0;
		public static var ATTRACTION_FORCE:Number = 1.0;
		
		public var range:Number;
		
		protected var radius:Number;
		
		private var halfWidth:Number = WIDTH / 2;
		private var halfHeight:Number = HEIGHT / 2;
		
		[Embed(source='assets/units/wbc/wbc.swf')]
		private var _source:Class;
		
		public function WBC()	{
			super();
			
			source = _source;
			
			width = WIDTH;
			height = HEIGHT;
			
			range = 200.0; // Default range.
			
			cacheAsBitmap = true;

			radius = Math.max(halfHeight, halfWidth);
		}
		
		// @see BoundingSphere.getCenter().
		public function getCenter():Vector2 {
			var center:Vector2 = new Vector2(x + width/2, y + height/2);

			return center;
		}
		
		// @see BoundingSphere.getRadius().
		public function getRadius():Number {
			return radius;
		}
		
	}
}