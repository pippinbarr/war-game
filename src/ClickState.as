package  
{
	import flash.events.MouseEvent;
	
	import org.flixel.*;
	
	public class ClickState extends FlxState
	{	
		private var _instructionsText:FlxText;
		private var _bg:FlxSprite;
		
		public function ClickState() 
		{
		}
		
		override public function create():void
		{	
			FlxG.mouse.show();
			
			FlxG.bgColor = 0xFFFFFFFF;
			
			_bg = new FlxSprite(0,0,Assets.CLICK_BG);
			add(_bg);
			
			_instructionsText = new FlxText(0,200,FlxG.width,"[ CLICK ]",true);
			_instructionsText.setFormat(null,64,0xFFFFFFFF,"center");
			
			add(_instructionsText);
			
			FlxG.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		
		override public function update():void
		{
			super.update();
		}
		
		
		
		
		
		private function onMouseUp(e:MouseEvent):void
		{
			FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			FlxG.switchState(new GameState);
		}
		
		
		public override function destroy():void
		{
			_instructionsText.destroy();
		}
		
		
	}
	
}