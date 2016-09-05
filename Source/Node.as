package  {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import Resource;
	
	
	public class Node extends MovieClip {
		//Inputs
		//Outputs
		
		//protected var resourceDist = 30;
		protected var resourceDist = 100;
		protected var resourceSpacingSmall = 20;
		protected var resourceSpacingBig = 50;
		
		public var inputs = new Array();
		public var outputs = new Array();
		public var basicOutputs = new Array(); //Excludes extra outputs
							
		public var highlight:Shape = new Shape();;
		protected var highlightRadius = 80;

		public var active:Boolean = false;
		public var inputsNeeded = 0;	
		
		public var linkable:Boolean = false;
		
		public var mode:String = "default";
		public var unitAllowed:Class = null; //@GLEN CHANGE THIS LATER
		public var upgradeAvailable:String = "";
		
		
		public var extraOutput:Resource = null;
		public var extraOutputActive:Boolean = false;
		
		public var id:String = new String();
		
		public var gridX:int = 0;
		public var gridY:int = 0;
		
		public var image:MovieClip = new MovieClip();
		//public var image:MovieClip = new MovieClip();
		//public var image:String = "";
		
		var glowFilter:GlowFilter = new GlowFilter();
		//var blurFilter:BlurFilter = new BlurFilter();
		
		
		//@GLEN
		
								
		//@GLEN change so that different building types extend this Node class
		//public function Node(e:Resource=null) {
		public function Node(s:String, e:Resource=null) {
			//Superclass for all buildings
			
			//id = "Default";
			id = s;
			extraOutput = e;
			
			//Setting up glow properties
			glowFilter.blurX = 50;
			glowFilter.blurY = 50;
			//glowFilter.color = 0xFFFF66;			
		}	
	
		public function setUp() {
			this.addChild(image);
			image.scaleX = 0.75;
			image.scaleY = 0.75;
			setMode();

			if (extraOutput != null){
				outputs.push(extraOutput);
			}
			
			arrangeInputs();
			arrangeOutputs();
						
			for (var i in inputs) {
				this.addChild(inputs[i]);
				//inputs[i].id += "-" + this.id;
				inputs[i].id = inputs[i]._category + "-" + this.id;
			}
			
			for (i in outputs) {
				this.addChild(outputs[i]);
				//outputs[i].alpha = 0.25;
				outputs[i].id = outputs[i]._category + "-" + this.id;
			}
						
			//Create Highlight
			highlight = new Shape();
			
			highlight.graphics.lineStyle(5, 0x66FF00);
			highlight.graphics.drawCircle(this.x, this.y, highlightRadius);
			this.addChild(highlight);
			highlight.visible = false;
			
			inputsNeeded = inputs.length;
						
			checkInputs(true);
		}
		
		public function reset() {
			inputsNeeded = inputs.length;
			linkable = false;
		}
		
		public function checkInputs(set:Boolean=false):Boolean {
		//public function checkInputs(){
			if (inputsNeeded < 1) {
				if(set){
					setMode("active");
				}
				
				return true;
			}else {
				if(set){
					setMode("default");
				}
				
				return false;
			}
			
			return false;
		}	
				
		//@GLEN CHANGE TO LOOK THE WAY I WANT IT TO
		private function arrangeInputs():void {			
			var spacing:Number;
			if (this.mode == "selected") {
				spacing = resourceSpacingBig;
			}else {
				spacing = resourceSpacingSmall;
			}
			
			for (var i in inputs) {
				//angleXY(inputs[i], 225 + (45 * i), resourceDist, this.x, this.y);
				//inputs[i].x = this.x - 20 + (i * resourceSpacing);
				inputs[i].x = this.x - 30 + (i * spacing);
				//inputs[i].y = this.y + 40;
				inputs[i].y = this.y + 30;
			}
		}
		
		private function arrangeOutputs() {
			//var spacing:Number;
			var spacing:Number = 20;
			
			var targetPosition:Point = new Point();
			
			targetPosition = globalToLocal(new Point(this.x, this.y));
			//targetPosition = localToGlobal(new Point(this.x, this.y));
			if(this.parent != null){
				if(!(this.parent.x == 0 && this.parent.y == 0)){
					targetPosition += new Point(this.parent.x, this.parent.y);
				}
			}
			
			if (this.mode == "selected") {
				spacing = resourceSpacingBig;
				//targetPosition = globalToLocal(new Point(this.x, this.y));
			}else {
				spacing = resourceSpacingSmall;
				//targetPosition = new Point(this.x, this.y);
			}
			
			for (var i in outputs) {
				//angleXY(outputs[i], 140 - (45 * i), resourceDist, this.x, this.y);
				
				//outputs[i].x = this.x - 20 + (i * resourceSpacing);
				// outputs[i].x = Point(localToGlobal(this.x - 30 + (i * spacing))).x;
				outputs[i].x = targetPosition.x - 30 + (i * spacing);
				//outputs[i].y = Point(localToGlobal( this.y - 40)).y;				
				outputs[i].y = targetPosition.y - 40;		
			}
		}
		
		//private function redrawOutputs() {
			//for (var i in outputs) {
				//this.removeChild(outputs[i]);
				//outputs[i].x = this.x * -1;
				//outputs[i].y = this.y * -1;
			//}
			//trace(this.id + "'s position is " + new Point(this.x, this.y));
			//trace("First output location is " + new Point(outputs[0].x, outputs[0].y));
			//
			//
			//arrangeOutputs();
			//
			//trace("AFTER First output location is " + new Point(outputs[0].x, outputs[0].y));
		//}
			
		//MOVED FROM NODE CLASS. @GLEN CHANGE THIS!
		public function setMode(s:String = "default") {
			glowFilter.color = 0xFFFF66;
			//trace("Setting mode to " + s);
			//Modes: 
			//-Selected (inputs inactive, outputs large, highlight invisible)
			//-Active (outputs active, inputs inactive, highlight invisible)
			//-Valid (inputs active, outputs inactive, highlight visible)			
			//-Default (inputs active, outputs inactive, highlight invisible)
			mode = s;
					
			//Takes string: selected, valid, default
			switch(s) {
				case "selected": //When a building is clicked on
					//MovieClip(this.getChildAt(this.numChildren-1)).filters = [];
					image.filters = [glowFilter];
					resourceDist = 20;					
					
					for (var i in outputs) {
						if (outputs[i]._type != "extraOutput" ||
						(outputs[i]._type == "extraOutput" && extraOutputActive)
						){
							outputs[i].changeSize("big");
							outputs[i].active = true;
							//outputs[i].alpha = 1;	
							
							arrangeOutputs();
							//redrawOutputs();
						}
					}
					
					if(inputs.length > 0){
						for (i in inputs) {
							inputs[i].changeSize("small");
							inputs[i].active = false;
							//inputs[i].alpha = 0.25;	
						}
					}
					
					active = true;
					highlight.visible = false;

					break;
				case "valid": //When a building is in range to be linked to
					//MovieClip(this.getChildAt(this.numChildren - 1)).filters = [];
					//image.filters = [];
					glowFilter.color = 0x33FF33;
					image.filters = [glowFilter];
					resourceDist = 20;

					for (i in outputs) {
						if (outputs[i]._type != "extraOutput" ||
						(outputs[i]._type == "extraOutput" && extraOutputActive)
						){
							outputs[i].changeSize("small");
							outputs[i].active = false;						
							//outputs[i].alpha = 0.25;	
						}
					}
					
					if(inputs.length > 0){
						for (i in inputs) {
							inputs[i].changeSize("small");
							inputs[i].active = true;
							//inputs[i].alpha = 1;	
						}
					}
					
					active = true;
					//highlight.visible = true;
					highlight.visible = false;
					break;				
				case "active": //When all inputs are satisfied. Building can output to other buildings
					//MovieClip(this.getChildAt(this.numChildren-1)).filters = [glowFilter];
					image.filters = [glowFilter];
					resourceDist = 20;

					for (i in outputs) {
						//HACK
						//outputs[i].mouseEnabled = t;
												
						if (outputs[i]._type != "extraOutput" ||
						(outputs[i]._type == "extraOutput" && extraOutputActive)
						){
							outputs[i].changeSize("small");
							outputs[i].active = true;
							//outputs[i].alpha = 1;	
						}else {
							outputs[i].changeSize("small");
							outputs[i].active = false;
							//outputs[i].alpha = 0.25;	
						}
					}
					
					if(inputs.length > 0){
						for (i in inputs) {
							inputs[i].changeSize("small");
							inputs[i].active = false;
							//inputs[i].alpha = 0.25;	
						}
					}
					
					active = true;
					highlight.visible = false;
					
					arrangeOutputs();
					break;
					
					break;	
				case "disabled": //Outputs and inputs are disabled
					//MovieClip(this.getChildAt(this.numChildren-1)).filters = [];
					image.filters = [];
					resourceDist = 20;
				
					//for (i in outputs) {
					for (i in outputs) {
						if (outputs[i]._type != "extraOutput" ||
						(outputs[i]._type == "extraOutput" && extraOutputActive)
						){
							outputs[i].changeSize("small");
							outputs[i].active = false;
							//outputs[i].alpha = 0.25;	
						}
					}
					
					if(inputs.length > 0){
						for (i in inputs) {
							inputs[i].changeSize("small");
							inputs[i].active = false;
							//inputs[i].alpha = 0.25;	
						}
					}
					
					active = false;
					highlight.visible = false;
					
					break;	
					
				default: //Default state if no inputs are satisfied
					//MovieClip(this.getChildAt(this.numChildren-1)).filters = [];
					image.filters = [];
					resourceDist = 20;
				
					for (i in outputs) {
						outputs[i].changeSize("small");
						outputs[i].active = false;	
						//outputs[i].alpha = 0.25;							
					}
					
					if(inputs.length > 0){
						for (i in inputs) {
							inputs[i].changeSize("small");
							inputs[i].active = true;
							//inputs[i].alpha = 1;	
						}
					}
					
					arrangeOutputs();
					
					active = false;
					highlight.visible = false;
					break;
			}
		}
		
		//Allocate output of given index
		public function allocateOutput(index:int) {
			outputs[index].allocated = true;
		}
		
		//Takes the target node and the string of the resource category
		//Finds the corresponding input on this node and links the given node to it.
		public function addOutput(n:Node, cat:String):Boolean {
		//public function addOutput(n:Node, cat:String):String {
			//var midBreakID:String = "";
			var overloaded:Boolean = false;
			
			for (var i in inputs) {
				if (inputs[i]._category == cat) {
					if (inputs[i].linkedTo != null) {
		//				midBreakID = inputs[i].id;
						overloaded = true;
					}
					
					inputs[i].linkedTo = { node:n, link_cat:cat };
					inputsNeeded -= 1;
					//checkInputs(true);
					break; //Terminate loop if match is found
				}
			}
			
			//return midBreakID;
			return overloaded;
		}
		
		public function rebuildOutput(n:Node) {
			//Needed?
		}
		
		//Takes category of output this node is losing
		
		//public function removeOutput(cat:String) {
		//public function removeOutput(n:Node, cat:String) {
		public function removeOutput(n:Node) {
			//Loop through all inputs on this node
			//If this node has any matches, remove that node from that input's linkedTo parameter
			
			//ADD: if any inputs.linkedTo are of the same category as cat, don't do anything
			
			for (var i in inputs) {		
				if(inputs[i].linkedTo!=null){
					if (inputs[i].linkedTo.node.id == n.id) {
						inputs[i].linkedTo = null;
						inputsNeeded += 1;
						checkInputs();
					}
				}
			}
		}
					
		//Based on Flashpunk angleXY function
		private function angleXY(object:Object, angle:Number, length:Number = 1, x:Number = 0, y:Number = 0):void
		{
			angle *= Math.PI / -180;
			object.x = Math.cos(angle) * length + x;
			object.y = Math.sin(angle) * length + y;
		}
	}	
}