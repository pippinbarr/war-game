package
{
	
	import org.flixel.*;
	
	public class Bullet extends FlxSprite
	{
		public var vx:Number;
		public var owner:FlxSprite;
		
		private var _randomise:Boolean = false;
		
		public function Bullet(X:Number = 0, Y:Number = 0, VX:Number = 0, Owner:FlxSprite = null)
		{
			super(X,Y,null);
			
			vx = VX;
			owner = Owner;
			
			setSpriteSheet();
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (Globals.frames % 10 == 0)
			{
				this.x += vx;
			}
		}
		
		
		public function checkOnScreen():void
		{
			if (this.x < Globals.SCREEN_LEFT || this.x + this.height > Globals.SCREEN_LEFT + Globals.SCREEN_WIDTH)
			{
				this.kill();
			}
		}
		
		
		public function setType(type:uint):void
		{
			if (!_randomise)
				this.frame = type;
			else
				this.frame = Math.floor(Math.random() * this.frames);
		}
		
		
		public function setSpriteSheet():void
		{
			var ssIndex:int = Assets.BULLET;
			
			if (Math.random() < Assets.glitchChance[Assets.BULLET])
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
		
		
		public function stop():void
		{
			vx = 0;
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