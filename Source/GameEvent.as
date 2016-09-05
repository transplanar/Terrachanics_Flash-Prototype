package 
{
	import flash.display.MovieClip;
	import flash.xml.XMLNode;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Glen Cooney
	 */
	public class GameEvent 
	{
		/**
		 * @param description - text displayed in Intel UI
		 * @param function - event function executed
		 * @param trigger - turn when event occurs
		 * @param type - positive or negative
		 * @param linkedEvents - array of events caused or prevented by this event
		 * @param node - node this event is attached to (sometimes null)
		 * 
		 */
		
		public var label:String = new String();
		public var trigger:int = 0;
		public var linkedTo:Node = new Node("blank");
		public var eventPositive:Boolean = false;
		//public var upgradeRequired:Upgrade;
		public var upgradeRequired:String;
		
		protected var linkHandler:LinkHandler;
		protected var linkedEvents:Array = new Array();
		protected var points:int;
				
		public var objective:Boolean = false; //Is this event an objective?
		public var spawn:Object = null;
		public var image:MovieClip = new MovieClip();
		public var upgradeImage:MovieClip = new MovieClip();
		
		/**
		 * 
		 * @param	d Text of event
		 * @param	t Turn the event triggers
		 * @param	n Node an event is attached to
		 * @param	positive Boolean of if this event is positive
		 * @param	lh Reference to linkhanlder class
		 * @param	u Upgrade required
		 */
		 
		//public function GameEvent(d:String, t:int, n:Node, positive:Boolean,lh:LinkHandler, u:Upgrade=null) {			
		//public function GameEvent(d:String, t:int, n:Node, positive:Boolean, lh:LinkHandler, p:int, u:String = null) {			
		//ADD OBJECTIVE BOOLEAN PARAMETER
		//public function GameEvent(d:String, t:int, n:Node, positive:Boolean, lh:LinkHandler, p:int, le:Array, u:String = null) {			
		//public function GameEvent(d:String, t:int, n:Node, positive:Boolean, lh:LinkHandler, p:int, le:Array, obj:Boolean=false, s:Object=null, u:String = "") {			
		public function GameEvent(d:String, t:int, n:Node, positive:Boolean, lh:LinkHandler, p:int, le:Array, obj:Boolean=false, u:String = "") {			
			label = d;
			trigger = t;
			linkedTo = n;
			
			if(objective)
				points = 3000;
			else
				points = 1000;

			eventPositive = positive;
			linkHandler = lh;
			upgradeRequired = u;
			linkedEvents = le;
			//spawn = s;
			objective = obj;
		}
		
		/**
		 * 
		 * Checks to see if this event has been tagged/prevented
		 * 
		 */
		public function expire() {
			//extended by subclasses
			linkHandler.eventArray.splice(linkHandler.eventArray.indexOf(this), 1);
			
			linkHandler.updateEventTimers();
			
			if (objective) {
				//CREATE THIS FUNCTION
				linkHandler.expireObjective();
			}
		}
		
		/**
		 * What happens when this event is resolved
		 * 
		 */
		
		public function resolve() {
			trace("EVENT RESOLVED!");
			//extended by subclasses
			//linkHandler.eventArray.splice(linkHandler.eventArray.indexOf(this), 1);
			//linkHandler.updateEventTimers();
			//linkHandler.intel.redraw();
			//linkHandler.adjScore(points);
			
			for(var i in linkedEvents){
				//Create each new linked Event
				linkHandler.activateLinkedEvent(linkedEvents[i]);
			}
						
			if (objective) {
				//CREATE THIS FUNCTION
				linkHandler.resolveObjective();
			}
			
			//if (spawn) {								
				//REVISIT IF I MAKE MORE UNITS
				//if (String(getQualifiedClassName(spawn)) == "WorkerUnit" ||  String(getQualifiedClassName(spawn)) == "ResearcherUnit") {
					//linkHandler.unitArray.push(new spawn(linkedTo, linkHandler));
					//linkHandler.addChild(linkHandler.unitArray[linkHandler.unitArray.length - 1]);
				//}else {
					//linkHandler.upgradeArray.push(new Upgrade(linkedTo, String(spawn)));
					//linkedTo.unitAllowed = ResearcherUnit;
					//linkHandler.addChild(linkHandler.upgradeArray[linkHandler.upgradeArray.length - 1]);
				//}
			//}
			
			linkHandler.eventArray.splice(linkHandler.eventArray.indexOf(this), 1);
			
			//Needed???
			//linkHandler.updateEventTimers();
			//linkHandler.intel.redraw();
			linkHandler.adjScore(points);
		}
	}
}