package 
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.media.Sound;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import flash.filters.DropShadowFilter;
	
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	

		 
	public class Bender extends MovieClip {
	
		
		private var create_pop:Sound = new _create_pop();
		private var shadow: DropShadowFilter;
		public var hi_bender:Tween;
		
	
		
		public function Bender(stage:Stage){
		
			stage.addEventListener(MouseEvent.MOUSE_MOVE, followCursor);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, bender_MOUSE_DOWN);
		
			this.x = 140;
			this.y = 1200; // 770
			hi_bender = new Tween (this, 'y', Strong.easeOut, 1200, 770, 0.5, true);
			create_pop.play();
			Drop_Shadow();
		}
		
		
		
		
		public function bender_MOUSE_DOWN(event:MouseEvent):void {
			
			create_pop.play();
		}
		
		
		
		public function Drop_Shadow():void {
		
			shadow = new DropShadowFilter();
			shadow.distance = 6;
			shadow.angle = 90;
			shadow.blurX = shadow.blurY = 6;
			shadow.color = 0x000000;
			shadow.quality = 3; // 3 - HIGH
			shadow.alpha = 0.7;
			
			this.filters = [shadow];
		}
		
		
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
		
		
		
		
		
		
	}
}