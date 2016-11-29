package 
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import flash.filters.DropShadowFilter;
	
	
	
	
	/**
	 * ...
	 * @author zslavman
	 * фразы проигрываются через ф-цию для устранения наложения звуков
	 */
	

		 
	public class Bender extends MovieClip {
		
		
		private var Channel_1:SoundChannel = new SoundChannel();
		private var iron_hit:Sound = new _iron_hit();
		private var say_hello:Sound = new _say_hello();
		private var say_hey:Sound = new _say_hey();
		private var say_kidding:Sound = new _say_kidding();
		private var say_kickneck:Sound = new _say_kickneck();
		private var create_pop:Sound = new _create_pop();
		
		private var phrases_arr:Array = [];
		
		private var shadow: DropShadowFilter;
		private var hi_bender:Tween;
		
		private var Timer_Twink:Timer = new Timer (1000);
		private var kicks:uint = 0;
		
		public var allow_bender_hide:Boolean = false;
		
	
		
		
		
		public function Bender(stage:Stage){
		
			phrases_arr = [say_hello, say_hey, say_kidding, say_kickneck];
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, followCursor);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, bender_MOUSE_DOWN);
			Timer_Twink.addEventListener(TimerEvent.TIMER, func_Timer_Twink);
			Timer_Twink.start();
		
			this.x = 140; // x = 770
			hi_bender = new Tween (this, 'y', Strong.easeOut, 1200, 770, 0.5, true);
			PlaySound(0);
			Drop_Shadow();
		}
		
		
		
		 
		
		
		/*********************************************
		 *              Таймер моргания              *
		 *  динамически меняет свое время задержки   *
		 */ //****************************************
		private function func_Timer_Twink(event:Event):void {
			
			var tick:int = RAND(2, 5) * 1000;
			Timer_Twink.delay = tick;
			Twink();
		}
		
		
		
		

		
		/*********************************************
		 *                hit по бендеру             *
		 *                                           *
		 */ //****************************************
		public function bender_MOUSE_DOWN(event:MouseEvent):void {
			
			kicks++;
			iron_hit.play();
			
			if (kicks > 3 && kicks <= 7) {
				Twink();
				PlaySound(1);
			}
			else if (kicks > 7) {
				allow_bender_hide = true;	
				var rnd:int = RAND(1, 4);
				if (rnd == 4) return; 
				PlaySound(rnd);
				
			}
		}
		
		
		private function PlaySound(arg:uint):void {
		
			Channel_1.stop();
			Channel_1 = phrases_arr[arg].play();
			mouth.gotoAndPlay('bla-bla-bla');
		}
		
		
		
		
		
		/*********************************************
		 *                 Вращение глаз             *
		 *                                           *
		 */ //****************************************
		public function followCursor(event:MouseEvent):void {
			
			EyeRot(eye1);
			EyeRot(eye2);
		}
		
		public function EyeRot(mc:MovieClip):void {
			
			var dy:Number = mouseY - mc.y;
			var dx:Number  = mouseX - mc.x;
			var angle:Number  = Math.atan2(dy, dx) * 180 / Math.PI;
			mc.rotation = angle;
		}
		
		
		
		
		/*********************************************
		 *                   Моргание                *
		 *                                           *
		 */ //****************************************
		private function Twink():void {
			this.gotoAndPlay('twink');
		}
		
		
		
		/*********************************************
		 *       Отбрасывание тени при поялвении     *
		 *                                           *
		 */ //****************************************
		private function Drop_Shadow():void {
		
			shadow = new DropShadowFilter();
			shadow.distance = 6;
			shadow.angle = 90;
			shadow.blurX = shadow.blurY = 6;
			shadow.color = 0x000000;
			shadow.quality = 3; // 3 - HIGH
			shadow.alpha = 0.7;
			
			this.filters = [shadow];
		}
		
		
		public function destroy():void {
			
			create_pop.play();
			Channel_1.stop();
			Timer_Twink.reset();
			allow_bender_hide = false;
			kicks = 0;
		}
		
		// рандомайзер
		public function RAND(min:Number, max:Number):int {
	
			var arg: Number = (max - min) * Math.random() + min;
			return arg;
		}
	}
}