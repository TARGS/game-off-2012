package
{
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;
	
	public class Piece extends FlxExtendedSprite
	{
		public var _graphic:int;
		
		[Embed(source="data/background.png")] protected var ImgBackground:Class;
		
		// Sprites for Game Pieces
		[Embed(source="data/carrot.png")] protected var ImgCarrot:Class;
		[Embed(source="data/eggplant.png")] protected var ImgEggplant:Class;
		[Embed(source="data/melon.png")] protected var ImgMelon:Class;
		[Embed(source="data/mushroom.png")] protected var ImgMushroom:Class;
		[Embed(source="data/onion.png")] protected var ImgOnion:Class;
		[Embed(source="data/pineapple.png")] protected var ImgPineapple:Class;
		[Embed(source="data/cog_base_25px.png")] protected var ImgCog:Class;
		[Embed(source="data/flask_base_25px.png")] protected var ImgFlask:Class;
		[Embed(source="data/chip_base_25px.png")] protected var ImgChip:Class;
		
		public function Piece(X:Number=0, Y:Number=0, graphic:int=0)
		{
			super(X, Y);
			
			// An array of colours to choose from when generating a gamepiece
			// Temporary until I can get sprites to work with
			var color:Array = new Array(ImgCarrot, ImgEggplant, ImgMelon, ImgChip, ImgCog, ImgFlask);
			
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