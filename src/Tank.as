package
{
	
	import org.flixel.*;
	
	public class Tank extends FlxGroup
	{
		private const TANK_HP:uint = 5;
				
		public var x:Number;
		public var y:Number;
		public var hitPoints:uint = TANK_HP;
		
		private var _randomise:Boolean = false;
		
		public function Tank(X:Number, Y:Number)
		{
			super();
			
			x = X;
			y = Y;
			
			setSpriteSheet();
		}
		
		
		public function isFireFrame():Boolean
		{
			return (
				Globals.frames % Globals.TANK_FIRE_RATE == 0 &&
				Math.random() <= Globals.TANK_FIRE_CHANCE &&
				alive &&
				visible)				

		}
		
		
		public function hit():void
		{
			if (alive && visible)
				hitPoints--;
		}
		
		
		public function isDead():Boolean
		{			
			var result:Boolean = (hitPoints <= 0);
			if (result) hitPoints = TANK_HP;
			return result;
		}
		
		
		public function flicker():void
		{
			for (var i:int = 0; i < members.length; i++)
			{
				if (members[i] != null && members[i].alive && members[i].visible)
					members[i].flicker(0.1);
			}
		}
		
		public override function update():void
		{
			super.update();		
		}
		
		
		public function setSpriteSheet():void
		{
			var ssIndex:int = Assets.TANK;

			if (Math.random() < Assets.glitchChance[Assets.TANK])
			{
				ssIndex = Math.floor(Math.random() * Assets.spriteSheets.length);
			}
			
			var i:int = 0;
			for (var tileY:int = y; tileY < Assets.TANK_HEIGHT + y; tileY += Globals.TILE_SIZE)
			{
				for (var tileX:int = x; tileX < Assets.TANK_WIDTH + x; tileX += Globals.TILE_SIZE)
				{
					var tanklet:FlxSprite = recycle(FlxSprite) as FlxSprite;
					tanklet.x = tileX;
					tanklet.y = tileY;
					tanklet.loadGraphic(Assets.spriteSheets[ssIndex],true,false,Globals.TILE_SIZE,Globals.TILE_SIZE);
					
					if (Math.random >= Assets.glitchChance[Assets.TANK])
						tanklet.frame = i;
					else
						tanklet.frame = Math.floor(Math.random() * tanklet.frames);
					
					tanklet.revive();
					i++;
					//add(tanklet);
				}
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