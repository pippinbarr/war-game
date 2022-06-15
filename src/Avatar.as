package
{
	
	import org.flixel.*;
	
	public class Avatar extends FlxSprite
	{
		public function Avatar(X:Number, Y:Number)
		{
			super(X, Y, null);		
			
			setSpriteSheet();
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		public function setSpriteSheet():void
		{
			var ssIndex:int = Assets.AVATAR;
			
			if (Math.random() < Assets.glitchChance[Assets.AVATAR])
			{
				ssIndex = Math.floor(Math.random() * Assets.spriteSheets.length);
			}
			
			this.loadGraphic(
				Assets.spriteSheets[ssIndex],
				true,
				false,
				Globals.TILE_SIZE,
				Globals.TILE_SIZE);
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