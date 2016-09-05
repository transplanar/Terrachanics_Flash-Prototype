//C:\Users\Seraphim\Documents\DoE Project\FlashPrototypeAS3\BuildingMenu.as

package 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Glen Cooney
	 */
	public class BuildingMenu extends MovieClip
	{
		private var uiShape:Shape = new Shape();
		private var choiceBoxes:Array = new Array();
		private var selectBoxes:Array = new Array();
		private var currentBuildingSite:BuildingSite; //The currently selected building site!
		private var linkHandlerRef = null;
		private var marquee:TextField = new TextField();
		
		private var _buildingSiteData:Array = null;
		private var buildingDisplay:Array = new Array();
		
		private var spacing:int = 30;
		private var xOffset:int = 720 - 212;
		private var yOffset:int = 200;
				
		public function BuildingMenu(lh:LinkHandler) {
			linkHandlerRef = lh;
			//draw();
			this.x = 50;
			this.y = 50;			
			this.visible = false;
		}
		
		//private function draw() {	
		public function draw() {	
			var bg:MovieClip = new MovieClip();
			bg = new MenuBG();
			this.addChild(bg);
			bg.alpha = 0.75;
			
			//@GLEN HACK FIX LATER
			//Array duplicated for code readability
			if (_buildingSiteData == null) {
				_buildingSiteData = linkHandlerRef.buildingSiteDataArray;
			}
			
			//Get building icon
			//PLACE IN FOR LOOP
			
			for (var i in _buildingSiteData) {
				buildingDisplay.push( {obj:(getBuildMenuIcon(linkHandlerRef.getClass(_buildingSiteData[i].obj.image))), id: _buildingSiteData[i].label} );

				if (i < 3) {
					buildingDisplay[i].obj.y = yOffset;
					buildingDisplay[i].obj.x = (212 * i) + xOffset;
				}else if (i >= 3 && i < 6) {
					buildingDisplay[i].obj.x = (212 * (i-3)) + xOffset;
					buildingDisplay[i].obj.y = yOffset + 212;
				}else {
					buildingDisplay[i].obj.x = (212 * (i-6)) + xOffset;
					buildingDisplay[i].obj.y = yOffset + (212*2);
				}
				
				this.addChild(MovieClip(buildingDisplay[i].obj));
				//trace(buildingDisplay[i] + " position at " + new Point(buildingDisplay[i].x, buildingDisplay[i].y));
				
				arrangeInputs(buildingDisplay[i].obj, _buildingSiteData[i].obj.inputs);
				arrangeOutputs(buildingDisplay[i].obj, _buildingSiteData[i].obj.outputs);
				
				buildingDisplay[i].obj.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			}
			
		}

		private function getBuildMenuIcon(mc:Object):Object {
			var testString:String = mc.toString();
			switch(testString) {
				case "[class House]":
					return new House_BuildIcon();
					break;
				case "[class Refinery]":
					return new Refinery_BuildIcon();
					break;
				case "[class Mine]":
					return new Mine_BuildIcon();
					break;
				case "[class SolarFarm]":
					return new SolarFarm_BuildIcon();
					break;
				case "[class NuclearPlant]":
					return new NuclearPlant_BuildIcon();
					break;
				case "[class HydroDam]":
					return new HydroDam_BuildIcon();
					break;
				case "[class GasStation]":
					return new GasStation_BuildIcon();
					break;
				case "[class CornFarm]":
					return new CornFarm_BuildIcon();
					break;
				case "[class City]":
					return new City_BuildIcon();
					break;
				case "[class PowerPlant]":
					return new PowerPlant_BuildIcon();
					break;
				case "[class WasteFacility]":
					return new WasteFacility_BuildIcon();
					break;
				default:
					trace("No matching movieclip, returning default");
					return new House_BuildIcon();
					break;
								
				//NOT YET IMPLEMENTED
				//case "[class WindFarm]":
					//return new WindFarm_BuildIcon();
				
			}
		}
		
		private function arrangeInputs(o:Object, a:Array):void {
			for (var i in a) {
				a[i].x = o.x - 50 + (i * spacing);				
				a[i].y = o.y + 50;
				a[i].scaleX = 2.0;
				a[i].scaleY = 2.0;
				this.addChild(a[i]);
				//o.addChild(a[i]);
			}
		}
		
		private function arrangeOutputs(o:Object, a:Array) {
			for (var i in a) {
				a[i].x = o.x - 50 + (i * spacing);
				a[i].y = o.y - 50;		
				a[i].scaleX = 2.0;
				a[i].scaleY = 2.0;
				this.addChild(a[i]);
				//o.addChild(a[i]);
			}
		}
				
		public function enableMenu(bs:BuildingSite) {
			this.visible = true;
			currentBuildingSite = bs;
		}
		
		public function disableMenu() {
			this.visible = false;
			currentBuildingSite = null;
		}
		
		private function clickHandler(e:MouseEvent) {
			
			trace(e.target);

			for (var i in buildingDisplay) {
				if (buildingDisplay[i].obj == e.target) {
					linkHandlerRef.replaceBuilding(currentBuildingSite, buildingDisplay[i].id);
					_buildingSiteData.splice(i, 1);
					redraw();
					break;
				}
			}
						
			disableMenu();
		}
		
		private function redraw() {
			buildingDisplay = new Array();
			
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
			
			draw();
		}
	}
}