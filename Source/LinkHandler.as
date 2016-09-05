package
{
	import fl.motion.MotionEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Glen Cooney
	 */
	
	public class LinkHandler extends MovieClip
	{
		private var reachOut = false; //If "reaching out" to make a link
		private var linkShape = new Shape(); //Shape to contain temporary link
		private var links = new Array(); //Array of shapes containing all links
		
		private var preLinks = new Array(); //Array of links made at the beginning of scenario
		
		private var linkAnchor:Object = null;
		
		private var nodeArray = new Array(); //Array of all nodes
		
		//Background (for clicking nothing)
		private var bg = new MovieClip();
		private var bgShape = new Shape();
		
		private var nodeIndex = 0; //To make creating placeholder Nodes easier
		
		//private var linkRange = 200; //Range of any link
		private var linkRange = 400; //Range of any link
		
		private var otherNodes:Array = new Array();
		private var unitIndex = 0;
		
		public var unitArray = new Array();
		
		public var upgradeArray = new Array();
		
		private var unitLinks = new Array();
		
		private var turn = 0;
		
		private var textField = new TextField();
		
		public var eventArray = new Array();
		
		private var buildingSiteArray:Array = new Array();
		private var buildingMenu = new BuildingMenu(LinkHandler(this));
		public var buildingSiteDataArray:Array = new Array();
		
		private var bsIndex = 0;
		
		private var intelButton = new MovieClip();
		
		public var intel:IntelUI;
		private var intelTriggerArray:Array = new Array();
		
		private var scoreText:TextField = new TextField();
		private var currentScore:TextField = new TextField();
		private var score:int = 0;
		
		//XML stuff
		public var xml:XML = new XML();
		//public var urlRequest:URLRequest = new URLRequest("levelData.xml");
		public var urlLoader:URLLoader = new URLLoader();
		
		//Tile parameters
		private var tileScale:Number = 3;
		//private var tileHeight:Number = (40 * 1.5) * (tileScale * 1.1);
		//private var tileHeight:Number = (40 * 1.5);
		private var tileHeight:Number = (80 * 1.5);
		//private var tileBorderWidth:Number = 1 * tileScale;
		private var tileBorderWidth:Number = 0;
		private var tile_cos30:Number = Math.cos(30 * Math.PI / 180);
		private var tileSize:Number = tileHeight / tile_cos30 / 2;
		//private var tileSize:Number = (tileHeight / tile_cos30 / 2) * tileScale;
		
		//Tile array
		private var tileArray = new Array();
		
		//Grid dimensions
		private var gridRows:int = 45;
		private var gridColumns:int = 45;
		
		//Grid positioning
		private var offsetX = tileSize + 175;
		private var offsetY = tileHeight / 2 + 110;
		
		private var linkedEventArray:Array = new Array();
		
		private var objectives:int = 0;
		
		private var levelEndBox:MovieClip = new MovieClip();
		private var levelEndText:TextField = new TextField();
		
		//Array of all objects that could block linking
		private var barrierArray:Array = new Array();
		
		private var inputText:TextField = new TextField();
		private var fileName:String = new String();
		
		public var linkGlow:GlowFilter;
		
		private var unitGlow:GlowFilter = new GlowFilter();
		
		//Event Icons
		var eventIconArray:Array = new Array();
		
		//Needed due to quirk in accessing classes by string
		WorkerUnit;
		ResearcherUnit;
		
		//Setting up Terrachanics font
		import flash.text.Font;
		
		//Sound variables
		private var music:Sound = new Sound();
		private var musicChannel:SoundChannel;
		
		private var enableSFX:Boolean = true;
		
		//Generic link sound
		private var linkSFX:Sound = new Sound();
		private var linkSFX_Channel:SoundChannel = new SoundChannel();
		
		//Oil link sound
		private var powerSFX:Sound = new Sound();
		private var powerSFX_Channel:SoundChannel = new SoundChannel();		
		
		//Fuel link sound
		private var fuelSFX:Sound = new Sound();
		private var fuelSFX_Channel:SoundChannel = new SoundChannel();		
		
		//Oil link sound
		private var oilSFX:Sound = new Sound();
		private var oilSFX_Channel:SoundChannel = new SoundChannel();		
		
		//Waste link sound
		private var wasteSFX:Sound = new Sound();
		private var wasteSFX_Channel:SoundChannel = new SoundChannel();		
		
		//Waste link sound
		private var coalSFX:Sound = new Sound();
		private var coalSFX_Channel:SoundChannel = new SoundChannel();	
		
		//Secondary objective resolved
		private var secondaryObjectiveSFX:Sound = new Sound();
		private var secondaryObjectiveSFX_Channel:SoundChannel = new SoundChannel();
		
		//Primary objective resolved
		private var primaryObjectiveSFX:Sound = new Sound();
		private var primaryObjectiveSFX_Channel:SoundChannel = new SoundChannel();
		
		//Menu open sound
		private var menuOpenSFX:Sound = new Sound();
		private var menuOpenSFX_Channel:SoundChannel = new SoundChannel();
		
		//Menu button pressed
		private var menuButtonPressedSFX:Sound = new Sound();
		private var menuButtonPressedSFX_Channel:SoundChannel = new SoundChannel();
		
		//Cancel sound
		private var cancelSFX:Sound = new Sound();
		private var cancelSFX_Channel:SoundChannel = new SoundChannel();
		
		//Menu acknowledge
		private var acknowledgeSelectSFX:Sound = new Sound();
		private var acknowledgeSelectSFX_Channel:SoundChannel = new SoundChannel();
		
		//Worker gained
		private var workerGainedSFX:Sound = new Sound();
		private var workerGainedSFX_Channel:SoundChannel = new SoundChannel();
		
		//Researcher gained
		private var researcherGainedSFX:Sound = new Sound();
		private var researcherGainedSFX_Channel:SoundChannel = new SoundChannel();
		
		//Researcher gained
		public var upgradeGainedSFX:Sound = new Sound();
		private var upgradeGainedSFX_Channel:SoundChannel = new SoundChannel();
		
		//Building site used
		private var buildingsiteSFX:Sound = new Sound();
		private var buildingsiteSFX_Channel:SoundChannel = new SoundChannel();
		
		//Undo turn
		//Change view mode
		
		//Additional buttons
		private var pause_mc = new PauseButton();
		private var status_mc = new Marquee();
		private var score_mc = new ScoreText();
		private var wait_mc = new WaitButton();
		private var undo_mc = new UndoButton();
		
		private var scoreTextFormat:TextFormat = new TextFormat();
		
		//For testing. Enable/disable old and new modes
		public var useIcons:Boolean = true;
		public var newMove:Boolean = false;
		
		//Display layers
		private var menuLayer:MovieClip = new MovieClip();
		private var uiLayer:MovieClip = new MovieClip();
		private var buildingLayer:MovieClip = new MovieClip();
		private var unitLayer:MovieClip = new MovieClip();
		private var linkLayer:MovieClip = new MovieClip();
		private var iconLayer:MovieClip = new MovieClip();
		private var tileLayer:MovieClip = new MovieClip();
		
		private var movingLayers:Array = new Array();
		private var scrollSpeed = 10;
		
		private var linkBreak:Boolean = false;
		
		//Constructor
		public function LinkHandler(s:Stage)
		{
			movingLayers.push(tileLayer, buildingLayer, unitLayer, linkLayer, iconLayer);
			
			currentScore.x = 800 + scoreText.textWidth + 5;
			currentScore.y = 20;
			currentScore.text = score.toString();
			
			intelButton = new IntelButton();
			intelButton.x = 1350;
			intelButton.y = 712;
			
			pause_mc.x = 70;
			pause_mc.y = 70;
			
			status_mc.x = 745;
			status_mc.y = 70;
			
			score_mc.x = 1290;
			score_mc.y = 30;
			
			scoreText.x = score_mc.x - (score_mc.width / 2);
			//scoreText.x = score_mc.x - 10;
			scoreText.y = score_mc.y + 20;
			scoreText.text = "0";
			scoreText.width = 200;
			scoreText.height = 50;
			scoreText.textColor = 0xFFCC00;
			
			scoreTextFormat.font = "Orbitron";
			scoreTextFormat.bold = true;
			
			scoreTextFormat.size = 20;
			scoreText.setTextFormat(scoreTextFormat);
			
			wait_mc.x = 75;
			wait_mc.y = 625;
			
			wait_mc.x = 75;
			wait_mc.y = 625;
			
			undo_mc.x = 128;
			undo_mc.y = 712;
			
			intelButton.addEventListener(MouseEvent.MOUSE_DOWN, intelButtonHandler);
			
			//Set up link glow
			linkGlow = new GlowFilter();
			linkGlow.blurX = 15;
			linkGlow.blurY = 15;
			
			//Set up unit glow
			unitGlow.color = 0xFFFFFF;
			unitGlow.blurX = 10;
			unitGlow.blurY = 10;
			
			//UNCOMMENTED BY DEFAULT
			//levelSelectPrompt();
			
			//UNCOMMENT FOR TESTING PURPOSES
			fileName = "CE9.1.xml";
			levelFromXML();
			setUpSounds();
		}
		
		private function setUpSounds()
		{
			music.addEventListener(Event.COMPLETE, onMusicLoadComplete);
			
			//Music
			var req:URLRequest = new URLRequest("audio/musicTrack.mp3");
			music.load(req);
			
			//Link and resource sounds
			req = new URLRequest("audio/linkSoundGeneric.mp3");
			linkSFX.load(req);
			
			req = new URLRequest("audio/powerSound.mp3");
			powerSFX.load(req);
			
			req = new URLRequest("audio/fuelSound.mp3");
			fuelSFX.load(req);
			
			req = new URLRequest("audio/oilSound.mp3");
			oilSFX.load(req);
			
			req = new URLRequest("audio/wasteSound.mp3");
			wasteSFX.load(req);
			
			req = new URLRequest("audio/coalSound.mp3");
			coalSFX.load(req);
			
			//Objective sounds
			req = new URLRequest("audio/secondaryObjectiveSound.mp3");
			secondaryObjectiveSFX.load(req);
			
			req = new URLRequest("audio/primaryObjectiveSound.mp3");
			primaryObjectiveSFX.load(req);
			
			//UI Sounds
			req = new URLRequest("audio/menuOpenSound.mp3");
			menuOpenSFX.load(req);
			
			req = new URLRequest("audio/menuPressedSound.mp3");
			menuButtonPressedSFX.load(req);
			
			req = new URLRequest("audio/cancelSound.mp3");
			cancelSFX.load(req);
			
			req = new URLRequest("audio/acknowledgeSound.mp3");
			acknowledgeSelectSFX.load(req);
			
			//Units
			req = new URLRequest("audio/workerGainedSound.mp3");
			workerGainedSFX.load(req);
			
			req = new URLRequest("audio/researcherGainedSound.mp3");
			researcherGainedSFX.load(req);
			
			//Upgrade
			req = new URLRequest("audio/upgradeGainedSound.mp3");
			upgradeGainedSFX.load(req);
			
			//Building site
		}
		
		private function onMusicLoadComplete(e:Event)
		{
			music.removeEventListener(Event.COMPLETE, onMusicLoadComplete);
			musicChannel = music.play();
			musicChannel.addEventListener(Event.SOUND_COMPLETE, onMusicChannelSoundComplete);
		}
		
		function onMusicChannelSoundComplete(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.SOUND_COMPLETE, onMusicChannelSoundComplete);
			musicChannel = music.play();
		}
		
		private function levelSelectPrompt()
		{
			inputText.type = "input"; // Set the text field as Input
			inputText.x = 200; // Distance from the left border
			inputText.y = 200; // Distance from the top border
			inputText.width = 100; // Length of the text field
			inputText.height = 20; // Height
			inputText.border = true; // Enable to display border
			inputText.borderColor = 0x0000da; // Define the border color		
			inputText.backgroundColor = 0xFFFFFF;
			inputText.background = true;
			
			inputText.text = 'Filename'; // The initial text in the input field
			
			// Add the "txt_inp" instance in the Flash presentation
			addChild(inputText)
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, fileNameKeyInputHandler);
		}
		
		private function fileNameKeyInputHandler(e:KeyboardEvent)
		{
			if (e.keyCode == 13)
			{
				if (inputText.text == "Filename")
				{
					fileName = "levelData.xml";
				}
				else
				{
					fileName = inputText.text;
				}
				
				levelFromXML();
				
				setUpSounds();
				
				removeChild(inputText);
				this.removeEventListener(KeyboardEvent.KEY_DOWN, fileNameKeyInputHandler);
			}
		}
		
		private function levelSetup()
		{
			generateTiles();
			
			for (var i = 0; i < gridRows; i++)
			{
				for (var j = 0; j < gridColumns; j++)
				{
					tileLayer.addChild(tileArray[i][j]);
				}
			}
			
			//Add display layers
			this.addChild(tileLayer);
			this.addChild(buildingLayer);
			this.addChild(linkLayer);
			this.addChild(unitLayer);
			this.addChild(iconLayer);
			this.addChild(menuLayer);
			this.addChild(uiLayer);
			
			//Adds all building sites to stage
			for (i in buildingSiteArray)
			{
				buildingLayer.addChild(buildingSiteArray[i]);
			}
			
			//Adds all buildings to stage
			for (i in nodeArray)
			{
				buildingLayer.addChild(nodeArray[i]);
			}
			
			//Adds all units to the stage
			for (i in unitArray)
			{
				unitLayer.addChild(unitArray[i]);
			}
			
			//Adds all units to the stage
			for (i in upgradeArray)
			{
				iconLayer.addChild(upgradeArray[i]);
			}
			
			//Displays timers for events next to appropriate buildings
			showEventTimers(); //Initial draw of all event timers
			setUpUpgradeIcons();
			
			uiLayer.addChild(scoreText);
			uiLayer.addChild(currentScore);
			
			//Add click listener to allow for mouse functionality
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);
			
			checkUnits();
			
			for (i in barrierArray)
			{
				buildingLayer.addChild(barrierArray[i]);
			}
			
			//Create premade links
			//for (i in preLinks) {
			//Set anchor node to the origin of this pre-made link (PML)
			//var anchorNode = getNode(preLinks[i].origin);
			//
			//Loop through all non-extra outputs
			//for (j in anchorNode.basicOutputs) {
			//If one of the outputs of the anchorNode matches the type of the pre-made link
			//if (anchorNode.basicOutputs[j]._category == preLinks[i].type) {
			//Set the link anchor to that output (type Resource)
			//linkAnchor = anchorNode.basicOutputs[j];
			//Set this resource's ID
			//linkAnchor.id = String(anchorNode.id) +  "-" + j;
			//
			//
			//CAN'T REMEMBER WHY I MADE THIS???
			//
			//If the origin of the PML has an extra output
			//if (nodeArray[getMasterNodeIndex(preLinks[i].origin)].extraOutput != null) {
			//Set the 
			//nodeArray[getMasterNodeIndex(preLinks[i].origin)].outputs[j+1].id = String(anchorNode) + j;
			//}else {
			//nodeArray[getMasterNodeIndex(preLinks[i].origin)].outputs[j].id = String(anchorNode) + j;
			//}
			//
			//anchorNode.addChild(linkAnchor);
			//}
			//}			
			//
			//if (linkAnchor == null) {
			//trace("Link impossible!");
			//}
			//
			//attemptLink(getNode(preLinks[i].target), getNode(preLinks[i].origin), preLinks[i].type);
			//
			//linkAnchor = null;
			//}
			
			//**********MENUS ADDED LAST!!!**********
			
			//Initiallizes the intel menu functionality
			intel = new IntelUI(eventArray, this);
			//Adds intel menu to the stage
			menuLayer.addChild(intel);
			
			//Add the building menu to the stage
			//NOTE: By default it is invisible
			menuLayer.addChild(buildingMenu);
			buildingMenu.draw();
			
			uiLayer.addChild(intelButton);
			uiLayer.addChild(pause_mc);
			uiLayer.addChild(status_mc);
			uiLayer.addChild(score_mc);
			uiLayer.addChild(wait_mc);
			uiLayer.addChild(undo_mc);
			
			wait_mc.addEventListener(MouseEvent.CLICK, waitButtonHandler);
		}
		
		private function waitButtonHandler(e:Event)
		{
			updateTurn();
		}
		
		private function getNode(id:String):Node
		{
			for (var i in nodeArray)
			{
				if (nodeArray[i].id == id)
				{
					return nodeArray[i];
				}
			}
			
			return null;
		}
		
		private function getMasterNodeIndex(id:String):int
		{
			for (var i in nodeArray)
			{
				if (nodeArray[i].id == id)
				{
					return i;
				}
			}
			
			return -1;
		}
		
		private function drawLevelEnd(t:String)
		{
			levelEndBox.x = 300;
			levelEndBox.y = 200;
			levelEndBox.graphics.beginFill(0xFFFFFF);
			levelEndBox.graphics.lineStyle(2, 0x000000);
			levelEndBox.graphics.drawRect(0, 0, 200, 100);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 20;
			textFormat.bold = true;
			
			levelEndText.text = t;
			levelEndText.setTextFormat(textFormat);
			levelEndText.width = 200;
			levelEndText.selectable = false;
			levelEndBox.addChild(levelEndText);
			levelEndText.x = 50;
			levelEndText.y = 40;
			
			menuLayer.addChild(levelEndBox);
		}
		
		private function keyboardHandler(e:KeyboardEvent)
		{
			if (e.keyCode == 87)
			{
				//Move up
				for (var i in movingLayers)
				{
					movingLayers[i].y += scrollSpeed;
				}
			}
			else if (e.keyCode == 83)
			{
				//Move down
				for (i in movingLayers)
				{
					movingLayers[i].y -= scrollSpeed;
				}
			}
			else if (e.keyCode == 65)
			{
				//Move left
				for (i in movingLayers)
				{
					movingLayers[i].x += scrollSpeed;
				}
			}
			else if (e.keyCode == 68)
			{
				//Move right
				for (i in movingLayers)
				{
					movingLayers[i].x -= scrollSpeed;
				}
			}
			else if (e.keyCode == 81)
			{
				//Do nothing
				if (buildingMenu.visible)
				{
					buildingMenu.disableMenu();
				}
			}
		}
		
		//private function reloadLevel() {
		//while (this.numChildren > 0) {
		//this.removeChildAt(0);
		//}
		//
		//buildingSiteArray = new Array();
		//nodeArray = new Array();
		//unitArray = new Array();
		//upgradeArray = new Array();
		//eventArray = new Array();
		//barrierArray = new Array();
		//links = new Array();
		//preLinks = new Array();
		//otherNodes = new Array();
		//unitLinks = new Array();
		//buildingSiteDataArray = new Array();
		//intelTriggerArray = new Array();
		//linkedEventArray = new Array();
		//score = 0;
		//nodeIndex = 0;
		//unitIndex = 0;
		//turn = 0;
		//bsIndex = 0;
		//objectives = 0;
		//
		//levelFromXML();
		//}
		
		//Mouse event handler for the intel button. Toggles display of the intel menu
		private function intelButtonHandler(e:MouseEvent)
		{
			intel.toggleVisible();
		}
		
		//Resets all event timers
		public function updateEventTimers()
		{
			//Remove all event timers from the stage
			for (var i in intelTriggerArray)
			{
				iconLayer.removeChild(intelTriggerArray[i]);
			}
			
			intelTriggerArray = new Array(); //Clear the event timer array
			showEventTimers(); //Redraw all event timers
			
			//@GLEN Needed?
			intel.redraw();
		}
		
		//Draws or redraws all event timers
		private function showEventTimers()
		{
			for (var i in eventArray)
			{
				var tempText = new TextField();
				
				var tempFormat = new TextFormat();
				tempFormat.size = 18;
				tempFormat.bold = true;
				
				tempText.defaultTextFormat = tempFormat;
				
				tempText.x = eventArray[i].linkedTo.x + 10;
				tempText.y = eventArray[i].linkedTo.y - 75;
				tempText.text = eventArray[i].trigger;
				tempText.selectable = false;
				tempText.width = 30;
				tempText.height = 30;
				
				tempText.textColor = 0xFFFFFF;
				
				intelTriggerArray.push(tempText);
			}
			
			for (i in intelTriggerArray)
			{
				iconLayer.addChild(intelTriggerArray[i]);
			}
		}
		
		//@GLEN Remove event icon array and instead have them be a child of their respective events
		private function setUpUpgradeIcons()
		{
			for (var i in intelTriggerArray)
			{
				if (eventArray[i].objective)
				{
					eventArray[i].image = new PrimaryEventIcon();
				}
				else
				{
					eventArray[i].image = new SecondaryEventIcon();
					intelTriggerArray[i].visible = false;
				}
				
				iconLayer.addChild(eventArray[i].image);
				
				eventArray[i].image.scaleX = 0.75;
				eventArray[i].image.scaleY = 0.75;
				eventArray[i].image.x = intelTriggerArray[i].x - 15;
				eventArray[i].image.y = intelTriggerArray[i].y + 10;
				
				if (eventArray[i].upgradeRequired != "")
				{
					for (var j in upgradeArray)
					{
						if (eventArray[i].upgradeRequired == upgradeArray[j].id)
						{
							var upgradeIcon = getUpgradeImage(j);
							upgradeIcon.x = -20;
							
							//@GLEN CHANGE TO A SETTER FUNCTION
							eventArray[i].upgradeImage = upgradeIcon;
							eventArray[i].image.addChild(eventArray[i].upgradeImage);
						}
					}
				}
			}
		}
		
		//@GLEN: Move all click handlers to where they belong!
		private function clickHandler(e:MouseEvent)
		{
			if (e.target is Resource || (e.target.parent is Resource && useIcons))
			{
				var myTarget;
				
				if (useIcons)
				{
					myTarget = e.target.parent;
				}
				else
				{
					myTarget = e.target;
				}
				
				if (myTarget.parent.mode == "selected")
				{
					//this.addEventListener(Event.ENTER_FRAME, drawTempLink);
					linkAnchor = Resource(myTarget);
					reachOut = true;
					
					//Highlight valid buildings
					otherNodes = nodeArray.slice();
					
					for (var i in otherNodes)
					{
						if (otherNodes[i] == myTarget)
						{
							otherNodes.splice(i, 1);
						}
					}
					
					//MAKE THIS INTO ANOTHER FUNCTION
					
					for (i in otherNodes)
					{
						if ((getDistance(myTarget.parent, otherNodes[i]) < linkRange) && (compareResources(otherNodes[i], Resource(myTarget))))
						{
							otherNodes[i].setMode("valid");
							otherNodes[i].linkable = true;
						}
					}
				}
			}
			else if (e.target is Node || (e.target.parent is Node && useIcons))
				//else if (e.target.parent is Node && useIcons) 
			{
				//var myTarget;
				//HACK
				//if(useIcons){
				myTarget = e.target.parent;
				//}else {
				//myTarget = e.target;
				//}
				
				if (reachOut)
				{ //If reaching out and you connect to a NODE
					if (linkAnchor is Resource)
					{
						if ((myTarget != linkAnchor.parent) && (myTarget.mode == "valid"))
						{
							//attemptLink(Node(myTarget), Node(linkAnchor.parent));
							//attemptLink(Node(myTarget), Node(linkAnchor.parent), linkAnchor._category);
							attemptLink(Node(linkAnchor.parent), Node(myTarget), linkAnchor._category);
						}
					}
					else if (linkAnchor is Unit)
					{
						//Clicking a destination
						if ((myTarget != linkAnchor.attachedTo) && (myTarget.mode == "valid") && myTarget.inputsNeeded == 0)
						{
							//makeUnitLink(Unit(linkAnchor), Node(myTarget));
							Unit(linkAnchor).setDestination(Node(myTarget));
							
							//this.removeEventListener(Event.ENTER_FRAME, drawTempLink);
							
							reachOut = false;
							linkAnchor.unEffect();
							updateTurn();
						}
						resetLink();
					}
				}
				else if ((myTarget.mode == "active") && (myTarget is Node))
				{
					myTarget.setMode("selected");
				}
			}
			else if (e.target.parent is Unit && Unit(e.target.parent).attachedTo.active)
			{
				if (Unit(e.target.parent).attachedTo.active)
				{
					linkAnchor = Unit(e.target.parent);
					//this.addEventListener(Event.ENTER_FRAME, drawTempLink);
					reachOut = true;
				}
				
				for (i in nodeArray)
				{
					if (nodeArray[i].unitAllowed == getClass(e.target.parent) && nodeArray[i].active)
					{
						nodeArray[i].setMode("valid");
						nodeArray[i].linkable = true;
					}
				}
			}
			else
			{
				resetLink();
			}
		}
		
		private function updateTurn()
		{
			turn++;
			
			updateUnits();
			checkUnits();
			
			for (var i in eventArray)
			{
				if (eventArray[i].objective)
				{
					eventArray[i].trigger--;
				}
			}
			
			updateEventTimers();
			checkEvents();
		}
		
		/**
		 * @GLEN Change so this works with pre-made links
		 *
		 * @param	n Staring node
		 * @param	t Target node
		 * @param   type -  Type of resource (only used for pre-made links)
		 *
		 *
		 */
		private function attemptLink(n:Node, t:Node, cat:String = "")
		{
			//var resourceCategory:String;
			
			//Sets resource type for link
			//if (type == "") { // Case = Links made by player
			//if (cat == "") { // Case = Links made by player
			//resourceCategory = linkAnchor._category;
			//}else { //Case = Pre-made links my level designer
			//resourceCategory = type;
			//}		
			
			if (!testLineOfSight(new Point(t.x, t.y), new Point(n.x, n.y)))
			{
				//Test linkAnchor against all 
				if (linkAnchor.allocated)
				{
					for (var i in links)
					{
						for (var j in links[i].origin.outputs)
						{
							if ((links[i].origin.id == n.id) && (links[i].origin.outputs[j].id == linkAnchor.id && 
							links[i].cat == linkAnchor._category))
							{
								
								linkLayer.removeChild(links[i].shape);
								links[i].target.removeOutput(links[i].origin);
								
								links[i].origin.setMode("default");
								
								links.splice(i, 1);
								linkBreak = true;
								
								break;
							}
						}
					}
				}
				
				//OVERLOAD CHECK
				//If the input of the corresponding resource category is already allocated
				//return true (overloaded)
				var breakCheck = t.addOutput(n, linkAnchor._category);
				var trackInstance:Array = new Array();
				
				//Locate the link that is pointed at the target with matching link category
				//splice this link
				
				//Locate another link that is pointing to the same target
				//If that link's type matches linkAnchor._category, splice from link array
				
				
				//if (breakCheck) {
					//trace("Break check detected!");
					//for (i in links) {
						//for (j in links[i].target.inputs) {
							//if (links[i].target.inputs[j].linkedTo != null) {
								//trace("LinkedTo for input " + j + " of " + links[i].target.id + " is not null");
								//if (links[i].target.inputs[j].linkedTo.link_cat == linkAnchor._category) {
								//if (links[i].target.inputs[j]._category == linkAnchor._category) {
									//trackInstance.push(i);
								//}
							//}
						//}
						//if (links[i].target.id == t.id) { //If the link's target is the same as current target
							//if (links[i].cat == linkAnchor._category) {
								//trackInstance.push(i);
								//trace("Instance of matching category found");
							//}
						//}
					//}
					//
					//if (trackInstance.length == 1) {
						//linkLayer.removeChild(links[trackInstance[0]].shape);
						//links.splice(i, 1);
					//}
					
					//			break;
					
						//for (j in links[i].target.inputs) {
							//if (links[i].target.inputs[j].linkedTo != null) {
								//if (links[i].target.inputs[j].linkedTo.link_cat == linkAnchor._category) {
									//
								//}
							//}
							//if (links[i].target.inputs[j].linkedTo.node.id == 
							//
						//}
						//FIX ME!!!!
						//if (links[i].target.id == t.id && links[i].cat == linkAnchor._category && !links[i].target.checkInputs()) {
							//linkLayer.removeChild(links[i].shape);
							//links.splice(i, 1);
							//resourceMatchCount++;
							//
							//break;
						//}
					//}
					//}
					//
					//if (resourceMatchCount == 1) {
						//
					//}
				//}
				
				//trace("BreackCheck parent " + Node(breakCheck.parent).id);
				
				//for (i in links) {
					//if (links[i].origin.id == breakCheck.parent.id) {
						//
					//}
				//}
				
				makeLink(t);
				checkResolved(t);
				
				linkAnchor.allocated = true;
				
				resetLink();
				updateTurn();
				
				checkLinks();
			}
		}
		
		//@GLEN FIX THIS!!!!
		
		//Activates or deactivates links based on if their are any breaks in their link chain
		private function checkLinks()
		{
			for (var i in links)
			{
				if (!links[i].origin.checkInputs() || links[i].origin.mode == "default")
				{
					links[i].active = false;
					links[i].target.setMode("default");
				}else {
					links[i].active = true;
					
					if (linkBreak && links[i].target.checkInputs()) {
						links[i].target.setMode("active");
						linkBreak = false;
					}
				}
			}
			
			for (i in links)
			{
				//Cleanup function
				if (!links[i].active)
				{
					links[i].shape.alpha = 0.5;
				}
				else
				{
					links[i].shape.alpha = 1;
				}
			}
			
			trace("**************");
		}
		
		private function linkTest(la:Array)
		{
		
		}
		
		private function updateUnits()
		{
			if (newMove)
			{
				var moveTarget:Node = null;
				var lowestDist:Number = 0;
				
				for (var i in unitArray)
				{
					moveTarget = null;
					lowestDist = 9000;
					var removeIndex:int = 0;
					
					if (unitArray[i].destination != null)
					{
						if (unitArray[i].testNodes.length == 0)
						{
							unitArray[i].testNodes = links.concat();
						}
						
						//Check nodes with links attached to this unit's linkedTo
						if (unitArray[i].attachedTo.id != unitArray[i].destinationNode.id)
						{
							for (var j in unitArray[i].testNodes)
							{
								if ((unitArray[i].testNodes[j].origin.id == unitArray[i].attachedTo.id) && (getDistance(unitArray[i].destinationNode, unitArray[i].testNodes[j].target) < lowestDist))
								{
									lowestDist = getDistance(unitArray[i].destinationNode, unitArray[i].testNodes[j].target);
									moveTarget = unitArray[i].testNodes[j].target;
									removeIndex = j;
								}
								else if ((unitArray[i].testNodes[j].target.id == unitArray[i].attachedTo.id) && (getDistance(unitArray[i].destinationNode, unitArray[i].testNodes[j].origin) < lowestDist))
								{
									lowestDist = getDistance(unitArray[i].destinationNode, unitArray[i].testNodes[j].origin);
									moveTarget = unitArray[i].testNodes[j].origin;
									removeIndex = j;
								}
							}
							
							if (moveTarget != null)
							{
								unitArray[i].x = moveTarget.x + unitArray[i].xAdj;
								unitArray[i].y = moveTarget.y + unitArray[i].yAdj;
								unitArray[i].attachedTo = moveTarget;
								
								unitArray[i].testNodes.splice(removeIndex, 1);
								
							}
						}
						
						if (unitArray[i].attachedTo.id == unitArray[i].destinationNode.id)
						{
							unitArray[i].destination = null;
							unitArray[i].effect();
							unitArray[i].testNodes = new Array();
						}
					}
				}
			}
			else
			{
				for (i in unitArray)
				{
					if (unitArray[i].destination != null)
					{
						//Unit reaches destination in one turn (HACK)
						//unitArray[i].x = unitArray[i].destination.x;
						//unitArray[i].y = unitArray[i].destination.y;
						//
						//var attachNode:Node = new Node();
						//
						//for (j in nodeArray) {
							//if (nodeArray[j].id == unitArray[i].destination) {
								//unitArray[i].attachedTo = nodeArray[j];	
							//}
						//}
						//
						//unitArray[i].attachedTo = unitArray[i].destination;
						//unitArray[i].effect();
						//unitArray[i].destination.unitAllowed = null;
						//unitArray[i].destination = null;
						
						
						if (getDistance(unitArray[i], unitArray[i].destination) > 0)
						{
							//Move towards target
							unitArray[i].x = approach(unitArray[i].x, unitArray[i].destination.x, unitArray[i].moveSpeed);
							unitArray[i].y = approach(unitArray[i].y, unitArray[i].destination.y, unitArray[i].moveSpeed);
						}
						
						if (getDistance(unitArray[i], unitArray[i].destination) == 0)
						{
							//Loop needed here because destination is a copy of nodeArray[j] and does not have
							//most up to date parameter values
							for (j in nodeArray)
							{
								if (nodeArray[j].unitAllowed != null)
								{
									if (unitArray[i] is getClass(nodeArray[j].unitAllowed))
									{
										if (unitArray[i].destinationNode == nodeArray[j])
										{
											unitArray[i].attachedTo = nodeArray[j];
											nodeArray[j].unitAllowed = null;
										}
									}
								}
								
								unitArray[i].destination = null;
								unitArray[i].effect();
								
									//for (i = 0; i < unitLinks.length; i++)
									//{
									//if (unitLinks[i].unit.id == unitArray[i].id)
									//{
									//linkLayer.removeChild(unitLinks[i].shape)
									//unitLinks.splice(i, 1);
									//break;
									//}
									//}
							}
						}
					}
				}
			}
		
			//redrawUnitLink(unitArray[i], unitArray[i].destinationNode);
		}
		
		private function checkUnits()
		{
			if (unitArray.length > 0)
			{
				for (var i in unitArray)
				{
					if (unitArray[i].attachedTo.mode == "active")
					{
						MovieClip(unitArray[i].getChildAt(0)).filters = [unitGlow];
						adjScore(500);
						
						if (unitArray[i] is ResearcherUnit) {
							researcherGainedSFX.play();
						}else if (unitArray[i] is WorkerUnit) {
							workerGainedSFX.play();
						}
					}
					else
					{
						MovieClip(unitArray[i].getChildAt(0)).filters = [];
					}
				}
			}
		}
		
		private function breakLink(r:Resource)
		{
			for (var i in links)
			{
				if (links[i].origin.id == Node(r.parent).id)
				{
					linkLayer.removeChild(links[i].shape);
					links[i].target.removeOutput(links[i].origin);
					
					links[i].origin.setMode("default");
					
					links.splice(i, 1);
					break;
				}
			}
		}
		
		private function breakLinkByID(s:String)
		{
			
			for (var i in links)
			{
				for (var j in links[i].target.inputs)
				{
					if (links[i].target.inputs[j].id == s)
					{
						linkLayer.removeChild(links[i].shape);
						links[i].target.removeOutput(links[i].origin);
						
						links[i].origin.setMode("default");
						
						links.splice(i, 1);
					}
				}
			}
		}
		
		private function checkEvents()
		{
			trace("REMINDER: Unable to resolve secondary events");
			
			for (var i in eventArray)
			{
				if (eventArray[i].trigger == 0)
				{
					eventArray[i].expire();
				}
				else if (eventArray[i].linkedTo.mode == "active" && eventArray[i].upgradeRequired == null && eventArray[i].linkedTo.inputsNeeded == 0)
				{
					eventArray[i].resolve();
					
					if (eventArray[i].objective) {
						trace("Playing PRIMARY objective sound!");
						primaryObjectiveSFX.play();
					}else {
						trace("Playing secondary objective sound!");
						secondaryObjectiveSFX.play();
					}
					
					//@GLEN FIX THIS LATER
					//iconLayer.removeChild(eventIconArray[i]);
					trace("REMINDER TO FIX REMOVE CHILD ISSUE (linkhandler checkEvents function");
				}
			}
		}
		
		private function compareResources(n:Node, r:Resource):Boolean
		{
			for (var i in n.inputs)
			{
				if (n.inputs[i]._category == r._category)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function resetLink()
		{
			
			for (var i in nodeArray)
			{
				nodeArray[i].checkInputs(true);
			}
			
			//this.removeEventListener(Event.ENTER_FRAME, drawTempLink);
			linkShape.graphics.clear();
			linkAnchor = null;
			reachOut = false;
		}
		
		//private function drawTempLink(e:Event)
		//{
		//linkShape.graphics.clear();
		//
		//linkShape.graphics.lineStyle(2, 0x000000, .75);
		//linkShape.graphics.moveTo(linkAnchor.x + linkAnchor.parent.x, linkAnchor.y + linkAnchor.parent.y);
		//linkShape.graphics.lineTo(stage.mouseX, stage.mouseY);
		//
		//linkLayer.addChild(linkShape);
		//}
		
		//private function makeLink(n:Node):Boolean
		private function makeLink(n:Node)
		{
			
			if (enableSFX)
			{
				//linkSFX_Channel = linkSFX.play();
				//linkSFX.play();
				Sound(getLinkSound(linkAnchor._category)).play();
			}
			
			linkShape.graphics.clear(); //Remove temporary link
			var tempShape = new Shape();
			
			tempShape.graphics.lineStyle(2, linkAnchor.color, 2);
			
			tempShape.graphics.moveTo(linkAnchor.parent.x, linkAnchor.parent.y);
			
			tempShape.graphics.moveTo(linkAnchor.parent.x, linkAnchor.parent.y);
			tempShape.graphics.lineTo(n.x, n.y);
			
			linkGlow.color = linkAnchor.color;
			tempShape.filters = [linkGlow];
			
			linkLayer.addChild(tempShape);
			
			//links.push( { shape: tempShape, origin: linkAnchor.parent, target: n, type: linkAnchor._type } );
			links.push({shape: tempShape, origin: linkAnchor.parent, target: n, cat: linkAnchor._category, active: true});
		}
		
		private function getLinkSound(c:String):Sound {
			switch(c) {
				case "red":
					return fuelSFX;
					break;
				case "yellow":
					//CHANGE TO ETHANOL LATER
					return powerSFX;
					break;
				case "blue":
					return powerSFX;
					break;
				case "orange":
					return oilSFX;
					break;
				case "gray":
					return coalSFX;
					break;
				case "purple":
					//CHANGE TO NUCLEAR LATER
					return coalSFX;
					break;
				case "green":
					//UPDATE LATER
					return linkSFX;
					//return moneySFX;
					break;
				case "brown":
					return wasteSFX;
					break;
				default:
					return linkSFX;
					break;
			}
		}
		
		//private function redrawUnitLink(u:Unit, n:Node) {
		//
		//for (var i in unitLinks) {				
		//if (unitLinks[i].id == u.id) {
		//linkLayer.removeChild(unitLinks[i].shape);		
		//unitLinks.splice(i, 1);
		//
		//if(unitArray[i].attachedTo.id != unitArray[i].destinationNode.id){
		//makeUnitLink(u, n);
		//}
		//}
		//}
		//}
		
		//private function makeUnitLink(u:Unit, n:Node)
		//{
		//linkShape.graphics.clear(); //Remove temporary link
		//var tempShape = new Shape();
		//
		//tempShape.graphics.lineStyle(2, 0xFFFFFF, 2);
		//tempShape.graphics.moveTo(u.x, u.y);
		//tempShape.graphics.lineTo(n.x, n.y);
		//
		//linkLayer.addChild(tempShape);
		//unitLinks.push({shape: tempShape, unit: u, id: u.id});
		//}
		
		private function getDistance(o1:Object, o2:Object)
		{
			return Math.sqrt((o2.x - o1.x) * (o2.x - o1.x) + (o2.y - o1.y) * (o2.y - o1.y));
		}
		
		public function replaceBuilding(bs:BuildingSite, id:String)
		{
			var newNode = new Node("blank");
			var index:int = 0;
			
			for (var i in buildingSiteDataArray)
			{
				if (buildingSiteDataArray[i].label == id)
				{
					index = i;
				}
			}
			
			for (var j in buildingSiteDataArray[index].obj.outputs)
			{
				newNode.outputs.push(new Resource(buildingSiteDataArray[index].obj.outputs[j]._category, "output"));
					//newNode.outputs.push(new Resource("buildingSiteDataArray[index].obj.id" + buildingSiteDataArray[index].obj.outputs[j]._category, "output"));
			}
			
			for (j in buildingSiteDataArray[index].obj.inputs)
			{
				newNode.inputs.push(new Resource(buildingSiteDataArray[index].obj.inputs[j]._category, "input"));
					//newNode.inputs.push(new Resource("buildingSiteDataArray[index].obj.id" + buildingSiteDataArray[index].obj.inputs[j]._category, "inputs"));
			}
			
			newNode.image = buildingSiteDataArray[index].obj.image;
			
			var bsIndex:int = buildingSiteArray.indexOf(bs);
			
			newNode.setUp();
			
			nodeArray.push(newNode);
			buildingLayer.addChild(nodeArray[nodeArray.length - 1]);
			
			newNode.x = bs.x;
			newNode.y = bs.y;
			
			buildingLayer.removeChild(buildingSiteArray[bsIndex]);
			buildingSiteArray.splice(bsIndex, 1);
			updateTurn();
		}
		
		public function adjScore(i:int)
		{
			score += i;
			scoreText.text = score.toString();
			scoreText.setTextFormat(scoreTextFormat);
		}
		
		public function checkResolved(n:Node)
		{
			for (var i in eventArray)
			{
				if (eventArray[i].linkedTo == n)
				{
					if (eventArray[i].upgradeRequired == "" && n.inputsNeeded == 0)
					{
						eventArray[i].resolve();
						
						if (eventArray[i].objective) {
							primaryObjectiveSFX.play();
						}else {
							trace("Playing secondary objective sound!");
							secondaryObjectiveSFX.play();
						}
						//iconLayer.removeChild(eventIconArray[i]);
						trace("REMINDER- Fix removing event icon issue. Checkresolved function of linkhandler");
					}
				}
			}
		}
		
		/** BORROWED FROM FLASHPUNK LIBRARIES
		 * Approaches the value towards the target, by the specified amount, without overshooting the target.
		 * @param	value	The starting value.
		 * @param	target	The target that you want value to approach.
		 * @param	amount	How much you want the value to approach target by.
		 * @return	The new value.
		 */
		public static function approach(value:Number, target:Number, amount:Number):Number
		{
			return value < target ? (target < value + amount ? target : value + amount) : (target > value - amount ? target : value - amount);
		}
		
		public function getClass(obj:Object):Class
		{
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
		public function levelFromXML()
		{
			var urlRequest:URLRequest = new URLRequest(fileName);
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			urlLoader.load(urlRequest);
		}
		
		function urlLoader_complete(evt:Event):void
		{
			xml = XML(urlLoader.data);
			
			for (var i in xml.building)
			{
				var className:Class;
				
				var tempNode:Node;
				if (String(xml.building[i].extra_output) != "")
				{
					tempNode = new Node(String(xml.building[i].id), new Resource(String(xml.building[i].extra_output), "extraOutput"));
					tempNode.unitAllowed = WorkerUnit;
				}
				else
				{
					tempNode = new Node("blank");
				}
				
				if (String(xml.building[i].image) != "")
				{
					tempNode.image = MovieClip(getImageClassByString(String(xml.building[i].image)));
				}
				
				for (var j in xml.building[i].input)
				{
					tempNode.inputs.push(new Resource(String(xml.building[i].input[j]), "input"));
				}
				
				for (j in xml.building[i].output)
				{
					tempNode.outputs.push(new Resource(String(xml.building[i].output[j]), "output"));
					//Used for premade links
					tempNode.basicOutputs.push(new Resource(String(xml.building[i].output[j]), "output"));
				}
				
				tempNode.id = String(xml.building[i].id)
				
				tempNode.setUp();
				nodeArray.push(tempNode);
				
				nodeArray[nodeIndex].gridX = xml.building[i].x;
				nodeArray[nodeIndex].gridY = xml.building[i].y;
				
				var tempPoint:Point = gridPosToTile(xml.building[i].x, xml.building[i].y);
				nodeArray[nodeIndex].x = tempPoint.x;
				nodeArray[nodeIndex].y = tempPoint.y;
				
				//Unit
				if (String(xml.building[i].unit) != "")
				{
					className = getDefinitionByName(String(xml.building[i].unit)) as Class;
					unitArray.push(new className(nodeArray[nodeIndex], this, unitIndex++));
				}
				
				if (String(xml.building[i].upgrade) != "")
				{
					upgradeArray.push(new Upgrade(nodeArray[nodeIndex], String(xml.building[i].upgrade), getUpgradeImage(upgradeArray.length)));
					//If a building has an upgrade attached to it, then make it so a Researcher can be on it
					nodeArray[nodeIndex].unitAllowed = ResearcherUnit;
				}
				
				if (String(xml.building[i].event.description) != "")
				{
					var upgradeID:String = new String();
					if (String(xml.building[i].event.upgrade) != "")
					{
						upgradeID = String(xml.building[i].event.upgrade);
					}
					else
					{
						upgradeID = "";
							//upgradeID = "test";
					}
					
					var linkedEvents:Array = new Array();
					
					for (j in xml.building[i].event.linked_event)
					{
						linkedEvents.push(xml.building[i].event.linked_event[j]);
					}
					
					var objectiveTrue:Boolean = false;
					//if (Boolean(xml.building[i].event.objective
					if ((String(xml.building[i].event.objective) == "true"))
					{
						objectiveTrue = true;
						objectives++;
					}
					
					//@GLEN - REMOVE SPAWNING!
					//var tempSpawn:Object;
					//if (String(xml.building[i].event.spawn) == "WorkerUnit")
					//{
					//Add an Object for "spawn"
					//Function to spawn WorkerUnit
					//tempSpawn = WorkerUnit;
					//}
					//else if (String(xml.building[i].event.spawn) == "ResearcherUnit")
					//{
					//Add an Object for "spawn"
					//Function to spawn ResearcherUnit
					//tempSpawn = ResearcherUnit;
					//}
					//else
					//{
					//Add an object for "spawn" property of selected building
					//Send nodeArray[nodeIndex}
					//tempSpawn = String(xml.building[i].event.spawn);
					//}
					
					//eventArray.push(new GameEvent(String(xml.building[i].event.description), int(xml.building[i].event.turns), nodeArray[nodeIndex], (String(xml.building[i].event.positive)=="true"), this, int(xml.building[i].event.points), upgradeID));
					//eventArray.push(new GameEvent(String(xml.building[i].event.description), int(xml.building[i].event.turns), nodeArray[nodeIndex], (String(xml.building[i].event.positive) == "true"), this, int(xml.building[i].event.points), linkedEvents, upgradeID));
					//eventArray.push(new GameEvent(String(xml.building[i].event.description), int(xml.building[i].event.turns), nodeArray[nodeIndex], (String(xml.building[i].event.positive) == "true"), this, int(xml.building[i].event.points), linkedEvents, objectiveTrue, tempSpawn, upgradeID));
					eventArray.push(new GameEvent(String(xml.building[i].event.description), int(xml.building[i].event.turns), nodeArray[nodeIndex], (String(xml.building[i].event.positive) == "true"), this, int(xml.building[i].event.points), linkedEvents, objectiveTrue, upgradeID));
				}
				
				nodeIndex++;
			}
			
			for (i in xml.barrier)
			{
				//Take a standard tile and modify its color
				var tempTile = new tile_mc();
				Shape(tempTile.tileFill_mc.getChildAt(0)).transform.colorTransform = new ColorTransform(2);
				var testTransform:ColorTransform = new ColorTransform();
				testTransform.color = 0x996633;
				tempTile.transform.colorTransform = testTransform;
				
				//Read x and y coordiantes from xml
				var placement = gridPosToTile(xml.barrier[i].x, xml.barrier[i].y);
				tempTile.x = placement.x;
				tempTile.y = placement.y;
				
				barrierArray.push(tempTile);
			}
			
			for (i in xml.link)
			{
				//xml.link[i].origin
				preLinks.push({origin: String(xml.link[i].origin), target: String(xml.link[i].target), type: String(xml.link[i].type)});
			}
			
			var tempArray:Array = new Array();
			
			if (xml.building_site != "")
			{
				for (i in xml.building_site_data.building)
				{
					if (String(xml.building_site_data.building[i].extra_output) != "")
					{
						tempNode = new Node(String(xml.building_site_data.building[i].id), new Resource(String(xml.building_site_data.building[i].extra_output), "extraOutput"));
					}
					else
					{
						tempNode = new Node("blank");
					}
					
					//Set up building image
					if (String(xml.building_site_data.building[i].image) != "")
					{
						//tempNode.image = MovieClip(getImageClassByString(String(xml.building[i].image)));
						tempNode.image = MovieClip(getImageClassByString(String(xml.building_site_data.building[i].image)));
						
					}
					
					//Set up building inputs
					for (var z in xml.building_site_data.building[i].input)
					{
						tempNode.inputs.push(new Resource(String(xml.building_site_data.building[i].input[z]), "input"));
					}
					
					//Set up building outputs
					for (z in xml.building_site_data.building[i].output)
					{
						tempNode.outputs.push(new Resource(String(xml.building_site_data.building[i].output[z]), "output"));
					}
					
					tempNode.setUp();
					buildingSiteDataArray.push({label: String(xml.building_site_data.building[i].label), obj: tempNode});
				}
				
				for (i in xml.building_site)
				{
					buildingSiteArray.push(new BuildingSite(buildingMenu));
					tempPoint = gridPosToTile(xml.building_site[i].x, xml.building_site[i].y);
					buildingSiteArray[i].x = tempPoint.x;
					buildingSiteArray[i].y = tempPoint.y;
				}
			}
			
			///Linked Event database			
			if (xml.linkedEvent_data != "")
			{
				for (i in xml.linkedEvent_data.event)
				{
					if (String(xml.linkedEvent_data.event[i].upgrade))
					{
						//upgradeID = String(xml.building[i].event.upgrade);
						upgradeID = String(xml.building[i].event[i].upgrade);
					}
					else
					{
						upgradeID = null;
					}
					
					var parentNode;
					
					for (j in nodeArray)
					{
						//if (nodeArray[j].id == String(xml.linkedEvent_data.event.targetNodeID))
						if (nodeArray[j].id == String(xml.linkedEvent_data.event[i].targetNodeID))
						{
							parentNode = nodeArray[j];
						}
					}
					
					linkedEvents = new Array();
					
					//for (j in xml.building[i].event.linked_event)
//					for (j in xml.building[i].event[i].linked_event)
					for (j in xml.linkedEvent_data.event[i].linked_event)
					{
						//linkedEvents.push(xml.building[i].event.linked_event[j]);
						linkedEvents.push(xml.linkedEvent_data.event[i].linked_event[j]);
					}
					
					//nodeArray[nodeIndex] becomes building via search for its corresponding ID					
					//linkedEventArray.push({obj: new GameEvent(String(xml.linkedEvent_data.event.description), int(xml.linkedEvent_data.event.turns), parentNode, (String(xml.linkedEvent_data.event.positive) == "true"), this, int(xml.linkedEvent_data.event.points), linkedEvents, upgradeID), id: String(xml.linkedEvent_data.event.id)});
					linkedEventArray.push({obj: new GameEvent(String(xml.linkedEvent_data.event[i].description), int(xml.linkedEvent_data.event[i].turns), parentNode, (String(xml.linkedEvent_data.event[i].positive) == "true"), this, int(xml.linkedEvent_data.event[i].points), linkedEvents, objectiveTrue, upgradeID), id: String(xml.linkedEvent_data.event[i].id)});
				}
			}
			
			if (String(xml.building_site_data) != "")
				if (String(xml.building_site_data.building[i].extra_output) != "")
				{
					if (String(xml.building_site_data.building[i].extra_output) != "")
					{
						tempNode = new Node(String(xml.building_site_databuilding[i].id), new Resource(String(xml.building_site_data.building[i].extra_output), "extraOutput"));
					}
					else
					{
						tempNode = new Node("blank");
					}
					
					for (z in xml.building_site_data.building[i].input)
					{
						tempNode.inputs.push(new Resource(String(xml.building_site_data.building[i].input[z]), "input"));
					}
					
					for (z in xml.building_site_data.building[i].output)
					{
						tempNode.outputs.push(new Resource(String(xml.building_site_data.building[i].output[z]), "output"));
					}
					
					//Adding image
					//tempNode.addChild(getImageClassByString(String(xml.building_site_data.building[i].image)));
					tempNode.image = new [getImageClassByString(String(xml.building_site_data.building[i].image))]();
					
					tempNode.setUp();
					buildingSiteDataArray.push({label: String(xml.building_site_data.building[i].label), obj: tempNode});
					
					for (i in xml.building_site)
					{
						buildingSiteArray.push(new BuildingSite(buildingMenu));
						tempPoint = gridPosToTile(xml.building_site[i].x, xml.building_site[i].y);
						buildingSiteArray[i].x = tempPoint.x;
						buildingSiteArray[i].y = tempPoint.y;
					}
				}
			
			levelSetup();
		}
		
		//@GLEN FIX THIS LATER
		public function getImageClassByString(s:String):MovieClip
		{
			switch (s)
			{
				case "OilDrill": 
					return new OilDrill();
				case "PowerPlant": 
					return new PowerPlant();
				case "Refinery": 
					return new Refinery();
				case "SolarFarm": 
					return new SolarFarm();
				case "WasteFacility": 
					return new WasteFacility();
				case "House": 
					return new House();
				
				case "HydroDam": 
					return new HydroDam();
				case "Mine": 
					return new Mine();
				case "NuclearPlant": 
					return new NuclearPlant();
				
				case "City": 
					return new City();
				case "CornFarm": 
					return new CornFarm();
				case "GasStation": 
					return new GasStation();
				
				default: 
					return new House();
			}
			
			return null;
		}
		
		public function activateLinkedEvent(id:String)
		{
			for (var i in linkedEventArray)
			{
				//alternative at: http://www.actionscript.org/forums/showthread.php3?t=196107
				if (linkedEventArray[i].id == id)
				{
					//Create new event
					eventArray.push(linkedEventArray[i].obj);
						//showEventTimers(); 
					
						//updateEventTimers(); 
				}
			}
		}
		
		public function resolveObjective()
		{
			objectives--;
						
			if (objectives == 0)
			{
				drawLevelEnd("YOU WIN!");
				
				trace("Playing PRIMARY objective sound! 2");
				primaryObjectiveSFX.play();
			}
		}
		
		public function expireObjective()
		{
			drawLevelEnd("YOU LOSE!");
		}
		
		//Test line of sight from one point to another
		private function testLineOfSight(p1:Point, p2:Point):Boolean
		{
			var testPoint = p1;
			
			while (getDistance(testPoint, p2) != 0)
			{
				testPoint.x = approach(testPoint.x, p2.x, 1);
				testPoint.y = approach(testPoint.y, p2.y, 1);
				
				for (var i in barrierArray)
				{
					if (barrierArray[i].hitTestPoint(testPoint.x, testPoint.y, false))
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		private function getUpgradeImage(index:int):MovieClip
		{
			switch (index)
			{
				case 0: 
					return new UpgradeBlue();
					break;
				case 1: 
					return new UpgradeGreen();
					break;
				case 2: 
					return new UpgradeOrange();
					break;
				case 3: 
					return new UpgradePink();
					break;
				case 4: 
					return new UpgradePurple();
					break;
				case 5: 
					return new UpgradeTeal();
					break;
				case 6: 
					return new UpgradeYellow();
					break;
				default: 
					return null;
					break;
			}
			
			return null;
		}
		
		private function generateTiles()
		{
			//Generate tiles via 2 dimensional array
			var tempTile; //Temporary variable to be added to tile array
			for (var i = 0; i < gridRows; i++)
			{
				tileArray[i] = new Array();
				
				for (var j = 0; j < gridColumns; j++)
				{
					tempTile = new tile_mc(); //New instance of tile
					//tempTile.x = j * tileSize * 1.5 + offsetX; //Set x coordinate
					tempTile.x = j * tileSize * 1.5 + offsetX; //Set x coordinate
					tempTile.y = (i * tileHeight) + (j % 2) * (tileHeight / 2) + offsetY; //Set Y coordinate
					tileArray[i].push(tempTile); //Add element to array
					tileArray[i][j].name = i + "," + j; //Name array element (for debugging/tracking)
				}
			}
		}
		
		private function gridPosToTile(xPos:int, yPos:int):Point
		{
			//To simplify
			xPos -= 1;
			yPos -= 1;
			
			return new Point(xPos * tileSize * 1.5 + offsetX, (yPos * tileHeight) + (xPos % 2) * (tileHeight / 2) + offsetY);
		}
	
		//private function arrayContainsNode(a:Array, s:String):Boolean {
		//for (var i in a) {
		//if (a[i] == s) {
		//return true;
		//}
		//}
		//
		//return false;
		//}
	}
}