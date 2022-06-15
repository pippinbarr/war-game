package
{
	public class Assets
	{
		// Start up
		
		[Embed(source="assets/spritesheets/click_bg.png")]
		public static const CLICK_BG:Class;
		
		// Sounds
		
		[Embed(source="assets/sounds/fire.mp3")]
		public static const FIRE_SOUND:Class;
		
		[Embed(source="assets/sounds/die.mp3")]
		public static const DIE_SOUND:Class;
		
		[Embed(source="assets/sounds/startup.mp3")]
		public static const STARTUP_SOUND:Class;
		
		// Sprite sheets
		
		[Embed(source="assets/spritesheets/avatar.png")]
		public static const AVATAR_SS:Class;
				
		[Embed(source="assets/spritesheets/enemy.png")]
		public static const ENEMY_SS:Class;

		[Embed(source="assets/spritesheets/bullet.png")]
		public static const BULLET_SS:Class;
		public static const AVATAR_BULLET_FRAME:uint = 0;
		public static const ENEMY_BULLET_FRAME:uint = 1;
		public static const TANK_SHELL_FRAME:uint = 2;
		
		[Embed(source="assets/spritesheets/tank.png")]
		public static const TANK_SS:Class;
		public static const TANK_WIDTH:Number = 100;
		public static const TANK_HEIGHT:Number = 60;
		
		[Embed(source="assets/spritesheets/explosion.png")]
		public static const TANK_EXPLOSION_SS:Class;
		public static const TANK_EXPLOSION_WIDTH:uint = 120;
		
		[Embed(source="assets/spritesheets/tank_icon.png")]
		public static const TANK_ICON_SS:Class;

		[Embed(source="assets/spritesheets/letters.png")]
		public static const LETTER_SS:Class;
		
		[Embed(source="assets/spritesheets/handheld_bg.png")]
		public static const BACKGROUND_SS:Class;
		
		[Embed(source="assets/spritesheets/small_button.png")]
		public static const SMALL_BUTTON_SS:Class;
		
		[Embed(source="assets/spritesheets/large_button.png")]
		public static const LARGE_BUTTON_SS:Class;

		[Embed(source="assets/spritesheets/space_button.png")]
		public static const SPACE_BUTTON_SS:Class;
		
		// Standard indexes into arrays corresponding to each of the glitchable game elements
		public static const ENEMY:uint = 0;
		public static const BULLET:uint = 1;
		public static const AVATAR:uint = 2;
		public static const TANK_EXPLOSION:uint = 3;
		public static const LETTER:uint = 4;
		public static const TANK:uint = 5;
		public static const TANK_ICON:uint = 6;
		
		public static const GLITCHABLES:uint = 7; // Random on this number will give a random graphic sheet
		
		public static var LETTER_GLITCH_CHANCE:Number = 0;
		
		// Array containing the spritesheets in correct order
		public static var spriteSheets:Array = new Array(
			ENEMY_SS,BULLET_SS,AVATAR_SS,TANK_EXPLOSION_SS,LETTER_SS,TANK_SS,TANK_ICON_SS
		);
		
		
		// This is the array that determines the index to look at for the graphics for
		// specific elements in the game (according to the indexes defined above)
		// Negative will mean randomising the frames, positive will mean sequential (with modulus)
		public static var graphics:Array = new Array(
			ENEMY, BULLET, AVATAR, TANK_EXPLOSION, 
			LETTER, TANK, TANK_ICON
		);
		
		
		public static var glitchChance:Array = new Array(
			0, 0, 0, 0, 0, 0, 0);
		
		public static const GLITCH_CHANCE_INCREASE:Number = 0.2;
		public static const LETTER_GLITCH_CHANCE_INCREASE:Number = 0.1;
		
		
		// The highest index to include when applying glitches to the graphics array
		// We'll start at -1 so as to have no glitches.
		public static var glitchMaxIndex:int = 0;
		
		
		
		public function Assets()
		{
		}
	}
}