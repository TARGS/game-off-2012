package
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PlayState extends FlxState
	{
		public var background:FlxSprite;
		public var board:FlxSprite;
		public var floor:FlxTileblock;
		public var piece:FlxExtendedSprite;
		public var pieces:FlxGroup;
		public var piecesArray:Array;
		
		[Embed(source="data/background.png")] protected var ImgBackground:Class;
		
		// Sprites for Game Pieces
		[Embed(source="data/carrot.png")] protected var ImgCarrot:Class;
		[Embed(source="data/eggplant.png")] protected var ImgEggplant:Class;
		[Embed(source="data/melon.png")] protected var ImgMelon:Class;
		[Embed(source="data/mushroom.png")] protected var ImgMushroom:Class;
		[Embed(source="data/onion.png")] protected var ImgOnion:Class;
		[Embed(source="data/pineapple.png")] protected var ImgPineapple:Class;
		
		protected var isSelected:uint = 0;
		protected var firstPiece:FlxExtendedSprite;
		protected var secondPiece:FlxExtendedSprite;
		
		override public function create():void
		{
			if (FlxG.getPlugin(FlxMouseControl) == null)
			{
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			// Set the background colour to light grey
			FlxG.bgColor = 0xffeeeeee;
			
			background = new FlxSprite(0, 0);
			background.loadGraphic(ImgBackground, false, false, 360, 240);
			add(background);
			
			FlxG.mouse.show();
			
			board = new FlxSprite(110, 50);
			board.makeGraphic(125, 175, 0xffaaaaaa);
			add(board);
			
			floor = new FlxTileblock(110,board.y+board.height, 125, 10);
			floor.makeGraphic(125, 10, 0xff000000);
			add(floor);
			
			pieces = new FlxGroup();
			piecesArray = new Array(new Array(new Array()), new Array(new Array()), new Array(new Array()), new Array(new Array()), new Array(new Array()));
			
			// First Row
			createPiece(0, 0);
			createPiece(1, 0);
			createPiece(2, 0);
			createPiece(3, 0);
			createPiece(4, 0);
			
			// Second Row
			createPiece(0, 1);
			createPiece(1, 1);
			createPiece(2, 1);
			createPiece(3, 1);
			createPiece(4, 1);
			
			// Third Row
			createPiece(0, 2);
			createPiece(1, 2);
			createPiece(2, 2);
			createPiece(3, 2);
			createPiece(4, 2);
			
			// Fourth Row
			createPiece(0, 3);
			createPiece(1, 3);
			createPiece(2, 3);
			createPiece(3, 3);
			createPiece(4, 3);
			
			// Fifth Row
			createPiece(0, 4);
			createPiece(1, 4);
			createPiece(2, 4);
			createPiece(3, 4);
			createPiece(4, 4);
			
			// Sixth Row
			createPiece(0, 5);
			createPiece(1, 5);
			createPiece(2, 5);
			createPiece(3, 5);
			createPiece(4, 5);
			
			// Seventh Row
			createPiece(0, 6);
			createPiece(1, 6);
			createPiece(2, 6);
			createPiece(3, 6);
			createPiece(4, 6);
			
			add(pieces);
		}
		
		// Creates a piece inside a specified grid position (X, Y)
		public function createPiece(X:uint,Y:uint):void
		{
			// An array of colours to choose from when generating a gamepiece
			// Temporary until I can get sprites to work with
			var color:Array = new Array(ImgCarrot, ImgEggplant, ImgMelon, ImgMushroom, ImgOnion, ImgPineapple);
			
			// NOTE FOR JON: Find a way to randomize this but also check that it doesn't form a match-3 on start
			piece = new FlxExtendedSprite(X*25+110, Y*25+50);
			piece.height = 25;
			piece.width = 25;
			var graphic:int = Math.floor(Math.random() * color.length);
			piece.loadGraphic(color[graphic], false, false);
			//piece.makeGraphic(25, 25, color[Math.floor(Math.random() * color.length)]);
			piece.enableMouseClicks(false);
			piece.mouseReleasedCallback = pieceClicked;
			//piece.acceleration.y = 20;
			piece.solid = true;
			pieces.add(piece);
			//piecesArray.push([[X, Y], graphic, piece]);
			piecesArray[X][Y] = piece;
			//FlxG.log("Successfully added piece at (" + X + ", " + Y + "): " + piecesArray[X][Y]);
		}
		
		private function pieceClicked(obj:FlxExtendedSprite, x:int, y:int):void
		{
			// Callback for a game piece being clicked, will be used to evaluate moves
			
			if (isSelected == 1) {
				// Clears the isSelected variable, in case the move was invalid or another move can be done
				isSelected = 0;
				
				secondPiece = obj;
				
				var firstPieceX:int;
				var firstPieceY:int;
				var secondPieceX:int;
				var secondPieceY:int;
				var _tempSprite:FlxExtendedSprite;
				
				// Figures out the grid coordinates for the first piece, using the numbers used to position the piece in the first place
				firstPieceX = (firstPiece.x - 110)/25;
				firstPieceY = (firstPiece.y - 50)/25;
				
				// Figures out the grid coordinates for the second piece, using the numbers used to position the piece in the first place
				secondPieceX = (secondPiece.x - 110)/25;
				secondPieceY = (secondPiece.y - 50)/25;
				
				if (
					((firstPieceX - secondPieceX) == 1 || -1 && (firstPieceY - secondPieceY) == 0) ||
					((firstPieceX - secondPieceX) == 0 && (firstPieceY - secondPieceY) == 1 || -1)
					)
				{	
					_tempSprite = piecesArray[secondPieceX][secondPieceY];
					piecesArray[secondPieceX][secondPieceY] = piecesArray[firstPieceX][firstPieceY];
					piecesArray[firstPieceX][firstPieceY] = _tempSprite;
					
					TweenLite.to(firstPiece, 0.5, {x: secondPiece.x, y: secondPiece.y, ease:Bounce.easeOut});
					TweenLite.to(secondPiece, 0.5, {x: firstPiece.x, y: firstPiece.y, ease:Bounce.easeOut});
					
					//matchingCheck();
				}
				
			} else {
				// Signals that a piece has been selected, and sets 'firstPiece' as that object
				isSelected = 1;
				firstPiece = obj;
			}
		}
		
		public function matchingCheck():void
		{
			checkRows();
			checkColumns();
		}
		
		// Steps through each and every single row, checking for possible match-3 conditions
		// Currently only iterates through match-3 scenarios, will build match-4 and match-5 conditions soon
		private function checkRows():void
		{
			var rowNum:int;
			for (rowNum = 0; rowNum <= 30; rowNum+=5) {
				var pieceGraphic:int;
				for (pieceGraphic = 0; pieceGraphic <= 5; pieceGraphic++) {
					if (piecesArray[rowNum][1] == pieceGraphic && piecesArray[rowNum+1][1] == pieceGraphic && piecesArray[rowNum+2][1] == pieceGraphic) {
						//FlxG.log("Yay! Matching pieces on row " + rowNum + ", on piecesArray: " + rowNum + ", " + (rowNum+1) + ", " + (rowNum+2) + " with graphic: " + pieceGraphic);
						//FlxG.log("Match! Kill: " + rowNum + ", " + (rowNum+1) + ", " + (rowNum+2));
						//FlxG.log("Pieces:" + piecesArray[rowNum][1] + ", " + piecesArray[rowNum+1][1] + ", " + piecesArray[rowNum+2][1]);
						
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[rowNum][2]);
						pieces.remove(piecesArray[rowNum+1][2]);
						pieces.remove(piecesArray[rowNum+2][2]);
						piecesArray[rowNum][2].destroy();
						piecesArray[rowNum+1][2].destroy();
						piecesArray[rowNum+2][2].destroy();
					}
					else if (piecesArray[rowNum+1][1] == pieceGraphic && piecesArray[rowNum+2][1] == pieceGraphic && piecesArray[rowNum+3][1] == pieceGraphic) {
						//FlxG.log("Yay! Matching pieces on row " + rowNum + ", on piecesArray: " + (rowNum+1) + ", " + (rowNum+2) + ", " + (rowNum+3) + " with graphic: " + pieceGraphic);
						//FlxG.log("Match! Kill: " + (rowNum+1) + ", " + (rowNum+2) + ", " + (rowNum+3));
						//FlxG.log("Pieces:" + piecesArray[rowNum+1][1] + ", " + piecesArray[rowNum+2][1] + ", " + piecesArray[rowNum+3][1]);
						
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[rowNum+1][2]);
						pieces.remove(piecesArray[rowNum+2][2]);
						pieces.remove(piecesArray[rowNum+3][2]);
						piecesArray[rowNum+1][2].destroy();
						piecesArray[rowNum+2][2].destroy();
						piecesArray[rowNum+3][2].destroy();
					}
					else if (piecesArray[rowNum+2][1] == pieceGraphic && piecesArray[rowNum+3][1] == pieceGraphic && piecesArray[rowNum+4][1] == pieceGraphic) {
						//FlxG.log("Yay! Matching pieces on row " + rowNum + ", on piecesArray: " + (rowNum+2) + ", " + (rowNum+3) + ", " + (rowNum+4) + " with graphic: " + pieceGraphic);
						//FlxG.log("Match! Kill: " + (rowNum+2) + ", " + (rowNum+3) + ", " + (rowNum+4));
						//FlxG.log("Pieces:" + piecesArray[rowNum+2][1] + ", " + piecesArray[rowNum+3][1] + ", " + piecesArray[rowNum+4][1]);
						
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[rowNum+2][2]);
						pieces.remove(piecesArray[rowNum+3][2]);
						pieces.remove(piecesArray[rowNum+4][2]);
						piecesArray[rowNum+2][2].destroy();
						piecesArray[rowNum+3][2].destroy();
						piecesArray[rowNum+4][2].destroy();
					}
				}
			}
		}
		
		// Steps through each and every single column, checking for possible match-3 conditions
		// Currently only iterates through match-3 scenarios, will build match-4 to match-7 conditions soon
		private function checkColumns():void
		{
			var colNum:int;
			for (colNum = 0; colNum <= 4; colNum++) {
				var pieceGraphic:int;
				for (pieceGraphic = 0; pieceGraphic <= 5; pieceGraphic++) {
					if (piecesArray[colNum][1] == pieceGraphic && piecesArray[colNum+5][1] == pieceGraphic && piecesArray[colNum+10][1] == pieceGraphic) {
						//FlxG.log("Yay! Matching pieces on column " + colNum + ", on piecesArray: " + colNum + ", " + (colNum+5) + ", " + (colNum+10) + " with graphic: " + pieceGraphic);
						
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum][2]);
						pieces.remove(piecesArray[colNum+5][2]);
						pieces.remove(piecesArray[colNum+10][2]);
						piecesArray[colNum][2].destroy();
						piecesArray[colNum+5][2].destroy();
						piecesArray[colNum+10][2].destroy();
					}
					else if (piecesArray[colNum+5][1] == pieceGraphic && piecesArray[colNum+10][1] == pieceGraphic && piecesArray[colNum+15][1] == pieceGraphic) {
						//FlxG.log("Yay! Matching pieces on column " + colNum + ", on piecesArray: " + (colNum+5) + ", " + (colNum+10) + ", " + (colNum+15) + " with graphic: " + pieceGraphic);
						
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum+5][2]);
						pieces.remove(piecesArray[colNum+10][2]);
						pieces.remove(piecesArray[colNum+15][2]);
						piecesArray[colNum+5][2].destroy();
						piecesArray[colNum+10][2].destroy();
						piecesArray[colNum+15][2].destroy();
					}
					else if (piecesArray[colNum+10][1] == pieceGraphic && piecesArray[colNum+15][1] == pieceGraphic && piecesArray[colNum+20][1] == pieceGraphic) {
						//FlxG.log("Yay! Matching pieces on column " + colNum + ", on piecesArray: " + (colNum+10) + ", " + (colNum+15) + ", " + (colNum+20) + " with graphic: " + pieceGraphic);
						
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum+10][2]);
						pieces.remove(piecesArray[colNum+15][2]);
						pieces.remove(piecesArray[colNum+20][2]);
						piecesArray[colNum+10][2].destroy();
						piecesArray[colNum+15][2].destroy();
						piecesArray[colNum+20][2].destroy();
					}
					else if (piecesArray[colNum+15][1] == pieceGraphic && piecesArray[colNum+20][1] == pieceGraphic && piecesArray[colNum+25][1] == pieceGraphic) {
						//FlxG.log("Yay! Matching pieces on column " + colNum + ", on piecesArray: " + (colNum+15) + ", " + (colNum+20) + ", " + (colNum+25) + " with graphic: " + pieceGraphic);
						
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum+15][2]);
						pieces.remove(piecesArray[colNum+20][2]);
						pieces.remove(piecesArray[colNum+25][2]);
						piecesArray[colNum+15][2].destroy();
						piecesArray[colNum+20][2].destroy();
						piecesArray[colNum+25][2].destroy();
					}
					else if (piecesArray[colNum+20][1] == pieceGraphic && piecesArray[colNum+25][1] == pieceGraphic && piecesArray[colNum+30][1] == pieceGraphic) {
						//FlxG.log("Yay! Matching pieces on column " + colNum + ", on piecesArray: " + (colNum+20) + ", " + (colNum+25) + ", " + (colNum+30) + " with graphic: " + pieceGraphic);
						
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum+20][2]);
						pieces.remove(piecesArray[colNum+25][2]);
						pieces.remove(piecesArray[colNum+30][2]);
						piecesArray[colNum+20][2].destroy();
						piecesArray[colNum+25][2].destroy();
						piecesArray[colNum+30][2].destroy();
					}
				}
			}
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(pieces, floor);
			FlxG.collide(pieces, pieces);
			
			//FlxG.log(piecesArray[22]);
		}
	}
}