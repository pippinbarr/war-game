package
{
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	
	public class GameState extends FlxState
	{
		// Position and timing onstants
		private const AVATAR_START_X:Number = Globals.SCREEN_LEFT + Globals.TILE_SIZE;
		private const AVATAR_START_Y:Number = Globals.SCREEN_TOP + (Globals.SCREEN_HEIGHT/2);
		
		private const ENEMIES1_START_X:Number = Globals.SCREEN_LEFT + Globals.TILE_SIZE * 7;
		private const ENEMIES2_START_X:Number = Globals.SCREEN_LEFT + Globals.TILE_SIZE * 9;
		private const ENEMIES3_START_X:Number = Globals.SCREEN_LEFT + Globals.TILE_SIZE * 11;
		
		private const TANK_X:Number = Globals.SCREEN_LEFT + Globals.SCREEN_WIDTH - Assets.TANK_WIDTH - Globals.TILE_SIZE;
		private const TANK_Y:Number = Globals.SCREEN_TOP + (Globals.SCREEN_HEIGHT/2 - Globals.TILE_SIZE);
		
		private const TANK_EXPLOSION_X:Number = TANK_X - Globals.TILE_SIZE;
		private const TANK_EXPLOSION_Y:Number = TANK_Y - Globals.TILE_SIZE * 1;
		
		private const ENEMIES1_ACTION_OFFSET:Number = 30;
		private const ENEMIES2_ACTION_OFFSET:Number = 60;
		private const ENEMIES3_ACTION_OFFSET:Number = 90;
		
		private const TOTAL_TANK_WAR_ENEMIES:uint = 16;
		
		
		// War properties
		private const BATTLE_FATIGUE_KILL_COUNT:uint = 5;
		private const TANK_BATTLE_TRIGGER_KILL_COUNT:uint = 12;
		
		private var _score:uint = 0;
		private var _killCount:uint = 0;
		private var _tankWarKillCount:uint = 0;
		private var _totalKills:uint = 0;
		
		private var _tankIcons:FlxGroup;
		private var _nextIconX:Number;
		
		private var _scoreText:Text;
		
		
		// Game state properties
		private const START_UP:uint = 8;
		private const JINGLE:uint = 9;
		private const PRE_WAR:uint = 5;
		private const EXPLODING:uint = 6;
		private const WAR:uint = 0;
		private const AVATAR_HIT:uint = 7;
		private const PRE_EVAL:uint = 1;
		private const EVAL:uint = 2;
		private const POST_EVAL:uint = 3;
		private const WAR_OVER:uint = 4;
		
		private var _state:uint = START_UP;
		
		private const SOLDIER_WAR:uint = 0;
		private const TANK_WAR:uint = 1;
		
		private var _warState:uint = SOLDIER_WAR;
		
		// BG properties
		private var _handheld:FlxSprite;
		private var _buttonIndexes:Array = new Array(
			Keyboard.UP, Keyboard.DOWN, Keyboard.RIGHT, Keyboard.ENTER,
			Keyboard.A, Keyboard.B, Keyboard.C, Keyboard.D, Keyboard.E, Keyboard.F,
			Keyboard.G, Keyboard.H, Keyboard.I, Keyboard.J, Keyboard.K, Keyboard.L,
			Keyboard.M, Keyboard.N, Keyboard.O, Keyboard.P, Keyboard.Q, Keyboard.R,
			Keyboard.S, Keyboard.T, Keyboard.U, Keyboard.V, Keyboard.W, Keyboard.X,
			Keyboard.Y, Keyboard.Z, Keyboard.SPACE);
		private var _buttons:Array;
		
		// War properites
		private var _avatar:Avatar;
		private var _enemies1:FlxGroup;
		private var _enemies2:FlxGroup;
		private var _enemies3:FlxGroup;
		private var _tank:Tank;
		
		private var _avatarBullets:FlxGroup;
		private var _enemyBullets:FlxGroup;
		
		private var _tankExplosion:Explosion;
		
		// Evaluation properties
		private var _preEvalText:Text;
		private var _evalText:Text;
		private var _postEvalText:Text;
		private var _evalCounter:Text;
		
		private var _endText:Text;
		
		private var _preEvalString:String = "";
		
		// Timing
		private const PRE_EVAL_TIME:Number = 5;
		private const POST_EVAL_TIME:Number = 5;
		
		private var _evalTimer:FlxTimer = new FlxTimer();
		private var _warTimer:FlxTimer = new FlxTimer();
		private var _glitchTimer:FlxTimer = null;
		private var _fireTimer:FlxTimer = new FlxTimer();
		private var _soundTimer:FlxTimer = new FlxTimer();
		private var _endTimer:FlxTimer = new FlxTimer();
		
		// Glitches
		
		private const NUM_GLITCHES_INCREMENT:uint = 1;
		private const GLITCH_INDEX_INCREMENT:uint = 2;
		
		private var _glitchDelay:Number = 5;
		private var _glitchMinimum:Number = 10;
		private var _numTimerGlitches:Number = 1;
		
		// Start up
		private var _startText:Text;
		private var _jingleNotes:uint = 0;
		
		public function GameState()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFFFFFFFF;
			FlxG.volume = 0.1;
			FlxG.mouse.hide();
			
			_handheld = new FlxSprite(0,0,Assets.BACKGROUND_SS);
			add(_handheld);
			
			addButtons();
			
			// Set up the avatar
			_avatar = new Avatar(AVATAR_START_X, AVATAR_START_Y);
			
			// Set up the enemies
			_enemies1 = new FlxGroup();
			_enemies2 = new FlxGroup();
			_enemies3 = new FlxGroup();
			
			setupEnemies(_enemies1,ENEMIES1_START_X,1,ENEMIES1_ACTION_OFFSET);
			setupEnemies(_enemies2,ENEMIES2_START_X,-1,ENEMIES2_ACTION_OFFSET);
			setupEnemies(_enemies3,ENEMIES3_START_X,1,ENEMIES3_ACTION_OFFSET);
			
			// Set up the tank
			_tank = new Tank(TANK_X, TANK_Y);
			_tank.kill();
			
			// Add war elements
			add(_avatar);
			add(_enemies1);
			add(_enemies2);
			add(_enemies3);
			add(_tank);
			
			// Add explosion
			_tankExplosion = new Explosion(TANK_EXPLOSION_X,TANK_EXPLOSION_Y);
			_tankExplosion.kill();
			add(_tankExplosion);
			
			// Set up the bullets
			_avatarBullets = new FlxGroup();
			_enemyBullets = new FlxGroup();
			
			add(_avatarBullets);
			add(_enemyBullets);
			
			_scoreText = new Text(Globals.SCREEN_LEFT + Globals.SCREEN_WIDTH - 4*Globals.TILE_SIZE,Globals.SCREEN_TOP,Globals.SCREEN_WIDTH,"000");
			add(_scoreText);
			
			_tankIcons = new FlxGroup();
			_nextIconX = Globals.SCREEN_LEFT + Globals.SCREEN_WIDTH - 6 * Globals.TILE_SIZE;
			add(_tankIcons);
			
			// Set up the evaluation elements
			_preEvalText = new Text(
				Globals.SCREEN_LEFT + Globals.TILE_SIZE,
				Globals.SCREEN_TOP + Globals.TILE_SIZE,
				Globals.SCREEN_WIDTH - 2*Globals.TILE_SIZE,
				"");
			_evalText = new Text(
				Globals.SCREEN_LEFT + Globals.TILE_SIZE,
				Globals.SCREEN_TOP + Globals.TILE_SIZE,
				Globals.SCREEN_WIDTH - 2*Globals.TILE_SIZE,
				"");
			_postEvalText = new Text(
				Globals.SCREEN_LEFT + Globals.TILE_SIZE,
				Globals.SCREEN_TOP + Globals.TILE_SIZE,
				Globals.SCREEN_WIDTH - 2*Globals.TILE_SIZE,
				"");
			_evalCounter = new Text(
				Globals.SCREEN_LEFT + Globals.SCREEN_WIDTH - 4*Globals.TILE_SIZE,
				Globals.SCREEN_TOP + Globals.SCREEN_HEIGHT - Globals.TILE_SIZE,
				3 * Globals.TILE_SIZE,
				"");
			_startText = new Text(
				Globals.SCREEN_LEFT + Globals.TILE_SIZE,
				Globals.SCREEN_TOP,
				Globals.SCREEN_WIDTH,
				"PRESS START");
			
			
			add(_preEvalText);
			add(_postEvalText);
			add(_evalText);
			add(_evalCounter);
			add(_startText);
			
			
			_endText = new Text(
				Globals.SCREEN_LEFT + Globals.TILE_SIZE*3,
				Globals.SCREEN_TOP + (Globals.SCREEN_HEIGHT_IN_TILES/2)*Globals.TILE_SIZE - Globals.TILE_SIZE,
				Globals.SCREEN_WIDTH,
				"");
			
			_endText.visible = false;
			add(_endText);
			
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onEvalKeyDown);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP,onEvalKeyUp);

			_fireTimer.start(0.1,1);
			
			_state = START_UP;
			
			_enemies1.callAll("stop");
			_enemies2.callAll("stop");
			_enemies3.callAll("stop");
			
			var gameLength:Number = Math.random() * (5 * 60) + 10;
			_endTimer.start(gameLength,1,endGame);
		}
		

		private function endGame(t:FlxTimer):void
		{
			_state = WAR_OVER;
			
			if (_glitchTimer != null) _glitchTimer.stop();
			_evalTimer.stop();
			_fireTimer.stop();
			_soundTimer.stop();
			_warTimer.stop();
			
			this._startText.visible = false;
			this.setWarVisible(false);
			this.setPreEvalVisible(false);
			this.setPostEvalVisible(false);
			this.setEvalVisible(false);
			
			_endText.setAsString("WAR IS OVER");
			_endText.visible = true;
		}
		
		private function addButtons():void
		{
			_buttons = new Array();
			
			var up:FlxSprite = new FlxSprite(3 * Globals.TILE_SIZE,6 * Globals.TILE_SIZE - 2);
			up.loadGraphic(Assets.LARGE_BUTTON_SS,true,false,60,60);
			_buttons.push(up);
			add(up);
			
			var down:FlxSprite = new FlxSprite(3 * Globals.TILE_SIZE,12 * Globals.TILE_SIZE - 2);
			down.loadGraphic(Assets.LARGE_BUTTON_SS,true,false,60,60);
			_buttons.push(down);
			add(down);
			
			var fire:FlxSprite = new FlxSprite(FlxG.width - 6 * Globals.TILE_SIZE,12 * Globals.TILE_SIZE - 2);
			fire.loadGraphic(Assets.LARGE_BUTTON_SS,true,false,60,60);
			_buttons.push(fire);
			add(fire);
			
			var start:FlxSprite = new FlxSprite(FlxG.width - 6 * Globals.TILE_SIZE, 6 * Globals.TILE_SIZE - 2);
			start.loadGraphic(Assets.LARGE_BUTTON_SS,true,false,60,60);
			_buttons.push(start);
			add(start);
			
			var key:uint;
			var keySprite:FlxSprite;
			var currentX:Number = 9.5 * Globals.TILE_SIZE + 1;
			for (key = Keyboard.A; key <= Keyboard.M; key++)
			{
				keySprite = new FlxSprite(currentX, FlxG.height - 6*Globals.TILE_SIZE);
				keySprite.loadGraphic(Assets.SMALL_BUTTON_SS,true,false,20,20);
				_buttons.push(keySprite);
				add(keySprite);
				currentX += Globals.TILE_SIZE;
			}
			
			currentX = 9.5 * Globals.TILE_SIZE + 1;
			for (key = Keyboard.N; key <= Keyboard.Z; key++)
			{
				keySprite = new FlxSprite(currentX, FlxG.height - 4*Globals.TILE_SIZE);
				keySprite.loadGraphic(Assets.SMALL_BUTTON_SS,true,false,20,20);
				_buttons.push(keySprite);
				add(keySprite);
				currentX += Globals.TILE_SIZE;
			}
			
			var spaceSprite:FlxSprite = new FlxSprite(13.5 * Globals.TILE_SIZE + 1, FlxG.height - 2*Globals.TILE_SIZE);
			spaceSprite.loadGraphic(Assets.SPACE_BUTTON_SS,true,false,100,20);
			_buttons.push(spaceSprite);
			add(spaceSprite);
		}
		
		// setupEnemies
		//
		// Adds enemies randomly to a row until it is full
		
		private function setupEnemies(Enemies:FlxGroup,X:Number,Direction:int,ActionOffset:Number):void
		{
			while (Enemies.countLiving() < Globals.NUM_ENEMIES)
			{	
				// Choose a random Y position
				var enemyY:int = Globals.SCREEN_TOP + 
					2*Globals.TILE_SIZE + 
					Math.floor(Math.random() * (Globals.SCREEN_HEIGHT_IN_TILES - 4)) * Globals.TILE_SIZE;
				
				var free:Boolean = true;
				for (var i:int = 0; i < Enemies.members.length; i++)
				{
					if (Enemies.members[i] != null &&
						Enemies.members[i].y == enemyY &&
						Enemies.members[i].alive)
					{
						free = false;
						break;
					}
				}
				
				if (free)
				{
					var enemy:Enemy = Enemies.recycle(Enemy) as Enemy;
					enemy.y = enemyY;
					enemy.x = X;
					enemy.actionOffset = ActionOffset;
					enemy.setMovement(Direction);
					enemy.revive();
				}
			}
		}
		
		
		private function setupTankWar(t:FlxTimer):void
		{
			_killCount = 0;
			_tankWarKillCount = 0;
			
			_avatar.visible = true;
			_avatarBullets.callAll("kill");
			_avatarBullets.visible = true;
			
			setupEnemies(_enemies1,ENEMIES1_START_X,1,ENEMIES1_ACTION_OFFSET);
			setupEnemies(_enemies2,ENEMIES2_START_X,-1,ENEMIES2_ACTION_OFFSET);
			//setupEnemies(_enemies3,ENEMIES3_START_X,1,ENEMIES3_ACTION_OFFSET);
			
			_tank.visible = true;
			_tank.revive();
			
			_state = WAR;
			_warState = TANK_WAR;
		}
		
		
		private function setupSoldierWar(t:FlxTimer):void
		{
			_killCount = 0;
			
			_avatar.visible = true;
			_avatarBullets.callAll("kill");
			_avatarBullets.visible = true;
			
			setupEnemies(_enemies1,ENEMIES1_START_X,1,ENEMIES1_ACTION_OFFSET);
			setupEnemies(_enemies2,ENEMIES2_START_X,-1,ENEMIES2_ACTION_OFFSET);
			setupEnemies(_enemies3,ENEMIES3_START_X,1,ENEMIES3_ACTION_OFFSET);
			
			_tank.visible = false;
			
			_state = WAR;
			_warState = SOLDIER_WAR;
		}
		
		
		public override function update():void
		{
			super.update();
			
			Globals.frames++;
			
			if (FlxG.keys.UP)
			{
				_buttons[_buttonIndexes.indexOf(Keyboard.UP)].frame = 1;
			}
			else
			{
				_buttons[_buttonIndexes.indexOf(Keyboard.UP)].frame = 0;
			}
			if (FlxG.keys.DOWN)
			{
				_buttons[_buttonIndexes.indexOf(Keyboard.DOWN)].frame = 1;
			}
			else
			{
				_buttons[_buttonIndexes.indexOf(Keyboard.DOWN)].frame = 0;
			}
			if (FlxG.keys.RIGHT)
			{
				_buttons[_buttonIndexes.indexOf(Keyboard.RIGHT)].frame = 1;
			}
			else
			{
				_buttons[_buttonIndexes.indexOf(Keyboard.RIGHT)].frame = 0;
			}
			if (FlxG.keys.ENTER)
			{
				_buttons[_buttonIndexes.indexOf(Keyboard.ENTER)].frame = 1;
			}
			else
			{
				_buttons[_buttonIndexes.indexOf(Keyboard.ENTER)].frame = 0;
			}
			
			
			if (_state == WAR_OVER)
				return;
			
			
			if (_state == START_UP)
			{
				if (Globals.frames % 20 == 0)
				{
					_avatar.visible = !_avatar.visible;
					_enemies1.visible = !_enemies1.visible;
					_enemies2.visible = !_enemies2.visible;
					_enemies3.visible = !_enemies3.visible;
					_scoreText.visible = !_scoreText.visible;
					_startText.visible = !_startText.visible;
				}
				if (FlxG.keys.justPressed("ENTER"))
				{
					startGame();
				}
				return;
			}
			
			if (_state == JINGLE)
			{
				return;
			}
			
			// Add enemies if we're on the clock
			if (Globals.frames % Globals.ENEMY_ACTION_RATE == 0)
			{
				addEnemies();
			}
			
			if (_state == EXPLODING && Globals.frames % 8 == 0)
			{
				_tankExplosion.visible = !_tankExplosion.visible;
				if (_tankExplosion.visible)
				{
					FlxG.play(Assets.FIRE_SOUND);
					_soundTimer.start(0.1,1,replayFireSound);
				}
			}
			else if (_state == AVATAR_HIT && Globals.frames % 6 == 0)
			{
				_avatar.visible = !_avatar.visible;
				if (!_avatar.visible)
				{
					FlxG.play(Assets.DIE_SOUND);
				}
			}
			
			if (_state != AVATAR_HIT)
			{
				handleWarInput();
				handleEnemyFire();
			}
			
			
			checkBullets();
			
			
			
		}
		
		
		private function replayFireSound(t:FlxTimer):void
		{
			FlxG.play(Assets.FIRE_SOUND);
		}
		
		private function startGame():void
		{
			_avatar.visible = true;
			_enemies1.visible = true;
			_enemies2.visible = true;
			_enemies3.visible = true;
			_scoreText.visible = true;
			_startText.visible = false;
			_state = JINGLE;
			FlxG.play(Assets.STARTUP_SOUND);
			_soundTimer.start(2,1,jingleDone);
		}
		
		
		
		private function jingleDone(t:FlxTimer):void
		{
			_enemies1.callAll("start");
			_enemies2.callAll("start");
			_enemies3.callAll("start");
			_state = WAR;
		}
		
		
		private function handleWarInput():void
		{
			if (!_avatar.visible) return;
			
			if (FlxG.keys.justPressed("UP") && _avatar.y > Globals.SCREEN_TOP + Globals.TILE_SIZE)
			{
				_avatar.y -= Globals.TILE_SIZE;
			}
			else if (FlxG.keys.justPressed("DOWN") && _avatar.y + _avatar.height < Globals.SCREEN_TOP + Globals.SCREEN_HEIGHT - Globals.TILE_SIZE)
			{
				_avatar.y += Globals.TILE_SIZE;
			}
			else if (FlxG.keys.justPressed("RIGHT") && _fireTimer.finished)
			//else if (FlxG.keys.ALT && _fireTimer.finished)
			{
				FlxG.play(Assets.FIRE_SOUND);
				
				// Fire a bullet
				var bullet:Bullet = _avatarBullets.recycle(Bullet) as Bullet;
				bullet.revive();
				bullet.y = _avatar.y;
				bullet.x = _avatar.x + Globals.TILE_SIZE;
				bullet.vx = Globals.BULLET_SPEED;
				bullet.setType(Assets.AVATAR_BULLET_FRAME);
				_fireTimer.start(0.4,1);
			}
		}
		
		
		private function handleEnemyFire():void
		{
			if (_state == AVATAR_HIT || !_avatar.visible)
				return;
			
			handleEnemyRowFire(_enemies1);
			handleEnemyRowFire(_enemies2);
			handleEnemyRowFire(_enemies3);
			
			if (_tank.visible)
			{
				if (_tank.isFireFrame() && _state != EXPLODING && _state != AVATAR_HIT)
				{
					var bullet:Bullet = _enemyBullets.recycle(Bullet) as Bullet;
					bullet.revive();
					bullet.y = TANK_Y + Math.floor(Math.random() * (Assets.TANK_HEIGHT/Globals.TILE_SIZE)) * Globals.TILE_SIZE;
					bullet.x = TANK_X - Globals.TILE_SIZE;
					bullet.vx = -Globals.SHELL_SPEED;
					bullet.setType(Assets.TANK_SHELL_FRAME);
				}
			}
		}
		
		
		private function handleEnemyRowFire(row:FlxGroup):void
		{
			for (var i:int = 0; i < _enemies1.members.length; i++)
			{
				if (row.members[i] != null &&
					row.members[i].alive &&
					row.members[i].isFireFrame())
				{
					if (Math.random() <= 1)				
					{
						var bullet:Bullet = _enemyBullets.recycle(Bullet) as Bullet;
						bullet.revive();					
						bullet.y = row.members[i].y;
						bullet.x = row.members[i].x - Globals.TILE_SIZE;
						bullet.vx = -Globals.BULLET_SPEED;
						bullet.setType(Assets.ENEMY_BULLET_FRAME);
					}
				}
			}
		}
		
		
		private function checkBullets():void
		{
			if (_state != AVATAR_HIT && _avatar.visible)
			{
				FlxG.overlap(_tank, _avatarBullets, tankHit);
				FlxG.overlap(_enemies1, _avatarBullets, enemyHit);
				FlxG.overlap(_enemies2, _avatarBullets, enemyHit);
				FlxG.overlap(_enemies3, _avatarBullets, enemyHit);
				FlxG.overlap(_avatar, _enemyBullets, avatarHit);
			}
			
			_avatarBullets.callAll("checkOnScreen");
			_enemyBullets.callAll("checkOnScreen");
		}
		
		
		private function avatarHit(avatar:FlxObject, bullet:FlxObject):void
		{			
			if (_state == AVATAR_HIT) return;
			if (_state == JINGLE) return;
			
			_state = AVATAR_HIT;
			_enemyBullets.callAll("stop");
			_avatarBullets.callAll("stop");
			_enemies1.callAll("stop");
			_enemies2.callAll("stop");
			_enemies3.callAll("stop");
			_warTimer.start(1.5,1,postAvatarHit);
		}
		
		
		private function postAvatarHit(t:FlxTimer):void
		{
			_enemyBullets.callAll("kill");
			_avatar.visible = false;
			//_avatar.kill();
			_avatarBullets.callAll("kill");
			_enemies1.callAll("start");
			_enemies2.callAll("start");
			_enemies3.callAll("start");
			
			// Set up evaluation
			
			setWarVisible(false);
			_state = JINGLE;
			_preEvalString = Globals.PRE_EVAL_INJURY_TEXT;
			_warTimer.start(1,1,switchToPreEval);
		}
		
		
		private function enemyHit(enemy:FlxObject, bullet:FlxObject):void
		{
			FlxG.play(Assets.FIRE_SOUND);
			
			(enemy as Enemy).hit();
			bullet.kill();
			
			_killCount++;
			_totalKills++;
			_score++;
			if (_warState == TANK_WAR)
				_tankWarKillCount++;
			
			if (_score > 999)
				_score = 0;
			
			var scoreString:String = _score.toString();
			var zerosNeeded:int = 3 - scoreString.length;
			while (zerosNeeded > 0)
			{
				scoreString = "0" + scoreString;
				zerosNeeded--;
			}
			_scoreText.setAsString(scoreString);
			
			// Check if battle fatigue should kick in
			if (_totalKills % this.TANK_BATTLE_TRIGGER_KILL_COUNT == 0 && _warState != TANK_WAR)
			{
				_state = PRE_WAR;
				
				_avatar.visible = false;
				_avatarBullets.visible = false;
				
				_enemies1.callAll("kill");
				_enemies2.callAll("kill");
				_enemies3.callAll("kill");
				_enemyBullets.callAll("kill");
				
				_warTimer.start(1,1,setupTankWar);
			}
			else if (_killCount >= BATTLE_FATIGUE_KILL_COUNT)
			{
				//_avatar.kill();
				_avatar.visible = false;
				_avatarBullets.callAll("kill");
				
				_killCount = 0;
				
				// Set up battle fatigue evaluation
				setWarVisible(false);
				_preEvalString = Globals.PRE_EVAL_KILLS_TEXT;
				_state = JINGLE;
				_warTimer.start(1,1,switchToPreEval);
			}
		}
		
		
		private function tankHit(tank:FlxObject, bullet:FlxObject):void
		{
			bullet.kill();
			_tank.hit();
			
			if (_tank.isDead() && _warState == TANK_WAR)
			{								
				_avatar.visible = false;
				
				_enemies1.callAll("kill");
				_enemies2.callAll("kill");
				_enemies3.callAll("kill");
				_enemyBullets.callAll("kill");
				_avatarBullets.callAll("kill");
				
				_score += 10;
				
				if (_score > 999)
					_score = 0;
				
				var scoreString:String = _score.toString();
				var zerosNeeded:int = 3 - scoreString.length;
				while (zerosNeeded > 0)
				{
					scoreString = "0" + scoreString;
					zerosNeeded--;
				}
				_scoreText.setAsString(scoreString);
				
				_warTimer.start(2,1,postExplosion);	
				
				_state = EXPLODING;
				_tankExplosion.revive();
			}
			else
			{
				_tank.flicker();
			}
		}
		
		
		private function postExplosion(t:FlxTimer):void
		{			
			var tankIcon:FlxSprite = new FlxSprite(_nextIconX,Globals.SCREEN_TOP,Assets.TANK_ICON_SS);
			_tankIcons.add(tankIcon);
			_nextIconX -= Globals.TILE_SIZE;
			
			_tank.kill();
			_tankExplosion.kill();
			_state = PRE_WAR;
			
			_warTimer.start(1,1,setupSoldierWar);
		}
		
		
		
		
		
		private function addEnemies():void
		{
			if (_state == PRE_WAR || _state == EXPLODING) return;
			
			if (_warState == TANK_WAR &&
				_enemies1.countLiving() + 
				_enemies2.countLiving() + 
				_enemies3.countLiving() + 
				_tankWarKillCount >= TOTAL_TANK_WAR_ENEMIES)
				return;
			
			addEnemyToRow(_enemies1,ENEMIES1_START_X,1,ENEMIES1_ACTION_OFFSET);
			addEnemyToRow(_enemies2,ENEMIES2_START_X,-1,ENEMIES2_ACTION_OFFSET);
			if (_warState == SOLDIER_WAR)
				addEnemyToRow(_enemies3,ENEMIES3_START_X,1,ENEMIES3_ACTION_OFFSET);
		}
		
		
		private function addEnemyToRow(Enemies:FlxGroup,X:Number,Direction:int,ActionOffset:Number):void
		{
			if (Enemies.countLiving() < Globals.NUM_ENEMIES)
			{				
				var free:Boolean = true;
				for (var i:int = 0; i < Enemies.members.length; i++)
				{
					if (Enemies.members[i] != null &&
						Enemies.members[i].y == Globals.SCREEN_TOP + Globals.TILE_SIZE &&
						Enemies.members[i].alive)
					{
						free = false;
						break;
					}
				}
				
				if (free)
				{
					var enemy:Enemy = Enemies.recycle(Enemy) as Enemy;
					enemy.y = Globals.SCREEN_TOP + Globals.TILE_SIZE;
					enemy.x = X;
					enemy.actionOffset = ActionOffset;
					enemy.setMovement(Direction);
					enemy.revive();
				}
			}
		}
		
		
		
		
		
		////////////////
		// EVALUATION //
		////////////////
		
		
		private function switchToPreEval(t:FlxTimer = null):void
		{
			_preEvalText.setAsString(_preEvalString);
			
			setWarVisible(false);
			_tank.visible = false;
			setPreEvalVisible(true);
			_state = PRE_EVAL;
			
			_evalTimer.start(PRE_EVAL_TIME,1,switchToEval);
		}
		
		
		private function switchToEval(t:FlxTimer):void
		{			
			setEvalQuestion();
			setEvalCounter();
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
			
			_evalTimer.start(POST_EVAL_TIME,1,blankAfterPostEval);
			
		}
		
		
		private function blankAfterPostEval(t:FlxTimer):void
		{
			addGlitch();
			setPostEvalVisible(false);
			
			_state = JINGLE;
			
			if (_warState == WAR)
				_evalTimer.start(1,1,switchToWar);
			else if (_warState == TANK_WAR)
				_evalTimer.start(1,1,switchToTankWar);
		}
		
		private function switchToWar(t:FlxTimer):void
		{
			_enemyBullets.callAll("kill");
			setPostEvalVisible(false);
			setWarVisible(true);
			//_avatar.revive();
			_avatar.visible = true;
			_state = WAR;
		}
		
		
		private function switchToTankWar(t:FlxTimer):void
		{
			_enemyBullets.callAll("kill");
			setPostEvalVisible(false);
			setWarVisible(true);
			_tank.visible = true;
			//_avatar.revive();
			_avatar.visible = true;
			_state = WAR;
		}
		
		
		private function setEvalQuestion():void
		{
			_evalText.setAsString(Globals.EVAL_QUESTIONS[Math.floor(Math.random() * Globals.EVAL_QUESTIONS.length)]);
		}
		
		
		private function setEvalCounter():void
		{
			var evalCounterString:String = Globals.EVAL_MAX_CHARS.toString();
			while (evalCounterString.length < 3)
			{
				evalCounterString = "0" + evalCounterString;
			}
			_evalCounter.setAsString(evalCounterString);
		}
		
		
		private function setPostEvalText():void
		{
			_postEvalText.setAsString(Globals.POST_EVAL_TEXT);
		}
		
		
		private function setWarVisible(value:Boolean):void
		{
			_avatar.visible = value;
			_enemies1.visible = value;
			_enemies2.visible = value;
			_enemies3.visible = value;
			_avatarBullets.visible = value;
			_enemyBullets.visible = value;
			_scoreText.visible = value;
			_tankIcons.visible = value;
		}
		
		
		private function setPreEvalVisible(value:Boolean):void
		{
			_preEvalText.visible = value;
		}
		
		
		private function setEvalVisible(value:Boolean):void
		{
			_evalText.visible = value;
			_evalCounter.visible = value;
		}
		
		
		private function setPostEvalVisible(value:Boolean):void
		{
			_postEvalText.visible = value;
		}
		
		
		private function addGlitch():void
		{	
			Assets.glitchMaxIndex += GLITCH_INDEX_INCREMENT;
			if (Assets.glitchMaxIndex > Assets.GLITCHABLES) Assets.glitchMaxIndex = Assets.GLITCHABLES;
			
			var numGlitches:int = Assets.glitchMaxIndex; // + NUM_GLITCHES_INCREMENT;
			
			if (numGlitches > Assets.GLITCHABLES) 
			{
				numGlitches = Assets.GLITCHABLES;
				
				if (_glitchTimer == null)
				{
					_glitchTimer = new FlxTimer();
					_glitchTimer.start(Math.random() * _glitchDelay + _glitchMinimum, 1, addTimerGlitch);
				}
				else
				{
					_glitchDelay -= 0.5;
					if (_glitchDelay < 0.5) _glitchDelay = 0.5;
					_glitchMinimum -= 0.5;
					if (_glitchMinimum < 0.5) _glitchDelay = 0.5;
				}
			}
			
			
			for (var i:int = 0; i < numGlitches; i++)
			{
				//var glitchIndex:uint = Math.floor(Math.random() * Assets.glitchMaxIndex);
				
				// Select a random new spritesheet to use for this index
//				var newSpriteSheetIndex:int = Math.floor(Math.random() * Assets.GLITCHABLES);
//				
//				// Make it negative half the time (for out of sequence displays)
//				if (Math.random() < 0.8)
//					newSpriteSheetIndex *= -1;
				
				var randomIndex:uint = Math.floor(Math.random() * Assets.glitchMaxIndex);
				if (randomIndex == Assets.LETTER)
					Assets.glitchChance[randomIndex] += Assets.LETTER_GLITCH_CHANCE_INCREASE;
				else
					Assets.glitchChance[randomIndex] += Assets.GLITCH_CHANCE_INCREASE;

//				if (i == Assets.LETTER)
//				{
//					Assets.LETTER_GLITCH_CHANCE += 0.2;
//				}
//				else
//				{
//					Assets.graphics[i] = newSpriteSheetIndex;
//				}
			}			
		}
		
		
		private function addTimerGlitch(t:FlxTimer):void
		{
			for (var i:int = 0; i < _numTimerGlitches; i++)
			{
				if (Math.random() < 0.5)
				{
					// Image glitch
					
					var randomIndex:uint = Assets.graphics.length * Math.random();
					
					// Select a random new spritesheet to use for this index
					var newSpriteSheetIndex:int = Math.floor(Math.random() * Assets.GLITCHABLES);
					
					// Make it negative half the time (for out of sequence displays)
					if (Math.random() < 1)
						newSpriteSheetIndex *= -1;
					

					if (randomIndex == Assets.LETTER)
						Assets.glitchChance[randomIndex] += Assets.LETTER_GLITCH_CHANCE_INCREASE;
					else
						Assets.glitchChance[randomIndex] += Assets.GLITCH_CHANCE_INCREASE;
					
					
					if (randomIndex == Assets.AVATAR)
						_avatar.setSpriteSheet();
					else if (randomIndex == Assets.ENEMY)
					{
						for (var j:int = 0; j < _enemies1.members.length; j++)
						{
							if (_enemies1.members[j] != null &&
								_enemies1.members[j].alive)
								(_enemies1.members[j] as Enemy).setSpriteSheet();
						}
					}
					else if (randomIndex == Assets.BULLET)
					{
						for (var k:int = 0; k < _avatarBullets.members.length; k++)
						{
							if (_avatarBullets.members[k] != null &&
								_avatarBullets.members[k].alive)
								(_avatarBullets.members[k] as Bullet).setSpriteSheet();
						}
						for (var l:int = 0; l < _enemyBullets.members.length; l++)
						{
							if (_enemyBullets.members[l] != null &&
								_enemyBullets.members[l].alive)
								(_enemyBullets.members[l] as Bullet).setSpriteSheet();
						}
					}
					else if (randomIndex == Assets.LETTER)
					{
						for (var m:int = 0; m < _preEvalText.members.length; m++)
						{
							if (_preEvalText.members[m] != null &&
								_preEvalText.members[m].alive)
								(_preEvalText.members[m] as Letter).setSpriteSheet();
						}
						for (var n:int = 0; n < _evalText.members.length; n++)
						{
							if (_evalText.members[n] != null &&
								_evalText.members[n].alive)
								(_evalText.members[n] as Letter).setSpriteSheet();
						}
						for (var p:int = 0; p < _postEvalText.members.length; p++)
						{
							if (_postEvalText.members[p] != null &&
								_postEvalText.members[p].alive)
								(_postEvalText.members[p] as Letter).setSpriteSheet();
						}
					}
					else if (randomIndex == Assets.TANK)
					{
						_tank.setSpriteSheet();
					}
					else if (randomIndex == Assets.TANK_EXPLOSION)
					{
						_tankExplosion.setSpriteSheet();
					}
					
				}
				else
				{
					// Super impose glitch
					if (_state == WAR)
					{
						this.setEvalVisible(Math.random() < 0.5);
						this.setPreEvalVisible(Math.random() < 0.5);
						this.setPostEvalVisible(Math.random() < 0.5);
					}
					else if (_state == PRE_EVAL)
					{
						this.setWarVisible(Math.random() < 0.5);
						this._tank.visible = Math.random() < 0.5;
						this.setWarVisible(Math.random() < 0.5);
						this.setEvalVisible(Math.random() < 0.5);
						this.setPostEvalVisible(Math.random() < 0.5);
					}
					else if (_state == EVAL)
					{
						this.setWarVisible(Math.random() < 0.5);
						this._tank.visible = Math.random() < 0.5;
						this.setWarVisible(Math.random() < 0.5);
						this.setPreEvalVisible(Math.random() < 0.5);
						this.setPostEvalVisible(Math.random() < 0.5);
					}
					else if (_state == POST_EVAL)
					{
						this.setWarVisible(Math.random() < 0.5);
						this._tank.visible = Math.random() < 0.5;
						this.setWarVisible(Math.random() < 0.5);
						this.setEvalVisible(Math.random() < 0.5);
						this.setPreEvalVisible(Math.random() < 0.5);
					}
				}
			}
			
			_numTimerGlitches++;
			_glitchTimer.start(Math.random() * _glitchDelay + _glitchMinimum, 1, addTimerGlitch);
		}
		
		
		private function onEvalKeyDown(e:KeyboardEvent):void
		{	
			var keyIndex:int = _buttonIndexes.indexOf(e.keyCode);
			if (keyIndex != -1)
			{
				_buttons[keyIndex].frame = 1;
			}
			
			if (_state != EVAL) return;
			
			if (e.keyCode == Keyboard.ENTER)
			{
				switchToPostEval();
			}
			
			var char:String = String.fromCharCode(e.charCode);
			char = char.toUpperCase();
			
			if (_evalText.addChar(char))
			{
				var evalCounterString:String = (Globals.EVAL_MAX_CHARS - _evalText.getAddedChars()).toString();
				while (evalCounterString.length < 3)
				{
					evalCounterString = "0" + evalCounterString;
				}
				_evalCounter.setAsString(evalCounterString);
			}
			
			if (_evalText.getAddedChars() == Globals.EVAL_MAX_CHARS)
			{
				switchToPostEval();
			}
		}
		
		
		private function onEvalKeyUp(e:KeyboardEvent):void
		{
			var keyIndex:int = _buttonIndexes.indexOf(e.keyCode);
			if (keyIndex != -1)
			{
				_buttons[keyIndex].frame = 0;
			}
		}
		
		
		
		
		
		public override function destroy():void
		{
			super.destroy();
			
			_avatar.destroy();
			_tank.destroy();
			_enemies1.destroy();
			_enemies2.destroy();
			_enemies3.destroy();
			_avatarBullets.destroy();
			_enemyBullets.destroy();
			_preEvalText.destroy();
			_evalText.destroy();
			_postEvalText.destroy();
			_evalTimer.destroy();
		}
	}
}