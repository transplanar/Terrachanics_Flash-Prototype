package 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Glen Cooney
	 */
	public class BuildingSite extends MovieClip
	{
		var buildMenu:BuildingMenu = null;
		
		public function BuildingSite(bm:BuildingMenu) {
			buildMenu = bm;
			
			draw();
			this.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
		}
				
		private function clickHandler(e:MouseEvent) {
			buildMenu.enableMenu(this);
		}
		
		private function draw() {
			//this.graphics.beginFill(0xCC99FF);
			//this.graphics.lineStyle(2, 0x000000);	
			//this.graphics.drawCircle(0, 0, 12);
			var image = new buildingSite_mc();
			image.scaleX = 0.75;
			image.scaleY = 0.75;
			var glowFilter:GlowFilter = new GlowFilter();
			glowFilter.blurX = 50;
			glowFilter.blurY = 50;
			glowFilter.color = 0xFFFF66;
			image.filters = [glowFilter];
			//this.addChild(new buildingSite_mc());
			this.addChild(image);
		}
	}
}