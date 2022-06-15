package
{
	import org.flixel.*;

	public class FontGen extends FlxState
	{
		[Embed(source="assets/fonts/digital-7 (mono).ttf", fontName="FONT", fontWeight="Regular", embedAsCFF="false")]
		private const FONT:Class;
		
		//private var _text:TextField;
		//private var _textFormat:TextFormat = new TextFormat("FONT",18,0xFFFFFF,null,null,null,null,null,"center");

		public function FontGen()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFFFFFFFF;
			var x:int = 3;
			var y:int = 0;
			var char:String = "A";
			
//			for (var i:int = 0; i < 3; i += 2)
//			{
//				var rect:FlxSprite = new FlxSprite(0,i * Globals.GRID_SIZE);
//				rect.makeGraphic(FlxG.width,Globals.GRID_SIZE,0xFF0000FF);
//				add(rect);
//			}
			
			for (var i:int = 0; i < 26; i++)
			{
				var text:FlxText = new FlxText(x,y,FlxG.width,char,true);
				text.setFormat("FONT",20,0xFF000000,"left");
				add(text);
				
				x += Globals.GRID_SIZE;
				var charCode = char.charCodeAt(0);
				charCode++;
				char = String.fromCharCode(charCode);
				
				if (x >= FlxG.width)
				{
					x = 3;
					y += Globals.GRID_SIZE;
				}
			}
			
			char = "0";
			for (var i:int = 0; i < 10; i++)
			{
				var text:FlxText = new FlxText(x,y,FlxG.width,char,true);
				text.setFormat("FONT",20,0xFF000000,"left");
				add(text);
				
				x += Globals.GRID_SIZE;
				var charCode = char.charCodeAt(0);
				charCode++;
				char = String.fromCharCode(charCode);
				
				if (x >= FlxG.width)
				{
					x = 3;
					y += Globals.GRID_SIZE;
				}
			}
			
			var rect2:FlxSprite = new FlxSprite(0,y);
			rect2.makeGraphic(FlxG.width,FlxG.height,0xFFFFFF00);
			add(rect2);
		}
	}
}