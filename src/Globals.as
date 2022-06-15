package
{
	import org.flixel.*;

	public class Globals
	{
		// Game screen dimensions
		public static const SCREEN_LEFT:Number = 140;
		public static const SCREEN_TOP:Number = 100;
		public static const SCREEN_WIDTH:Number = 360;
		public static const SCREEN_HEIGHT:Number = 240;		
		
		public static const SCREEN_WIDTH_IN_TILES:Number = 18;
		public static const SCREEN_HEIGHT_IN_TILES:Number = 12;		

		public static const TILE_SIZE:uint = 20;

		// Tracking frames (for timing)
		// Another option would be elapsed time, might be more flexible?
		public static var frames:uint = 0;
	
		
		// Tank
		public static const TANK_FIRE_RATE:uint = 40;
		public static const TANK_FIRE_CHANCE:Number = 0.8;
		public static const SHELL_SPEED:uint = 40;

		// Enemies
		public static const NUM_ENEMIES:uint = 4;
		public static const ENEMY_ACTION_RATE:uint = 90;
		public static const ENEMY_FIRE_CHANCE:Number = 0.8;
		public static const BULLET_SPEED:uint = 20;

		// Evaluation
		public static const EVAL_MAX_CHARS:uint = 100;

		public static const PRE_EVAL_INJURY_TEXT:String = "" +
			"YOU GOT HIT\n\n" +
			"BUT WE PATCHED YOU UP\n\n" +
			"REPORT FOR MANDATORY PSYCH EVALUATION";
		
		public static const PRE_EVAL_KILLS_TEXT:String = "" +
			"FIVE CONFIRMED KILLS\n\n" +
			"GOOD JOB\n\n" +
			"REPORT FOR MANDATORY PSYCH EVALUATION";
		
		public static const POST_EVAL_TEXT:String = "" +
			"EVERYTHING SEEMS TO BE IN ORDER\n\n" +
			"YOU'LL BE FINE\n\n" +
			"RETURN TO ACTIVE DUTY";
		
		public static const EVAL_QUESTIONS:Array = new Array(
			"TELL ME ABOUT YOUR MOTHER\n\n",
			"TELL ME ABOUT YOUR FATHER\n\n",
			"TELL ME ABOUT YOUR CHILDHOOD\n\n",
			"WHAT DO YOU SEE WHEN YOU CLOSE YOUR EYES\n\n",
			"TELL ME ABOUT YOUR DREAMS\n\n",
			"HOW ARE YOU SLEEPING\n\n",
			"HOW ARE YOU FEELING TODAY\n\n",
			"WHAT WOULD YOU LIKE TO DISCUSS\n\n",
			"HOW DO YOU FEEL ABOUT YOUR COUNTRY\n\n",
			"HOW ARE YOU HOLDING UP\n\n",
			"SPEAK YOUR MIND\n\n"
		);
		
		
		
		public function Globals()
		{
		}
	}
}