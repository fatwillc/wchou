package units {
	
	import core.Body;
	import core.Color;
	import core.IBoundingSphere;
	
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import utils.Constants;
	import utils.Vector2;

	public class Virus extends Body implements IBoundingSphere {
		
		public static const WIDTH:Number = 28.3;
		public static const HEIGHT:Number = 43.6;
		
		public static const F_MOVE:Number = 6.0;
		public static const MAX_SPEED:Number = 400.0;
		
		protected var symptom:Symptom;
		
		public var dna:int;

		protected var radius:Number;
		
		[Embed(source='assets/virus/virus_red.swf')]
		private var red:Class;
		[Embed(source='assets/virus/virus_blue.swf')]
		private var blue:Class;
		[Embed(source='assets/virus/virus_green.swf')]
		private var green:Class;
		[Embed(source='assets/virus/virus_yellow.swf')]
		private var yellow:Class;
		[Embed(source='assets/virus/arrow.swf')]
		private var arrow:Class;
		
		// Avoids redundant computation.
		private var direction:Vector2 = new Vector2();
		private var halfWidth:Number;
		private var halfHeight:Number;
		
		public function Virus(symptom:Symptom)	{
			super();
			
			mass = 0.5;
			
			width = WIDTH;
			height = HEIGHT;
			
			x = symptom.width/2;
			y = symptom.height/2;
			
			source = red;
			
			halfWidth = width/2;
			halfHeight = height/2;
			
			// Use half the length of the diagonal.
			radius = Math.sqrt(halfWidth*halfWidth + halfHeight*halfHeight) * 0.8;
			
			// Event listeners.
			symptom.addEventListener(MouseEvent.MOUSE_MOVE, rotateToMouse);
		}
		
		public function changeDNA(dna:int):void {
			this.dna = dna;
			
			switch (dna) {
				case Color.RED: 
					source = red; break;
				case Color.BLUE: 
					source = blue; break;
				case Color.GREEN: 
					source = green; break;
				case Color.YELLOW: 
					source = yellow; break;
				default:
					throw new Error("Unrecognized 'dna' parameter.");
			}
		}
		
		public function toggleArrow(isArrow:Boolean):void {
			if (isArrow) {
				source = arrow;
			} else {
				changeDNA(dna);
			}
		}
		
		/** Rotates virus to face mouse position. */
		protected function rotateToMouse(e:MouseEvent):void {
			var m:Matrix = new Matrix();
			
			var currentRotation:Number = rotation * Constants.DEGREES_TO_RADIANS;
			
			// Virus-center-to-mouse vector in virus's local coordinates.
			var vx:Number = mouseX - halfWidth;
			var vy:Number = mouseY - halfHeight;
			
			// Since Flex takes the top-left corner of the image as the rotation axis by default, 
			// need to translate to set center, and translate back after rotation.
			m.translate(-halfWidth, -halfHeight);
			m.rotate(Math.atan2(vy, vx) + Constants.PI_OVER_TWO);
			m.translate(halfWidth, halfHeight);
			
			// Concat world transform onto local transform.
			m.concat(transform.matrix);
			
			transform.matrix = m;
			
			// Set virus direction.
			currentRotation = rotation * Constants.DEGREES_TO_RADIANS;

			direction.x = Math.sin(currentRotation);
			direction.y = -Math.cos(currentRotation);
			direction.normalize(1.0);
		}
		
		public function getDirection():Vector2 {
			return new Vector2(direction.x, direction.y);
		}
		
		// @see BoundingSphere.getCenter().
		public function getCenter():Vector2 {
			var center:Vector2 = new Vector2(x, y);
			
			center.x -= direction.x * halfHeight;
			center.y -= direction.y * halfHeight;
			center.x -= direction.y * halfWidth;
			center.y -= -direction.x * halfWidth;
			
			return center;
		}
		
		// @see BoundingSphere.getRadius().
		public function getRadius():Number {
			return radius;
		}
	}
}