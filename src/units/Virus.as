package units {
	
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import utils.Geometry;
	import utils.LinkedList.Node;
	import utils.Vector2;

	/** A player-controlled virus. */
	public class Virus extends Body implements IBoundingSphere {
		
		///////////////////////////////////////////////////////////////////////////
		// CONSTANTS
		///////////////////////////////////////////////////////////////////////////
		
		public static const WIDTH:Number = 28.3;
		public static const HEIGHT:Number = 43.6;
		
		/** Force of virus movement. */
		public static const F_MOVE:Number = 6.0;
		/** Maximum speed of the virus. */
		public static const MAX_SPEED:Number = 400.0;
		
		///////////////////////////////////////////////////////////////////////////
		// VARIABLES
		///////////////////////////////////////////////////////////////////////////
		
		/** The virus's current DNA color. */
		public var dna:int;
	
		/** The list node of the virus's currently infected body, if any. */
		public var infected:Node;
		
		/** Pointer to main application. */
		protected var symptom:Symptom;

		/** Radius of virus's bounding sphere. */
		protected var radius:Number;
		
		///////////////////////////////////////////////////////////////////////////
		// EMBEDDED ASSETS
		///////////////////////////////////////////////////////////////////////////
		
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
			
			changeDNA(Color.RED);
			
			halfWidth = width/2;
			halfHeight = height/2;
			
			// Use half the length of the diagonal.
			radius = Math.sqrt(halfWidth*halfWidth + halfHeight*halfHeight) * 0.55;
			
			symptom.addEventListener(MouseEvent.MOUSE_MOVE, rotateToMouse);
		}
		
		/** Resets the state of the virus. */
		public function reset():void {
			F.x = F.y = v.x = v.y = 0;
		}
		
		/** Changes the virus's DNA color. */
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
		
		/** Toggles the visual representation of the virus between an arrow and the virus graphic. */
		public function toggleArrow(isArrow:Boolean):void {
			if (isArrow) {
				source = arrow;
			} else {
				changeDNA(dna);
			}
		}
		
		/** Rotates virus to face the current mouse position. */
		protected function rotateToMouse(e:MouseEvent):void {
			var m:Matrix = new Matrix();
			
			var currentRotation:Number = rotation * Geometry.DEGREES_TO_RADIANS;
			
			// Virus-center-to-mouse vector in virus's local coordinates.
			var vx:Number = mouseX - halfWidth;
			var vy:Number = mouseY - halfHeight;
			
			// Since Flex takes the top-left corner of the image as the rotation axis by default, 
			// need to translate to set center, and translate back after rotation.
			m.translate(-halfWidth, -halfHeight);
			m.rotate(Math.atan2(vy, vx) + Geometry.PI_OVER_TWO);
			m.translate(halfWidth, halfHeight);
			
			// Concat world transform onto local transform.
			m.concat(transform.matrix);
			
			transform.matrix = m;
			
			// Set virus direction.
			currentRotation = rotation * Geometry.DEGREES_TO_RADIANS;

			direction.x = Math.sin(currentRotation);
			direction.y = -Math.cos(currentRotation);
			direction.normalize(1.0);
		}
		
		/** Gets the current direction the virus is facing. */
		public function getDirection():Vector2 {
			return new Vector2(direction.x, direction.y);
		}
		
		public function getCenter():Vector2 {
			var center:Vector2 = new Vector2(x, y);
			
			center.x -= direction.x * halfHeight + direction.y * halfWidth;
			center.y -= direction.y * halfHeight - direction.x * halfWidth;
			
			// Offset to center of virus body.
			var off:Number = 8;
			center.x -= direction.x * off;
			center.y -= direction.y * off;
			
			return center;
		}
		
		public function getRadius():Number {
			return radius;
		}
	}
}