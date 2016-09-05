package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Unit extends MovieClip 
	{		
		public var attachedTo:Node = null;
		//public var _category:String ="";
		public var color:uint;
		public var destination:Node = null;
		public var destinationNode:Node = null;
		//public var moveSpeed:int = 66 * .75; //Pixels moved per turn
		public var moveSpeed:Number = 0; //Pixels moved per turn
		
		public var moving:Boolean = false;
		
		public var xAdj = 40;
		
		//public var yAdj = -40;
		public var yAdj = -10;
		
		protected var image:MovieClip = new MovieClip();
		
		public var id:String = "";
		
		public var testNodes:Array = new Array();
								
		public function Unit(start:Node) {
			attachedTo = start;
			
			this.x = start.x + xAdj;
			this.y = start.y + yAdj;
			draw();			
		}
		
		protected function draw() {
			//this.graphics.beginFill(color);
			//this.graphics.lineStyle(2, 0x000000);	
			//this.graphics.drawCircle(0, 0, 12);		
			//this.addChild(image);
			
			//image.scaleX = 0.25;
			//image.scaleY = 0.25;
			
			//this.addChild(image);
			this.scaleX = 0.75;
			this.scaleY = 0.75;
		}
		
		public function setDestination(d:Node):void {
			calcSpeed(d);
			
			unEffect();
			destination = new Node("blank");
			destination.x = d.x + xAdj;
			destination.y = d.y + yAdj;
			destinationNode = d;
		}
		
		public function effect() {
			//Overriden by subclass
		}
		
		public function unEffect() {
			//Overriden by subclass
		}
		
		protected function calcSpeed(n:Node) {
			//var pixelDist:Number = Point.distance(new Point(attachedTo.x, attachedTo.y), new Point(n.x, n.y));
			//
			//var gridDist:Number = 0;
			//var dx = attachedTo.gridX - n.gridX;
			//var dy = attachedTo.gridY - n.gridY;
			//
			//if ( (dx < 0 && dy < 0) || (dx > 0 && dy > 0)) {
				//gridDist = Math.max(Math.abs(dx), Math.abs(dy));
			//}else {
				//gridDist = Math.abs(dx) + Math.abs(dy);
			//}
			//
			//moveSpeed = pixelDist / (gridDist-1);
			moveSpeed = 1000;
		}
	}	
}