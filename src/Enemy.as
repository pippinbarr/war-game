package
{
	
	import org.flixel.*;
	
	public class Enemy extends FlxSprite
	{
		
		public var actionOffset:Number;
		public var movement:Number;
		private var _movement:Number;
		private var timer:FlxTimer = new FlxTimer();
		
		private var _randomise:Boolean = false;
		
		public function Enemy(X:Number = 0, Y:Number = 0, ActionOffset:Number = 0, Movement:Number = 0)
		{
			super(X, Y, null);
			
			actionOffset = ActionOffset;
			movement = Movement;
			_movement = movement;
			
			setSpriteSheet();
		}
		
		
		public override function update():void
		{
			super.update();
			
			// Check if it's a movement frame
			if ((Globals.frames + actionOffset) % Globals.ENEMY_ACTION_RATE == 0)
			{
				y += (movement * Globals.TILE_SIZE);
				
				// Correct for going off edges
				if (this.y < Globals.SCREEN_TOP + Globals.TILE_SIZE)
				{
					this.y = Globals.SCREEN_TOP + Globals.SCREEN_HEIGHT - 2*Globals.TILE_SIZE;
				}
				else if (this.y >= Globals.SCREEN_TOP + Globals.SCREEN_HEIGHT - 2*Globals.TILE_SIZE)
				{
					this.y = Globals.SCREEN_TOP + Globals.TILE_SIZE;
				}
			}
		}
		
		
		public function stop():void
		{
			movement = 0;
		}
		
		
		public function start():void
		{
			movement  = _movement;
		}
		
		
		public function isFireFrame():Boolean
		{
			return (
				(Globals.frames + actionOffset/2) % Globals.ENEMY_ACTION_RATE == 0 &&
				Math.random() <= Globals.ENEMY_FIRE_CHANCE)
		}
		
		public function setMovement(value:Number):void
		{
			movement = value;
			_movement = movement;
		}
		
		public function setActionOffset(value:Number):void
		{
			actionOffset = value;
		}
		
		public function hit():void
		{
			if (!_randomise)
				this.frame = 1;
			else
				this.frame = Math.floor(Math.random() * this.frames);			
			
			this.timer.start(0.2,1,die);
		}
		
		private function die(t:FlxTimer):void
		{
			kill();
		}
		
		public function setSpriteSheet():void
		{
			var ssIndex:int = Assets.ENEMY;
			
			if (Math.random() < Assets.glitchChance[Assets.ENEMY])
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