package
{
	import org.flixel.*;
	[SWF(width="720", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class Match3 extends FlxGame
	{
		public function Match3()
		{
			super(360, 240, MenuState, 2);
			forceDebugger = true;
		}
	}
}