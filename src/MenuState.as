package
{
	import org.flixel.*;
	import org.flixel.FlxState;
	
	public class MenuState extends FlxState
	{
		public var playButton:FlxButton;
		public var background:FlxSprite;
		
		[Embed(source="data/stageselect01.png")] protected var MenuBackground:Class;
		
		public var japanButton:FlxButton;
		public var canadaButton:FlxButton;
		
		override public function create():void 
		{
			// Set the background colour to light grey
			FlxG.bgColor = 0xffeeeeee;
			
			background = new FlxSprite(0, 0);
			background.loadGraphic(MenuBackground, false, false, 360, 240);
			add(background);
			
			FlxG.mouse.show();
			
			japanButton = new FlxButton(280, 62, "JAPAN", japanButtonPress);
			japanButton.color = 0xff0000000;
			japanButton.label.color = 0xffffffff;
			add(japanButton);
			
			canadaButton = new FlxButton(0, 93, "CANADA", canadaButtonPress);
			canadaButton.color = 0xff0000000;
			canadaButton.label.color = 0xffffffff;
			add(canadaButton);
		}
		
		protected function japanButtonPress():void
		{
			FlxG.level = 0;
			FlxG.fade(0xff131c1b,1,onFade);
		}
		
		protected function canadaButtonPress():void
		{
			FlxG.level = 1;
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