package
{
	import org.flixel.*;
	
	
	public class Text extends FlxGroup
	{
		private const CHARACTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789\n";
		private const INPUT_CHARACTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";

		
		private var x:Number;
		private var y:Number;
		private var w:Number;
		private var s:String;
		
		private var nextX:Number;
		private var nextY:Number;
		private var addedChars:uint = 0;
		
		
		public function Text(X:Number, Y:Number, W:Number, S:String)
		{
			x = X;
			y = Y;
			w = W;
			s = S;
			
			nextX = x;
			nextY = y;
			
			if (s.length > 0)
			{
				setAsString(s);
			}
		}
		
		public function addChar(char:String):Boolean
		{
			trace("Adding \"" + char + "\"");
			
			if (INPUT_CHARACTERS.indexOf(char) == -1)
			{
				return false;	
			}
			else if (char == " ")
			{
				
			}
			else
			{
				var letter:Letter = this.recycle(Letter) as Letter;
				letter.revive();
				letter.setLetter(char.charCodeAt(0));
				letter.x = nextX;
				letter.y = nextY;
			}
			
			addedChars++;
			
			nextX = (nextX + Globals.TILE_SIZE) % (Globals.SCREEN_LEFT + Globals.SCREEN_WIDTH - Globals.TILE_SIZE);
			if (nextX == 0)
			{
				nextX = Globals.SCREEN_LEFT + Globals.TILE_SIZE;
				nextY += Globals.TILE_SIZE;
				
				if (nextY >= Globals.SCREEN_TOP + Globals.SCREEN_HEIGHT - Globals.TILE_SIZE)
				{
					for (var i:int = 0; i < this.members.length; i++)
					{
						if (this.members[i] != null &&
							this.members[i].alive)
						{
							this.members[i].y -= Globals.TILE_SIZE;
							if (this.members[i].y < Globals.SCREEN_TOP + Globals.TILE_SIZE)
								this.members[i].kill();
						}
					}
					
					nextY -= Globals.TILE_SIZE;
				}
			}
			return true;
		}
		
		
		public function setAsString(text:String):void
		{
			this.callAll("kill");
					
			var letterX:Number = x;
			var letterY:Number = y;
				
			for (var i:int = 0; i < text.length; i++)
			{
				if (CHARACTERS.indexOf(text.charAt(i).toString()) == -1)
				{
					
				}
				else if (text.charAt(i).toString() == " ")
				{
					letterX = (letterX + Globals.TILE_SIZE) % (Globals.SCREEN_LEFT + Globals.SCREEN_WIDTH - Globals.TILE_SIZE);
				}
				else if (text.charAt(i).toString() == "\n")
				{
					letterX = 0;
				}
				else
				{
					var letter:Letter = this.recycle(Letter) as Letter;
					letter.revive();
					letter.setLetter(text.charCodeAt(i));
					letter.x = letterX;
					letter.y = letterY;
					letterX = (letterX + Globals.TILE_SIZE) % (Globals.SCREEN_LEFT + Globals.SCREEN_WIDTH - Globals.TILE_SIZE);
				}
				
				if (letterX == 0)
				{
					letterX = Globals.SCREEN_LEFT + Globals.TILE_SIZE;
					letterY += Globals.TILE_SIZE;
				}
			}
			
			nextX = letterX;
			nextY = letterY;
			addedChars = 0;
		}
		
		
		public function getAddedChars():uint
		{
			return addedChars;
		}
	}
}