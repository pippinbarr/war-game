package
{
	
	import org.flixel.*;
	
	// 240 x 360 = 12 x 18 (need 10 x 14 for the typing, leaving 12 x 4 for question = 48 chars
	[SWF(width = "640", height = "480", backgroundColor = "#FFFFFF")]
	//[Frame(factoryClass="WarGamePreloader")]
	
	public class WarGame extends FlxGame
	{
		public function WarGame()
		{
			super(640,480,ClickState,1,30,30);
			
			//this.useSoundHotKeys = false;
			//this.forceDebugger = true;
			FlxG.volume = 1.0;
		}
	}
}