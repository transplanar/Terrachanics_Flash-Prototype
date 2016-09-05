package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	public class ResearcherUnit extends Unit
	{		
		private var linkHandlerRef:LinkHandler;
		//public var heldUpgrade:String = null;
		public var heldUpgrade:Upgrade = null;
		//public var image:MovieClip = null;
		
		//public function ResearcherUnit(start:Node, lh:LinkHandler) {
		public function ResearcherUnit(start:Node, lh:LinkHandler, i:int) {
			color = 0x0000FF; //Blue?
			//_category = "researcher";
			linkHandlerRef = lh;
			//image = new ResearcherUnitImage();
			
			//image.scaleX = 0.1;
			//image.scaleY = 0.1;
			//this.addChild(image);
			this.addChild(new ResearcherUnitImage());
			
			id = "ResearcherUnit" + i;
			
			super(start);
		}
		
		//override protected function draw() {
			//this.addChild(image);
			//this.scaleX = 0.75;
			//image.scaleY = 0.75;
		//}
		
		/**
		 * Two separate behaviors, based on if it is arriving at an IDEA or an EVENT
		 * 
		 * 
		 */
		
		override public function effect() {
			//Check to see if destination node has an upgrade on it
			for (var i in linkHandlerRef.upgradeArray) {
				//Picking up an upgrade
				//If one of the upgrades in the upgrade array matches this node
				if (linkHandlerRef.upgradeArray[i].linkedTo is Node){
					if (linkHandlerRef.upgradeArray[i].linkedTo.id ==  this.attachedTo.id) {
						if (heldUpgrade != null) {
							this.removeChild(heldUpgrade);
							heldUpgrade = null;
						}
						
						//ORIGINAL
						heldUpgrade = linkHandlerRef.upgradeArray[i];
						this.addChild(heldUpgrade);
						
						trace("Playing upgrade acquired sound!");
						linkHandlerRef.upgradeGainedSFX.play();
						
						heldUpgrade.attachToUnit(this);
						linkHandlerRef.adjScore(500);
						
						//Update valid unit destinations so any buildings that can require the update
						//you picked up become valid.
						for (var j in linkHandlerRef.eventArray) {
							if (String(linkHandlerRef.eventArray[j].upgradeRequired) == heldUpgrade.id) {
								linkHandlerRef.eventArray[j].linkedTo.unitAllowed = ResearcherUnit;
							}
						}
						
						break;
					}
				}else {
					for (j in linkHandlerRef.eventArray) {
						if (heldUpgrade != null) {						
							if ( (linkHandlerRef.eventArray[j].linkedTo.id ==  this.attachedTo.id) && (heldUpgrade.id == linkHandlerRef.eventArray[j].upgradeRequired) ) {
								linkHandlerRef.eventArray[j].resolve();
							}
						}
					}
				}
			
			
			//Check to see if destination node has an event on it
			for (i in linkHandlerRef.eventArray) {				
				if(linkHandlerRef.eventArray[i].upgradeRequired!=null){
					if (linkHandlerRef.eventArray[i].upgradeRequired is linkHandlerRef.getClass(this)) {
						linkHandlerRef.eventArray.splice(i, 1);
					}
				}
			}
		}
		}
		
		override public function unEffect() {
			this.attachedTo.extraOutputActive = false;
		}
	}	
}