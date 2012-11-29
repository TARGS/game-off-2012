package
{
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;
	
	public class Piece extends FlxExtendedSprite
	{
		public var _graphic:int;
		
		// Sprites for Game Pieces
		[Embed(source="data/Pieces/puzpiece_battery_25px.png")] protected var ImgBattery:Class;
		[Embed(source="data/Pieces/puzpiece_chip_25px.png")] protected var ImgChip:Class;
		[Embed(source="data/Pieces/puzpiece_mathbook_25px.png")] protected var ImgMathbook:Class;
		[Embed(source="data/Pieces/puzpiece_cog_25px.png")] protected var ImgCog:Class;
		[Embed(source="data/Pieces/puzpiece_flask_25px.png")] protected var ImgFlask:Class;
		
		public function Piece(X:Number=0, Y:Number=0, graphic:int=0)
		{
			super(X, Y);
			
			// An array of colours to choose from when generating a gamepiece
			// Temporary until I can get sprites to work with
			var color:Array = new Array(ImgBattery, ImgChip, ImgMathbook, ImgCog, ImgFlask);
			
			height = 25;
			width = 25;
			loadGraphic(color[graphic], false, false);
			solid = true;
			setSprite(graphic);
		}
		
		public function setSprite(graphic:int):void {
			_graphic = graphic;
		}
		
		public function get sprite():int {
			return _graphic;
		}
	}
}