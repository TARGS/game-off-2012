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
		public var piece:Piece;
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
		public function createPiece(X:uint,Y:uint, heightOffset:uint=0):void
		{
			// NOTE FOR JON: Find a way to randomize this but also check that it doesn't form a match-3 on start
			piece = new Piece(X*25+110, Y*25+50-heightOffset);
			piece.enableMouseClicks(false);
			piece.mouseReleasedCallback = pieceClicked;
			pieces.add(piece);
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
					(((firstPieceX - secondPieceX) == 1 || -1) && (firstPieceY - secondPieceY) == 0) ||
					((firstPieceX - secondPieceX) == 0 && ((firstPieceY - secondPieceY) == 1 || -1))
					)
				{	
					TweenLite.to(firstPiece, 0.5, {x: secondPiece.x, y: secondPiece.y, ease:Bounce.easeOut});
					TweenLite.to(secondPiece, 0.5, {x: firstPiece.x, y: firstPiece.y, ease:Bounce.easeOut, onComplete:matchingCheck});
					
					_tempSprite = piecesArray[secondPieceX][secondPieceY];
					piecesArray[secondPieceX][secondPieceY] = piecesArray[firstPieceX][firstPieceY];
					piecesArray[firstPieceX][firstPieceY] = _tempSprite;
					//FlxG.log("Switching piecesArray[" + firstPieceX + "][" + firstPieceY + "] and piecesArray[" + secondPieceX + "][" + secondPieceY + "]");
					
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
			for (rowNum = 0; rowNum <= 6; rowNum++) {
				var pieceGraphic:int;
				for (pieceGraphic = 0; pieceGraphic <= 5; pieceGraphic++) {
					if (piecesArray[0][rowNum].sprite == pieceGraphic && piecesArray[1][rowNum].sprite == pieceGraphic && piecesArray[2][rowNum].sprite == pieceGraphic) {
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[0][rowNum]);
						pieces.remove(piecesArray[1][rowNum]);
						pieces.remove(piecesArray[2][rowNum]);
						piecesArray[0][rowNum].destroy();
						piecesArray[1][rowNum].destroy();
						piecesArray[2][rowNum].destroy();
						rowClear(0, rowNum);
					}
					else if (piecesArray[1][rowNum].sprite == pieceGraphic && piecesArray[2][rowNum].sprite == pieceGraphic && piecesArray[3][rowNum].sprite == pieceGraphic) {
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[1][rowNum]);
						pieces.remove(piecesArray[2][rowNum]);
						pieces.remove(piecesArray[3][rowNum]);
						piecesArray[1][rowNum].destroy();
						piecesArray[2][rowNum].destroy();
						piecesArray[3][rowNum].destroy();
						rowClear(1, rowNum);
					}
					else if (piecesArray[2][rowNum].sprite == pieceGraphic && piecesArray[3][rowNum].sprite == pieceGraphic && piecesArray[4][rowNum].sprite == pieceGraphic) {
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[2][rowNum]);
						pieces.remove(piecesArray[3][rowNum]);
						pieces.remove(piecesArray[4][rowNum]);
						piecesArray[2][rowNum].destroy();
						piecesArray[3][rowNum].destroy();
						piecesArray[4][rowNum].destroy();
						rowClear(2, rowNum);
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
					if (piecesArray[colNum][0].sprite == pieceGraphic && piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic) {
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum][0]);
						pieces.remove(piecesArray[colNum][1]);
						pieces.remove(piecesArray[colNum][2]);
						piecesArray[colNum][0].destroy();
						piecesArray[colNum][1].destroy();
						piecesArray[colNum][2].destroy();
						colClear(colNum, 2);
					}
					else if (piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic) {
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum][1]);
						pieces.remove(piecesArray[colNum][2]);
						pieces.remove(piecesArray[colNum][3]);
						piecesArray[colNum][1].destroy();
						piecesArray[colNum][2].destroy();
						piecesArray[colNum][3].destroy();
						colClear(colNum, 3);
					}
					else if (piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic) {
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum][2]);
						pieces.remove(piecesArray[colNum][3]);
						pieces.remove(piecesArray[colNum][4]);
						piecesArray[colNum][2].destroy();
						piecesArray[colNum][3].destroy();
						piecesArray[colNum][4].destroy();
						colClear(colNum, 4);
					}
					else if (piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic) {
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum][3]);
						pieces.remove(piecesArray[colNum][4]);
						pieces.remove(piecesArray[colNum][5]);
						piecesArray[colNum][3].destroy();
						piecesArray[colNum][4].destroy();
						piecesArray[colNum][5].destroy();
						colClear(colNum, 5);
					}
					else if (piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic && piecesArray[colNum][6].sprite == pieceGraphic) {
						// Removes the pieces from the FlxGroup so that removing them doesn't destroy everything
						pieces.remove(piecesArray[colNum][4]);
						pieces.remove(piecesArray[colNum][5]);
						pieces.remove(piecesArray[colNum][6]);
						piecesArray[colNum][4].destroy();
						piecesArray[colNum][5].destroy();
						piecesArray[colNum][6].destroy();
						colClear(colNum, 6);
					}
				}
			}
		}
		
		private function rowClear(startCol:int, rowNum:int):void 
		{
			for (var aboveRows:int = rowNum-1; aboveRows >= 0; aboveRows--) {
				TweenLite.to(piecesArray[startCol][aboveRows], 0.5, {x: piecesArray[startCol][aboveRows].x, y: piecesArray[startCol][aboveRows].y+25, ease:Bounce.easeOut});
				TweenLite.to(piecesArray[startCol+1][aboveRows], 0.5, {x: piecesArray[startCol+1][aboveRows].x, y: piecesArray[startCol+1][aboveRows].y+25, ease:Bounce.easeOut});
				TweenLite.to(piecesArray[startCol+2][aboveRows], 0.5, {x: piecesArray[startCol+2][aboveRows].x, y: piecesArray[startCol+2][aboveRows].y+25, ease:Bounce.easeOut});
				piecesArray[startCol][aboveRows+1] = piecesArray[startCol][aboveRows];
				piecesArray[startCol+1][aboveRows+1] = piecesArray[startCol+1][aboveRows];
				piecesArray[startCol+2][aboveRows+1] = piecesArray[startCol+2][aboveRows];
			}
			createPiece(startCol, 0, 25);
			createPiece(startCol+1, 0, 25);
			createPiece(startCol+2, 0, 25);
			TweenLite.to(piecesArray[startCol][0], 0.5, {x: piecesArray[startCol][0].x, y: piecesArray[startCol][0].y+25, ease:Bounce.easeOut});
			TweenLite.to(piecesArray[startCol+1][0], 0.5, {x: piecesArray[startCol+1][0].x, y: piecesArray[startCol+1][0].y+25, ease:Bounce.easeOut});
			TweenLite.to(piecesArray[startCol+2][0], 0.5, {x: piecesArray[startCol+2][0].x, y: piecesArray[startCol+2][0].y+25, ease:Bounce.easeOut});
		}
		
		private function colClear(startCol:int, rowNum:int):void 
		{
			for (var aboveRows:int = rowNum-3; aboveRows >= 0; aboveRows--) {
				TweenLite.to(piecesArray[startCol][aboveRows], 0.5, {x: piecesArray[startCol][aboveRows].x, y: piecesArray[startCol][aboveRows+3].y, ease:Bounce.easeOut});
				piecesArray[startCol][aboveRows+3] = piecesArray[startCol][aboveRows];
			}
			createPiece(startCol, 0, 25);
			createPiece(startCol, 1, 50);
			createPiece(startCol, 2, 75);
			TweenLite.to(piecesArray[startCol][0], 0.5, {x: piecesArray[startCol][0].x, y: piecesArray[startCol][0].y+25, ease:Bounce.easeOut});
			TweenLite.to(piecesArray[startCol][1], 0.5, {x: piecesArray[startCol][1].x, y: piecesArray[startCol][1].y+50, ease:Bounce.easeOut});
			TweenLite.to(piecesArray[startCol][2], 0.5, {x: piecesArray[startCol][2].x, y: piecesArray[startCol][2].y+75, ease:Bounce.easeOut});
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