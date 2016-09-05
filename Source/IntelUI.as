//C:\Users\Seraphim\Documents\DoE Project\FlashPrototypeAS3\BuildingMenu.as

package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Glen Cooney
	 */
	public class IntelUI extends MovieClip
	{
		private var uiShape:Shape = new Shape();
		private var choiceBoxes:Array = new Array();
		private var selectBoxes:Array = new Array();
		private var linkHandlerRef = null;
		private var marquee:TextField = new TextField();
		//private var eventArray:Array;
				
		public function IntelUI(a:Array, lh:LinkHandler) {
			//eventArray = a;
			
			this.x = 750;
			this.y = 200;
			linkHandlerRef = lh;
			this.visible = false;
			
			
			//draw();
			drawOptions();
		}
		
		private function draw() {	
			//Currently does nothing
		}
		
		public function redraw() {
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
			
			choiceBoxes = new Array();
			
			draw();
			drawOptions();
		}
				
		public function drawOptions() {
			var bg:MovieClip = new MovieClip();
			bg = new MenuBG();
			this.addChild(bg);
			bg.alpha = 0.75;
			
			for (var i in linkHandlerRef.eventArray) {			
				var optionBox:MovieClip = new MovieClip();
				if (linkHandlerRef.eventArray[i].objective) {
					optionBox = new ObjectiveBox_Primary();
					optionBox.y = 100 * i;
										
					//@GLEN Put this in a separate function later
					
					//@GLEN Put this in separate function to update each time the timer is updated
					var timerFormat:TextFormat = new TextFormat();
					var timer = new TextField();
								
					timerFormat.font = "Orbitron";
					timerFormat.bold = true;
					timerFormat.size = 24;
											
					timer.text = linkHandlerRef.eventArray[i].trigger;
					timer.textColor = 0xFFFFFFF;
					timer.selectable = false;
					
					//@GLEN FIX THIS LATER. Not point in changing x and y values if already passed as a parameter
					timer.x = 365;
					timer.y = (100*i) -10 ;
					timer.width = 200;
					
					timer.setTextFormat(timerFormat);
					
					this.addChild(timer);
				}else {
					optionBox = new ObjectiveBox();
					optionBox.y = 75 * i;
				}
				
				var upgradeIconClass:Class = linkHandlerRef.getClass(linkHandlerRef.eventArray[i].upgradeImage);
				var upgradeIcon = new upgradeIconClass();
				this.addChild(upgradeIcon);
				upgradeIcon.x = -385;
				upgradeIcon.y = 100*i;
				
				this.addChild(optionBox);
					
				var optionLabel = createTextBox(-345, (75 * i)-15, linkHandlerRef.eventArray[i].label);
					
				choiceBoxes.push({box:optionBox,text:optionLabel});
				choiceBoxes[i].box.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			}
						
			displayOptionBoxes();
		}
		
		private function clickHandler(e:MouseEvent) {
			
			trace("THIS HAPPENS!");
			this.visible = !this.visible;
		}
		
		private function createTextBox(x:int, y:int, s:String):TextField {
			var optionLabelFormat:TextFormat = new TextFormat();
			var optionLabel = new TextField();
						
			optionLabelFormat.font = "Orbitron";
			optionLabelFormat.bold = true;
			optionLabelFormat.size = 18;
									
			optionLabel.text = s;
			optionLabel.textColor = 0xFFFFFFF;
			optionLabel.selectable = false;
			
			//@GLEN FIX THIS LATER. Not point in changing x and y values if already passed as a parameter
			optionLabel.x = x + 10;
			optionLabel.y = y + 5;
			optionLabel.width = 800;
			
			optionLabel.setTextFormat(optionLabelFormat);
				
			return optionLabel;
		}
	
		
		
		private function createTriggerField(x:int, y:int, s:String, pos:Boolean) {
			var optionLabel = new TextField();
			optionLabel.text = s;
			optionLabel.selectable = false;
			optionLabel.x = x + 270;
			optionLabel.y = y + 10;
			
			if (pos) {
				optionLabel.textColor = 0x006600;
			}else {
				optionLabel.textColor = 0xFF0000;
			}
						
			this.addChild(optionLabel);
		}
		
		private function createSelectionBox(index:int) {
			var selectBox:MovieClip = new MovieClip();
					
			selectBox.graphics.beginFill(0x000000);
			selectBox.graphics.lineStyle(2, 0x000000);	
			selectBox.graphics.drawRect(choiceBoxes[index].box.x, choiceBoxes[index].box.y, 350, 50);
			
			this.addChild(selectBox);
			selectBoxes.push(selectBox);
			selectBox.alpha = 0;
		}
		
		private function displayOptionBoxes() {
			for (var i in choiceBoxes) {
				this.addChild(choiceBoxes[i].box);
				this.addChild(choiceBoxes[i].text);
			}
		}
		
		public function toggleVisible() {
			redraw();
			this.visible = !this.visible;
		}
	}
}