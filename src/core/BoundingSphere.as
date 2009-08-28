package core {
	
	import utils.Vector2;
	
	public interface BoundingSphere	{
		
		/** Returns the center of the bounding sphere. */
		function getCenter():Vector2;
		
		/** Returns the radius of the bounding sphere. */
		function getRadius():Number;

	}
}