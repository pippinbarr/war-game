package
{
	
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	
	public class PrototypeState extends FlxState
	{
		
		private const PRE_EVAL_TIME:Number = 2;
		private const POST_EVAL_TIME:Number = 2;
		private const BATTLE_FATIGUE_KILL_COUNT:uint = 5;
		
		private const CHARACTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 \n";
		
		private const WAR:uint = 0;
		private const TANK_WAR:uint = 1;
		private const PRE_EVAL:uint = 2;
		private const EVAL:uint = 3;
		private const POST_EVAL:uint = 4;
		
		private var _state:uint = WAR;
		private var _warState:uint = WAR;
		
		private var _killCount:uint = 0;
		
		
		private var _preEvalText:String = "PRE_EVAL_TEXT";
		private var _postEvalText:String = "POST_EVAL_TEXT";
		
		private var _evalQuestion:String = "QUESTION\n\nWHAT DO YOU SEE WHEN YOU CLOSE YOUR EYES?\n\nANSWER IN\n140 CHARS\n\n";
		
		private var _evalAnswerX:uint = Globals.GRID_SIZE;
		private var _evalAnswerY:uint = Globals.GRID_SIZE * 9;
		
		private var _evalAnswerLength:uint = 0;
				
		private var _timer:FlxTimer = new FlxTimer();
		
		
		public function PrototypeState()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFFDDDCC7;
			
			Globals.AVATAR = new Avatar(2 * 2 * Globals.GRID_SIZE,FlxG.height - 2 * Globals.GRID_SIZE);
			Globals.TANK = new Tank(0 + (FlxG.width - Assets.TANK_WIDTH)/2, Globals.GRID_SIZE * 2);
			
			Globals.TANK.visible = false;
			
			add(Globals.AVATAR);
			add(Globals.AVATAR_BULLETS);
			add(Globals.ENEMY_BULLETS);
			add(Globals.ENEMY_ROW_1);
			add(Globals.ENEMY_ROW_2);
			add(Globals.ENEMY_ROW_3);
			add(Globals.TANK);
			
			Globals.EVAL_QUESTION.visible = false;
			Globals.EVAL_ANSWER.visible = false;
			Globals.PRE_EVAL_TEXT.visible = false;
			Globals.POST_EVAL_TEXT.visible = false;

			add(Globals.EVAL_QUESTION);
			add(Globals.EVAL_ANSWER);
			add(Globals.PRE_EVAL_TEXT);
			add(Globals.POST_EVAL_TEXT);
			
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onEvalKeyDown);
		}
		
		
		public override function update():void
		{
			super.update();
			
			Globals.FRAMES++;
			
			if (_state == WAR || _state == TANK_WAR)
				handleWarInput();
			else if (_state == EVAL)
				handleEvalInput();
			
			if (Globals.FRAMES % Globals.SOLDIER_ACTION_RATE == 0)
			{
				addEnemies();
			}
			checkBullets();
		}
		
		
		private function handleWarInput():void
		{
			if (FlxG.keys.justPressed("LEFT") && Globals.AVATAR.x > 0)
			{
				Globals.AVATAR.x -= Globals.GRID_SIZE;
			}
			else if (FlxG.keys.justPressed("RIGHT") && Globals.AVATAR.x + Globals.AVATAR.width < FlxG.width)
			{
				Globals.AVATAR.x += Globals.GRID_SIZE;
			}
			else if (FlxG.keys.justPressed("SPACE") && Globals.AVATAR.y > 0 + Globals.GRID_SIZE)
			{
				// Fire a bullet
				var bullet:Bullet = Globals.AVATAR_BULLETS.recycle(Bullet) as Bullet;
				bullet.x = Globals.AVATAR.x;
				bullet.y = Globals.AVATAR.y - Globals.GRID_SIZE;
				bullet.vy = -Globals.BULLET_SPEED;
				bullet.owner = Globals.AVATAR;
				bullet.setType(Assets.AVATAR);
				bullet.revive();
			}
		}
		
		
		private function handleEvalInput():void
		{
			
		}
		
		
		private function onEvalKeyDown(e:KeyboardEvent):void
		{
			if (_state != EVAL) return;
			
			var char:String = String.fromCharCode(e.charCode);
			char = char.toUpperCase();
			
			if (CHARACTERS.indexOf(char) == -1)
			{
				return;	
			}
			else if (char == " ")
			{
				
			}
			else
			{
				var letter:Letter = Globals.EVAL_ANSWER.recycle(Letter) as Letter;
				letter.setLetter(char.charCodeAt(0));
				letter.x = this._evalAnswerX;
				letter.y = this._evalAnswerY;
				letter.revive();
			}
			
			_evalAnswerLength++;
			
			this._evalAnswerX = (this._evalAnswerX + Globals.GRID_SIZE) % (FlxG.width - Globals.GRID_SIZE);
			if (this._evalAnswerX == 0)
			{
				this._evalAnswerX = Globals.GRID_SIZE;
				this._evalAnswerY += Globals.GRID_SIZE;
				
				if (this._evalAnswerY >= FlxG.height - Globals.GRID_SIZE)
				{
					for (var i:int = 0; i < Globals.EVAL_QUESTION.members.length; i++)
					{
						if (Globals.EVAL_QUESTION.members[i] != null &&
							Globals.EVAL_QUESTION.members[i].alive)
						{
							Globals.EVAL_QUESTION.members[i].y -= Globals.GRID_SIZE;
							if (Globals.EVAL_QUESTION.members[i].y < Globals.GRID_SIZE)
								Globals.EVAL_QUESTION.members[i].kill();
						}
					}
					for (var i:int = 0; i < Globals.EVAL_ANSWER.members.length; i++)
					{
						if (Globals.EVAL_ANSWER.members[i] != null &&
							Globals.EVAL_ANSWER.members[i].alive)
						{
							Globals.EVAL_ANSWER.members[i].y -= Globals.GRID_SIZE;
							if (Globals.EVAL_ANSWER.members[i].y < Globals.GRID_SIZE)
								Globals.EVAL_ANSWER.members[i].kill();
						}
					}
					this._evalAnswerY -= Globals.GRID_SIZE;
				}
			}
			
			if (_evalAnswerLength == Globals.EVAL_MAX_CHARS)
			{
				switchToPostEval();
			}
		}
		
		
		private function checkBullets():void
		{
			FlxG.overlap(Globals.AVATAR, Globals.ENEMY_BULLETS, avatarHitByBullet);
			FlxG.overlap(Globals.ENEMY_ROW_1, Globals.AVATAR_BULLETS, enemyHit);
			FlxG.overlap(Globals.ENEMY_ROW_2, Globals.AVATAR_BULLETS, enemyHit);
			FlxG.overlap(Globals.ENEMY_ROW_3, Globals.AVATAR_BULLETS, enemyHit);
			
			Globals.ENEMY_BULLETS.callAll("checkOnScreen");
			Globals.AVATAR_BULLETS.callAll("checkOnScreen");
		}
		
		
		private function avatarHitByBullet(avatar:FlxObject, bullet:FlxObject):void
		{
			if ((bullet as Bullet).getType() != 0)
			{
				avatar.kill();
				bullet.kill();
				
				_preEvalText = "WOUNDED IN ACTION\n\nIMMEDIATE EVAC\n\nPSYCH EVAL NEEDED\n\nWAIT FOR DOCTOR";
				_postEvalText = "PATCHED YOU UP\n\nYOU'LL BE FINE\n\nRETURN TO ACTIVE DUTY";
				_evalQuestion = "QUESTION\n\nHOW ARE YOU FEELING SON\n\nANSWER";
				switchToPreEval();
			}		
		}
		
		
		private function switchToPreEval():void
		{
			setPreEvalText();
			setWarVisible(false);
			Globals.TANK.visible = false;
			setPreEvalVisible(true);
			_state = PRE_EVAL;
			
			_timer.start(PRE_EVAL_TIME,1,switchToEval);
		}
		
		
		private function switchToEval(t:FlxTimer):void
		{
			Globals.EVAL_ANSWER.callAll("kill");
			_evalAnswerLength = 0;
			_evalAnswerX = Globals.GRID_SIZE;
			_evalAnswerY = Globals.GRID_SIZE * 9;
			
			setEvalQuestion();
			setPreEvalVisible(false);
			setEvalVisible(true);
			_state = EVAL;
		}
		
		
		private function switchToPostEval():void
		{
			setPostEvalText();
			setEvalVisible(false);
			setPostEvalVisible(true);
			_state = POST_EVAL;
			
			if (_killCount % 15 == 0)
				_warState = TANK_WAR;
			
			if (_warState == WAR)
				_timer.start(POST_EVAL_TIME,1,switchToWar);
			else if (_warState == TANK_WAR)
				_timer.start(POST_EVAL_TIME,1,switchToTankWar);
		}
		
		
		private function switchToWar(t:FlxTimer):void
		{
			Globals.ENEMY_BULLETS.callAll("kill");
			setPostEvalVisible(false);
			setWarVisible(true);
			Globals.AVATAR.revive();
			_state = WAR;
		}
		
		
		private function switchToTankWar(t:FlxTimer):void
		{
			Globals.ENEMY_BULLETS.callAll("kill");
			setPostEvalVisible(false);
			setWarVisible(true);
			Globals.TANK.visible = true;
			Globals.AVATAR.revive();
			_state = WAR;
		}
		
		
		private function setEvalQuestion():void
		{
			displayText(_evalQuestion, Globals.EVAL_QUESTION);
		}
		
		
		private function setPreEvalText():void
		{
			displayText(_preEvalText, Globals.PRE_EVAL_TEXT);
		}
		
		
		private function setPostEvalText():void
		{
			displayText(_postEvalText, Globals.POST_EVAL_TEXT);
		}
		
		
		private function displayText(text:String, textGroup:FlxGroup):void
		{
			textGroup.callAll("kill");
			
			var x:int = Globals.GRID_SIZE; 
			var y:int = 1 * Globals.GRID_SIZE;
			
			for (var i:int = 0; i < text.length; i++)
			{
				if (CHARACTERS.indexOf(text.charAt(i).toString()) == -1)
				{
					
				}
				else if (text.charAt(i).toString() == " ")
				{
					x = (x + Globals.GRID_SIZE) % (FlxG.width - Globals.GRID_SIZE);
				}
				else if (text.charAt(i).toString() == "\n")
				{
					x = 0;
				}
				else
				{
					var letter:Letter = textGroup.recycle(Letter) as Letter;
					letter.setLetter(text.charCodeAt(i));
					letter.x = x;
					letter.y = y;
					letter.revive();
					x = (x + Globals.GRID_SIZE) % (FlxG.width - Globals.GRID_SIZE);
				}
				if (x == 0)
				{
					x = Globals.GRID_SIZE;
					y += Globals.GRID_SIZE;
				}
				
			}
		}
		
		
		private function setWarVisible(value:Boolean):void
		{
			Globals.AVATAR.visible = value;
			Globals.ENEMY_ROW_1.visible = value;
			Globals.ENEMY_ROW_2.visible = value;
			Globals.ENEMY_ROW_3.visible = value;
			Globals.AVATAR_BULLETS.visible = value;
			Globals.ENEMY_BULLETS.visible = value;
		}
		
		
		private function setPreEvalVisible(value:Boolean):void
		{
			Globals.PRE_EVAL_TEXT.visible = value;
		}
		
		
		private function setEvalVisible(value:Boolean):void
		{
			Globals.EVAL_QUESTION.visible = value;
			Globals.EVAL_ANSWER.visible = value;
		}
		
		
		private function setPostEvalVisible(value:Boolean):void
		{
			Globals.POST_EVAL_TEXT.visible = value;
		}
		
		
		private function enemyHit(enemy:FlxObject, bullet:FlxObject):void
		{
			if ((bullet as Bullet).owner != (enemy as FlxSprite))
			{
				enemy.kill();
				bullet.kill();
				
				_killCount++;
				
				if (_killCount >= BATTLE_FATIGUE_KILL_COUNT)
				{
					Globals.AVATAR.kill();

					_killCount = 0;
					_preEvalText = "5 CONFIRMED KILLS\n\nSUSPECTED BATTLE FATIGUE\n\nPSYCH EVAL REQUIRED\n\nWAIT HERE";
					_evalQuestion = "XYZ";
					switchToPreEval();
				}
			}
		}
		
		
		private function tankHit(tank:FlxObject, bullet:FlxObject):void
		{
			//tank.hit();
			bullet.kill();
			//if (tank.dead())
			{
				// Blow up the tank
			}
		}
		
		
		private function addEnemies():void
		{
			addEnemyToRow(Globals.ENEMY_ROW_1, Globals.GRID_SIZE * 7, Globals.ROW_1_ACTION_OFFSET, 1);
			addEnemyToRow(Globals.ENEMY_ROW_2, Globals.GRID_SIZE * 9, Globals.ROW_2_ACTION_OFFSET, -1);
			addEnemyToRow(Globals.ENEMY_ROW_3, Globals.GRID_SIZE * 11, Globals.ROW_3_ACTION_OFFSET, 1);
		}
		
		
		private function addEnemyToRow(row:FlxGroup, Y:Number, ActionOffset:Number, Movement:Number):void
		{
			if (row.countLiving() < Globals.NUM_ENEMIES)
			{
				var free:Boolean = true;
				// Need to add to the left most position if possible
				for (var i:int = 0; i < row.members.length; i++)
				{
					if (row.members[i] != null &&
						row.members[i].x == 0 &&
						row.members[i].alive)
					{
						free = false;
						break;
					}
				}
				if (free && Math.random() < 0.8)
				{
					var enemy:Enemy = row.recycle(Enemy) as Enemy;
					enemy.x = 0;
					enemy.y = Y;
					enemy.actionOffset = ActionOffset;
					enemy.movement = Movement;
					enemy.revive();
				}
			}
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			Globals.AVATAR.destroy();
		}
	}
}