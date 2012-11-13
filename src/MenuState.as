package
{
	import org.flixel.*;
	import org.flixel.FlxState;
	
	public class MenuState extends FlxState
	{
		public var title1:FlxText;
		public var title2:FlxText;
		public var playButton:FlxButton;
		
		public var japanButton:FlxButton;
		public var canadaButton:FlxButton;
		
		override public function create():void 
		{
			// Set the background colour to light grey
			FlxG.bgColor = 0xffeeeeee;
			
			FlxG.mouse.show();
			
			//the letters "mo"
			title1 = new FlxText(FlxG.width/4,FlxG.height/3-70,180,"Match 3 Game, Thingy");
			title1.size = 32;
			title1.color = 0x3a5c39;
			title1.antialiasing = true;
			add(title1);
			
			japanButton = new FlxButton(10, FlxG.height/3 + 82, "JAPAN", japanButtonPress);
			japanButton.color = 0xff729954;
			japanButton.label.color = 0xffd8eba2;
			add(japanButton);
			
			canadaButton = new FlxButton(100, FlxG.height/3 + 82, "CANADA", canadaButtonPress);
			canadaButton.color = 0xff729954;
			canadaButton.label.color = 0xffd8eba2;
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