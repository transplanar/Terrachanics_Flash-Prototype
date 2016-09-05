package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Glen Cooney
	 * Contains:
		 * ID (for matching with events)
		 * Drawing functions
		 * 	Attached to building
		 *  Attached to Researcher
	 * 
	 * 
	 */
	
	public class Upgrade extends MovieClip 
	{
		public var id:String = "";
		public var linkedTo:Object;
		protected var yAdj = -25;
		protected var color:uint;
		
		protected var tooltip:MovieClip = new MovieClip();
		
		protected var image:MovieClip;
		
		public function Upgrade(n:Node,name:String, img:MovieClip) {
			linkedTo = n;
			color = 0x33FF99;
			id = name;
			
			image = img;			
			
			if(n!=null){
				this.x = n.x;
				this.y = n.y + yAdj;
			}
			draw();
			
			this.addEventListener(MouseEvent.MOUSE_OVER, tooltipHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, tooltipRemove);
		}
		
		public function draw() {	
			this.addChild(image);
			//this.graphics.beginFill(color);
			//this.graphics.lineStyle(.5, 0x000000);	
			//this.graphics.drawCircle(0, 0, 6);		
		}
		
		public function attachToUnit(u:Unit) {
			linkedTo = u;
						
			this.x = 0;
			this.y = -25;
		}
		//
		//public function detatchFromUnit() {
			//linkedTo = null;
		//}
		
		private function tooltipHandler(e:Event) {
			tooltip.x = 10;
			tooltip.y = -10;
			
			//tooltip.graphics.beginFill(0xFFFFFF);
			//tooltip.graphics.lineStyle(2, 0x000000);	
			//tooltip.graphics.drawRect(0, 0, 20, 8);

			//var textFormat:TextFormat = new TextFormat();
			//textFormat.size = 20;
			//textFormat.bold = true;
			
			var tooltipText:TextField = new TextField();
			tooltipText.text = this.id;
			tooltipText.width = 200;
			tooltipText.selectable = false;
			tooltip.addChild(tooltipText);
			tooltipText.x = 2;
			tooltipText.y = 2;
			
			this.addChild(tooltip);
		}
		
		private function tooltipRemove(e:Event) {
			this.removeChild(tooltip);	
			tooltip = new MovieClip();
		}
	}
}