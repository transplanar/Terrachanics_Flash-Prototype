package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class WorkerUnit extends Unit
	{		
		//public function WorkerUnit(start:Node, lh:LinkHandler) {
		public function WorkerUnit(start:Node, lh:LinkHandler, i:int) {
			color = 0xFF0000;
			//_category = "worker";
			this.addChild(new WorkerUnitImage());
			//image = new WorkerUnitImage();
			id = "WorkerUnit" + i;
			
			super(start);
		}
		
		override public function effect() {
			//Apply effect to attachedTo
			this.attachedTo.extraOutputActive = true;
			this.attachedTo.setMode(this.attachedTo.mode); //Refresh current mode of target
		}
		
		override public function unEffect() {
			this.attachedTo.extraOutputActive = false;
			trace("Current mode = " + this.attachedTo.mode);
			this.attachedTo.setMode(this.attachedTo.mode); //Refresh current mode of target
		}
	}	
}