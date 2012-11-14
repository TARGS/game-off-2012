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
		public var piece:Piece;
		public var pieces:FlxGroup;
		public var piecesArray:Array;
		public var availablePiecesArray:Array;
		
		[Embed(source="data/background.png")] protected var JapanBackground:Class;
		[Embed(source="data/canadabackground.gif")] protected var CanadaBackground:Class;
		
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
			
			FlxG.mouse.show();
			
			background = new FlxSprite(0, 0);
			
			if (FlxG.level == 0) {
				background.loadGraphic(JapanBackground, false, false, 360, 240);
			} else if (FlxG.level == 1) {
				background.loadGraphic(CanadaBackground, false, false, 360, 240);
			}
			add(background);
			
			board = new FlxSprite(110, 50);
			board.makeGraphic(125, 175, 0xffaaaaaa);
			add(board);
			
			pieces = new FlxGroup();
			piecesArray = new Array(new Array(new Array()), new Array(new Array()), new Array(new Array()), new Array(new Array()), new Array(new Array()));
			availablePiecesArray = new Array(7, 7, 7, 7, 7);
			
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
			// An array meant for the initial setup of the match
			// Takes stock of which pieces are still available on first generation
			// Creates an array of indices in availablePiecesArray that is >0
			var stillAvailable:Array = new Array();
			for (var index:int = 0; index < availablePiecesArray.length; index++) {
				if (availablePiecesArray[index] == 0) {
					
				} else {
					stillAvailable.push(index);
				}
			}
			
			var graphic:int;
			
			if (stillAvailable.length >> 0) { // Meant for initial level generation
				graphic = Math.floor(Math.random() * stillAvailable.length);
				piece = new Piece(X*25+110, Y*25+50-heightOffset, stillAvailable[graphic]);		
				availablePiecesArray[stillAvailable[graphic]] -= 1;
			} else { // Meant for creating pieces after matches clear out existing pieces
				graphic = Math.floor(Math.random() * availablePiecesArray.length);
				piece = new Piece(X*25+110, Y*25+50-heightOffset, graphic);
			}
			
			// Enables clicking for the piece and adds to the FlxGroup of pieces on the board.
			piece.enableMouseClicks(false);
			piece.mouseReleasedCallback = pieceClicked;
			pieces.add(piece);
			piecesArray[X][Y] = piece;
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
					(((firstPieceX - secondPieceX) == 1 || (firstPieceX - secondPieceX) == -1) && (firstPieceY - secondPieceY) == 0) ||
					((firstPieceX - secondPieceX) == 0 && ((firstPieceY - secondPieceY) == 1 || (firstPieceY - secondPieceY) == -1))
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
				
				firstPiece.alpha = 1;
				
			} else {
				// Signals that a piece has been selected, and sets 'firstPiece' as that object
				isSelected = 1;
				firstPiece = obj;
				firstPiece.alpha = 0.5;
			}
		}
		
		public function matchingCheck():void
		{
			checkRows();
			checkColumns();
			gridCheck();
		}
		
		// Steps through each and every single row, checking for possible match-3 conditions
		// Currently only iterates through match-3 scenarios, will build match-4 and match-5 conditions soon
		private function checkRows():void
		{	
			var rowNum:int;
			for (rowNum = 0; rowNum <= 6; rowNum++) {
				var pieceGraphic:int;
				for (pieceGraphic = 0; pieceGraphic <= 5; pieceGraphic++) {
					if (piecesArray[0][rowNum].sprite == pieceGraphic && piecesArray[1][rowNum].sprite == pieceGraphic && piecesArray[2][rowNum].sprite == pieceGraphic && piecesArray[3][rowNum].sprite == pieceGraphic && piecesArray[4][rowNum].sprite == pieceGraphic) {
						rowClear(0, rowNum, 5);
					} else if (piecesArray[0][rowNum].sprite == pieceGraphic && piecesArray[1][rowNum].sprite == pieceGraphic && piecesArray[2][rowNum].sprite == pieceGraphic && piecesArray[3][rowNum].sprite == pieceGraphic) {
						rowClear(0, rowNum, 4);
					} else if (piecesArray[1][rowNum].sprite == pieceGraphic && piecesArray[2][rowNum].sprite == pieceGraphic && piecesArray[3][rowNum].sprite == pieceGraphic && piecesArray[4][rowNum].sprite == pieceGraphic) {
						rowClear(1, rowNum, 4);
					} else if (piecesArray[0][rowNum].sprite == pieceGraphic && piecesArray[1][rowNum].sprite == pieceGraphic && piecesArray[2][rowNum].sprite == pieceGraphic) {
						rowClear(0, rowNum, 3);
					} else if (piecesArray[1][rowNum].sprite == pieceGraphic && piecesArray[2][rowNum].sprite == pieceGraphic && piecesArray[3][rowNum].sprite == pieceGraphic) {
						rowClear(1, rowNum, 3);
					} else if (piecesArray[2][rowNum].sprite == pieceGraphic && piecesArray[3][rowNum].sprite == pieceGraphic && piecesArray[4][rowNum].sprite == pieceGraphic) {
						rowClear(2, rowNum, 3);
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
					if (piecesArray[colNum][0].sprite == pieceGraphic && piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic && piecesArray[colNum][6].sprite == pieceGraphic) {
						colClear(colNum, 6, 7);
					} else if (piecesArray[colNum][0].sprite == pieceGraphic && piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic) {
						colClear(colNum, 5, 6);
					} else if (piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic && piecesArray[colNum][6].sprite == pieceGraphic) {
						colClear(colNum, 6, 6);
					} else if (piecesArray[colNum][0].sprite == pieceGraphic && piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic) {
						colClear(colNum, 4, 5);
					} else if (piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic) {
						colClear(colNum, 5, 5);
					} else if (piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic && piecesArray[colNum][6].sprite == pieceGraphic) {
						colClear(colNum, 6, 5);
					} else if (piecesArray[colNum][0].sprite == pieceGraphic && piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic) {
						colClear(colNum, 3, 4);
					} else if (piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic) {
						colClear(colNum, 4, 4);
					} else if (piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic) {
						colClear(colNum, 5, 4);
					} else if (piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic && piecesArray[colNum][6].sprite == pieceGraphic) {
						colClear(colNum, 6, 4);
					} else if (piecesArray[colNum][0].sprite == pieceGraphic && piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic) {
						colClear(colNum, 2, 3);
					} else if (piecesArray[colNum][1].sprite == pieceGraphic && piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic) {
						colClear(colNum, 3, 3);
					} else if (piecesArray[colNum][2].sprite == pieceGraphic && piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic) {
						colClear(colNum, 4, 3);
					} else if (piecesArray[colNum][3].sprite == pieceGraphic && piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic) {
						colClear(colNum, 5, 3);
					} else if (piecesArray[colNum][4].sprite == pieceGraphic && piecesArray[colNum][5].sprite == pieceGraphic && piecesArray[colNum][6].sprite == pieceGraphic) {
						colClear(colNum, 6, 3);
					}
				}
			}
		}
		
		// Clears a matched row using a starting column, which row it's on, and how many pieces to eliminate
		private function rowClear(startCol:int, rowNum:int, length:int):void 
		{	
			for (var count:int = 0; count < length; count++) {
				piecesArray[startCol+count][rowNum].kill();
			}
		}
		
		// Clears a matched column using a starting column, which row the most bottom piece is on, and how many pieces above to eliminate
		private function colClear(startCol:int, rowNum:int, length:int):void 
		{	
			for (var count:int = 0; count < length; count++) {
				piecesArray[startCol][rowNum-count].kill();
			}
		}
		
		private function gridCheck():void
		{
			for (var rowNum:int = 6; rowNum >= 0; rowNum--) {
				for (var colNum:int = 4; colNum >= 0; colNum--) {
					if (piecesArray[colNum][rowNum].exists == false) {
						
						/*
						var emptyCount:int = 0;
						for (var aboveRows:int = rowNum-1; aboveRows >= 0; aboveRows--) {
							if (piecesArray[colNum][aboveRows].exists == true) {
								break;
							} else {
								emptyCount++;
							}
						}
						
						FlxG.log(emptyCount);
						
						for (var rowCount:int = 0; rowCount <= emptyCount; rowCount++) {
							for (var aboveRows:int = (rowNum-emptyCount); aboveRows >= 0; aboveRows--) {
								TweenLite.to(piecesArray[colNum][aboveRows], 0.5, {x: piecesArray[colNum][aboveRows].x, y: piecesArray[colNum][aboveRows].y+((emptyCount+1)*25), ease:Bounce.easeOut});
								piecesArray[colNum][aboveRows+emptyCount] = piecesArray[colNum][aboveRows];
								FlxG.log("Moving piece on (" + colNum + ", " + aboveRows + ") to (" + colNum + ", " + (aboveRows+emptyCount) + ")");
							}
							FlxG.log("Creating piece on (" + colNum + ", " + emptyCount + ") with height offset = " + ((emptyCount+1)*25));
							createPiece(colNum, rowCount, ((rowCount+1)*25));
							TweenLite.to(piecesArray[colNum][rowCount], 0.5, {x: piecesArray[colNum][rowCount].x, y: piecesArray[colNum][rowCount].y+((rowCount+1)*25), ease:Bounce.easeOut});
						}
						*/
						
						var aboveRows:int;
						
						// If there are three vertical pieces to be replaced
						if (rowNum >= 2 && piecesArray[colNum][rowNum-2].exists == false && piecesArray[colNum][rowNum-1].exists == false && piecesArray[colNum][rowNum].exists == false) {
							
							for (aboveRows = rowNum-3; aboveRows >= 0; aboveRows--) {
								piecesArray[colNum][aboveRows+3] = piecesArray[colNum][aboveRows];
								TweenLite.to(piecesArray[colNum][aboveRows], 0.5, {x: piecesArray[colNum][aboveRows].x, y: piecesArray[colNum][aboveRows].y+75, ease:Bounce.easeOut});
							}
							createPiece(colNum, 0, 25);
							createPiece(colNum, 1, 50);
							createPiece(colNum, 2, 75);
							TweenLite.to(piecesArray[colNum][0], 0.5, {x: piecesArray[colNum][0].x, y: piecesArray[colNum][0].y+25, ease:Bounce.easeOut});
							TweenLite.to(piecesArray[colNum][1], 0.5, {x: piecesArray[colNum][1].x, y: piecesArray[colNum][1].y+50, ease:Bounce.easeOut});
							TweenLite.to(piecesArray[colNum][2], 0.5, {x: piecesArray[colNum][2].x, y: piecesArray[colNum][2].y+75, ease:Bounce.easeOut, onComplete:matchingCheck});
							
						// If there are two vertical pieces to be replaced
						} else if (rowNum >= 2 && piecesArray[colNum][rowNum-1].exists == false && piecesArray[colNum][rowNum].exists == false) {
							
							for (aboveRows = rowNum-2; aboveRows >= 0; aboveRows--) {
								piecesArray[colNum][aboveRows+2] = piecesArray[colNum][aboveRows];
								TweenLite.to(piecesArray[colNum][aboveRows], 0.5, {x: piecesArray[colNum][aboveRows].x, y: piecesArray[colNum][aboveRows].y+50, ease:Bounce.easeOut});
							}
							createPiece(colNum, 0, 25);
							createPiece(colNum, 1, 50);
							TweenLite.to(piecesArray[colNum][0], 0.5, {x: piecesArray[colNum][0].x, y: piecesArray[colNum][0].y+25, ease:Bounce.easeOut});
							TweenLite.to(piecesArray[colNum][1], 0.5, {x: piecesArray[colNum][1].x, y: piecesArray[colNum][1].y+50, ease:Bounce.easeOut, onComplete:matchingCheck});
						
						// If there is just one vertical piece to be replaced
						} else if (piecesArray[colNum][rowNum].exists == false) {
							for (aboveRows = rowNum-1; aboveRows >= 0; aboveRows--) {
								FlxG.log("(" + colNum + ", " + aboveRows + ")");
								piecesArray[colNum][aboveRows+1] = piecesArray[colNum][aboveRows];
								TweenLite.to(piecesArray[colNum][aboveRows], 0.5, {x: piecesArray[colNum][aboveRows].x, y: piecesArray[colNum][aboveRows].y+25, ease:Bounce.easeOut});
							}
							createPiece(colNum, 0, 25);
							TweenLite.to(piecesArray[colNum][0], 0.5, {x: piecesArray[colNum][0].x, y: piecesArray[colNum][0].y+25, ease:Bounce.easeOut, onComplete:matchingCheck});
						}
						
					}
				}
			}
		}
		
		override public function update():void
		{
			super.update();

		}
	}
}