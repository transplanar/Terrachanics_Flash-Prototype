package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	
	public class Resource extends MovieClip 
	{
		public var _category:String; //category is the same as color
		public var _type:String = "default";
		public var color:uint;
		//public var color:uint;
		
		public var active:Boolean = false;
		//public var allocated; //OUTPUT ONLY
		//protected var _allocated:Boolean; //OUTPUT ONLY
		//public var _allocated:Boolean; //OUTPUT ONLY
		protected var _allocated:Boolean; //OUTPUT ONLY

		//public var linkedTo:Array = new Array(); //INPUT ONLY
		public var linkedTo:Object = null; //INPUT ONLY
		
		protected var strokeWidth:Number = 2;
		protected var strokeColor:uint = 0x33FF33;
		
		public var id:String = "BLANK";
		
		public var useIcons:Boolean = true;
		private var resourceTypeSmall:MovieClip =  null;
		private var resourceTypeLarge:MovieClip = null;
		
		private var highLightGlow:GlowFilter = new GlowFilter();
		//private var highLightGlow:GradientGlowFilter = new GradientGlowFilter();
		public var sfx:Sound = new Sound();
				
		//public function Resource(c:String, t:String) {
		public function Resource(c:String, t:String) {
			_category = c;
			//id = c;
			//id = Node(this.parent).id + _category;
			_type = t;
			allocated = false;
			setColor();
			highLightGlow.blurX = 50;
			highLightGlow.blurY = 50;
			highLightGlow.strength = 50;
			resourceTypeSmall.scaleX = .75;
			resourceTypeSmall.scaleY = .75;
			
			resourceTypeLarge.scaleX = .75;
			resourceTypeLarge.scaleY = .75;
		}
						
		public function setColor() {
			switch(_category) {
				case "red":
					color = 0xFF3333;
					resourceTypeSmall = new GasResourceSmall();
					resourceTypeLarge = new GasResourceLarge();
					highLightGlow.color = 0xFF3333;
					resourceTypeSmall.filters = [highLightGlow];
					break;
				case "yellow":
					resourceTypeSmall = new PowerResourceSmall();
					resourceTypeLarge = new PowerResourceLarge();
					color = 0x00CCFF;
					highLightGlow.color = 0xFFFF00;
					resourceTypeSmall.filters = [highLightGlow];
					break;
				case "blue":
					resourceTypeSmall = new PowerResourceSmall();
					resourceTypeLarge = new PowerResourceLarge();
					color = 0x00CCFF;
					highLightGlow.color = 0x00CCFF;
					resourceTypeSmall.filters = [highLightGlow];
					break;
				case "orange":
					color = 0xFF9933;
					resourceTypeSmall = new OilResourceSmall();
					resourceTypeLarge = new OilResourceLarge();
					highLightGlow.color = 0xFF9933;
					resourceTypeSmall.filters = [highLightGlow];
					break;
				case "gray":
					color = 0xCCCC99;
					resourceTypeSmall = new CoalResourceSmall();
					resourceTypeLarge = new CoalResourceLarge();
					highLightGlow.color = 0x9933FF;
					resourceTypeSmall.filters = [highLightGlow];
					break;
				case "purple":
					color = 0x9933FF;
					resourceTypeSmall = new CoalResourceSmall();
					resourceTypeLarge = new CoalResourceLarge();
					highLightGlow.color = 0x9933FF;
					resourceTypeSmall.filters = [highLightGlow];
					break;
				//case "yellow":
					//color = 0xFFFF33;
					//resourceTypeSmall = new PowerResourceSmall();
					//resourceTypeLarge = new PowerResourceLarge();
				//	break;
				case "green":
					color = 0x33FF33;
					resourceTypeSmall = new MoneyResourceSmall();
					resourceTypeLarge = new MoneyResourceLarge();
					highLightGlow.color = 0x33FF33;
					resourceTypeSmall.filters = [highLightGlow];
					break;
				case "brown":
					color = 0x996633;
					resourceTypeSmall = new WasteResourceSmall();
					resourceTypeLarge = new WasteResourceLarge();
					highLightGlow.color = 0x996633;
					resourceTypeSmall.filters = [highLightGlow];
					break;
				default:
					trace("Invalid color!");
					color = 0xFFFFFF;
					break;
			}
		}
		
		//Allows you to change a resource icon to change from its small to large version
		public function changeSize(mode:String) {
			
			if(useIcons){
				if (this.numChildren > 0) {
					this.removeChildAt(0);
				}
				
				if (mode == "small") {
					if (_type == "output") {			
						//resourceTypeSmall.alpha = 1.0;
						this.addChild(resourceTypeSmall);
						
					}else if (_type == "extraOutput") {
						//var tempResource = resourceTypeSmall;
						//resourceTypeSmall.alpha = 0.5;
						//this.addChild(tempResource);					
						this.graphics.beginFill(color);
						this.graphics.lineStyle(strokeWidth, strokeColor);	
						this.graphics.drawCircle(0, 0, 10);
						
						this.addChild(resourceTypeSmall);
						//this.graphics.drawCircle(resourceTypeSmall.x, resourceTypeSmall.y, 2);
						
					}
					else if (_type == "input") {
						//resourceTypeSmall.alpha = 1.0;
						//this.addChild(resourceTypeLarge);
						this.addChild(resourceTypeSmall);
					}				
				}else if (mode == "big") {
					if (_type == "output" || _type == "extraOutput") {
						//resourceTypeLarge.alpha = 0.5;
						this.addChild(resourceTypeLarge);
					}else if (_type == "input") {
						//resourceTypeSmall.alpha = 1.0;
						this.addChild(resourceTypeLarge);
					}
				}
			}
			else {
				this.graphics.clear();
													
				if (mode == "small") {
					
					this.graphics.beginFill(color);
					this.graphics.lineStyle(strokeWidth, strokeColor);	
					
					if (_type == "output") {
						this.graphics.drawCircle(0, 0, 5);
					}else if (_type == "extraOutput") {						
						this.graphics.drawCircle(0, 0, 8);
					}
					else if (_type == "input") {
						this.graphics.drawRect(-2.5,2.5,10,10)
					}				
				}else if (mode == "big") {
					this.graphics.beginFill(color);
					this.graphics.lineStyle(strokeWidth, strokeColor);	
					
					if (_type == "output" || _type == "extraOutput") {
						this.graphics.drawCircle(0, 0, 10);		
					}else if (_type == "input") {
						this.graphics.drawRect(-5,5,10,10)
					}
				}	
			}			
		}
		
		public function set allocated(b:Boolean):void {
			_allocated = b;
			
			if (_allocated) {
				this.strokeWidth = 3;
				this.strokeColor = 0x0000FF;
				resourceTypeSmall.filters = [];
				resourceTypeLarge.filters = [];
			}else {
				this.strokeWidth = 0.5;
				this.strokeColor = 0x000000;
				
				if(resourceTypeSmall != null){
					resourceTypeSmall.filters = [highLightGlow];
					resourceTypeLarge.filters = [highLightGlow];	
				}
			}
		}
		
		public function get allocated():Boolean {
			return _allocated;
		}
	}	
}