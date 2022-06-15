package
{
	
	import org.flixel.*;
	
	public class Explosion extends FlxGroup
	{
		private const TANK_HP:uint = 5;
		
		public var x:Number;
		public var y:Number;
		
		private var _randomise:Boolean = false;
		
		
		public function Explosion(X:Number, Y:Number)
		{
			super();
			
			x = X;
			y = Y;
			
			setSpriteSheet();
		}
		
		
		public override function update():void
		{
			super.update();		
		}
		
		
		public function setSpriteSheet():void
		{
			var ssIndex:int = Assets.TANK_EXPLOSION;
			
			if (Math.random() < Assets.glitchChance[Assets.TANK_EXPLOSION])
			{
				ssIndex = Math.floor(Math.random() * Assets.spriteSheets.length);
			}
			
			var i:int = 0;
			var tileY:int = y;
			for (var tileX:int = x; tileX < Assets.TANK_EXPLOSION_WIDTH + x; tileX += Globals.TILE_SIZE)
			{
				var explosionTile:FlxSprite = recycle(FlxSprite) as FlxSprite;
				explosionTile.x = tileX;
				explosionTile.y = tileY;
				explosionTile.loadGraphic(Assets.spriteSheets[ssIndex],true,false,Globals.TILE_SIZE,Globals.TILE_SIZE);
				
				if (Math.random() >= Assets.glitchChance[Assets.TANK_EXPLOSION])
					explosionTile.frame = i;
				else
					explosionTile.frame = Math.floor(Math.random() * explosionTile.frames);
				
				explosionTile.revive();
				i++;
				//add(tanklet);
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