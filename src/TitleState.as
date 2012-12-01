package
{
	import org.flixel.*;
	import org.flixel.FlxState;
	import org.flixel.plugin.photonstorm.*;
	
	public class TitleState extends FlxState
	{
		public var background:FlxSprite;
		public var startButton:FlxExtendedSprite;
		
		[Embed(source="data/Title/title.png")] protected var TitleBackground:Class;
		[Embed(source="data/Title/start_button.png")] protected var StartButton:Class;
		
		override public function create():void 
		{
			if (FlxG.getPlugin(FlxMouseControl) == null)
			{
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			// Set the background colour to light grey
			FlxG.bgColor = 0xffeeeeee;
			
			background = new FlxSprite(0, 0);
			background.loadGraphic(TitleBackground, false, false, 360, 240);
			add(background);
			
			FlxG.mouse.show();
			
			startButton = new FlxExtendedSprite(135, 130);
			startButton.loadGraphic(StartButton, false, false);
			startButton.enableMouseClicks(false);
			startButton.mouseReleasedCallback = startButtonPress;
			add(startButton);
		}
		
		private function startButtonPress(obj:FlxExtendedSprite, x:int, y:int):void
		{
			FlxG.fade(0xff131c1b,1,onFade);
		}
		
		protected function onFade():void
		{
			FlxG.switchState(new MenuState());
		}

		
		public function TitleState()
		{
			super();
		}
	}
}