package
{
	
	import org.flixel.*;
	
	public class Letter extends FlxSprite
	{
		
		private var _randomise:Boolean = false;
		
		public function Letter()
		{
			setSpriteSheet();
		}
		
		
		public function setLetter(charCode:uint):void
		{
			// Convert the char into a frame
			var letterFrame:uint;
			
			// Letters
			if (charCode >= 65 && charCode <= 90)
				letterFrame = charCode - 65;
			// Numbers
			else if (charCode <= 57 && charCode >= 48)
				letterFrame = charCode - 22;
			
			// Set the frame
			if (Math.random() >= Assets.glitchChance[Assets.LETTER])
			{
				this.frame = letterFrame;
			}
			else
			{
				this.frame = Math.floor(Math.random() * this.frames);
			}
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		public function setSpriteSheet():void
		{
			var ssIndex:int = Assets.LETTER;
			
			if (Math.random() < Assets.glitchChance[Assets.LETTER])
			{
				ssIndex = Math.floor(Math.random() * Assets.spriteSheets.length);
			}
			
			this.loadGraphic(
				Assets.spriteSheets[ssIndex],
				true,
				false,
				Globals.TILE_SIZE,
				Globals.TILE_SIZE);
			
			if (Math.random() < Assets.glitchChance[Assets.ENEMY])
			{
				this.frame = Math.floor(Math.random() * this.frames)
			}
			else
			{
				this.frame = 0;
			}
		}
		
		
		public override function revive():void
		{
			super.revive();
			
			setSpriteSheet();
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}