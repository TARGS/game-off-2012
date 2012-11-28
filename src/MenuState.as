package
{
	import org.flixel.*;
	import org.flixel.FlxState;
	import org.flixel.plugin.photonstorm.*;
	
	public class MenuState extends FlxState
	{
		public var playButton:FlxButton;
		public var background:FlxSprite;
		
		[Embed(source="data/Menu/background.png")] protected var MenuBackground:Class;
		
		[Embed(source="data/Menu/fightBoss.png")] protected var BossFightButton:Class;
		[Embed(source="data/Menu/inprogress.png")] protected var InProgressButton:Class;
		
		[Embed(source="data/Menu/stage_japan.png")] protected var JapanButton:Class;
		[Embed(source="data/Menu/stage_canada.png")] protected var CanadaButton:Class;
		[Embed(source="data/Menu/stage_germany.png")] protected var GermanyButton:Class;
		[Embed(source="data/Menu/stage_russia.png")] protected var RussiaButton:Class;
		[Embed(source="data/Menu/stage_usa.png")] protected var USAButton:Class;
		
		public var canadaButton:FlxExtendedSprite;
		public var russiaButton:FlxExtendedSprite;
		public var japanButton:FlxExtendedSprite;
		public var usaButton:FlxExtendedSprite;
		public var germanyButton:FlxExtendedSprite
		
		override public function create():void 
		{
			if (FlxG.getPlugin(FlxMouseControl) == null)
			{
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			// Set the background colour to light grey
			FlxG.bgColor = 0xffeeeeee;
			
			background = new FlxSprite(0, 0);
			background.loadGraphic(MenuBackground, false, false, 360, 240);
			add(background);
			
			FlxG.mouse.show();
			
			canadaButton = new FlxExtendedSprite(7, 47);
			canadaButton.loadGraphic(CanadaButton, false, false);
			canadaButton.enableMouseClicks(false);
			canadaButton.mouseReleasedCallback = canadaButtonPress;
			add(canadaButton);
			
			russiaButton = new FlxExtendedSprite(7, 120);
			russiaButton.loadGraphic(RussiaButton, false, false);
			russiaButton.enableMouseClicks(false);
			//russiaButton.mouseReleasedCallback = russiaButtonPress;
			add(russiaButton);
			
			japanButton = new FlxExtendedSprite(289, 15);
			japanButton.loadGraphic(JapanButton, false, false);
			japanButton.enableMouseClicks(false);
			japanButton.mouseReleasedCallback = japanButtonPress;
			add(japanButton);
			
			usaButton = new FlxExtendedSprite(289, 88);
			usaButton.loadGraphic(USAButton, false, false);
			usaButton.enableMouseClicks(false);
			//usaButton.mouseReleasedCallback = usaButtonPress;
			add(usaButton);
			
			germanyButton = new FlxExtendedSprite(289, 162);
			germanyButton.loadGraphic(GermanyButton, false, false);
			germanyButton.enableMouseClicks(false);
			//germanyButton.mouseReleasedCallback = germanyButtonPress;
			add(germanyButton);
		}
		
		private function canadaButtonPress(obj:FlxExtendedSprite, x:int, y:int):void
		{
			FlxG.level = 0;
			FlxG.fade(0xff131c1b,1,onFade);
		}
		
		private function russiaButtonPress(obj:FlxExtendedSprite, x:int, y:int):void
		{
			FlxG.level = 1;
			FlxG.fade(0xff131c1b,1,onFade);
		}
		
		private function japanButtonPress(obj:FlxExtendedSprite, x:int, y:int):void
		{
			FlxG.level = 2;
			FlxG.fade(0xff131c1b,1,onFade);
		}
		
		private function usaButtonPress(obj:FlxExtendedSprite, x:int, y:int):void
		{
			FlxG.level = 3;
			FlxG.fade(0xff131c1b,1,onFade);
		}
		
		private function germanyButtonPress(obj:FlxExtendedSprite, x:int, y:int):void
		{
			FlxG.level = 4;
			FlxG.fade(0xff131c1b,1,onFade);
		}
		
		protected function onFade():void
		{
			FlxG.switchState(new PlayState());
		}

		
		public function MenuState()
		{
			super();
		}
	}
}