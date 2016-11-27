package
{
	import About_Window;
	import flash.display.MovieClip;
	import flash.geom.Point;

	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.display.Stage;
	
	import fl.motion.Color;
	import com.google.analytics.GATracker;
	
	/**
	 * ...
	 * @author zslavman
	 * http://www.cyberforum.ru/actionscript/thread577183.html
	 */
	
	 
	public class Controller extends Sprite {
		
		private var model:Model;
		private var view:View;
		private var controller:Controller;
		private var STAGE:Stage;
		private var trick:Secret;
		private var tracker:GATracker;

		private var firmware:Firmware;
		private var about_window:About_Window;
		private var bender:Bender;
		
		
		private var langArr:Array = [];
		private var offset:Number;
		private var rotate_limit:Number = 150;// лимит поворота ручки контраст в градусах
		private var final_rotation:Number = 0;
		
		private var charge_min:int = 30; // пределы заряда в процентах
		private var charge_max:int = 100;
		
		private var DisplayObjects:Array = []; // массив дисплейобъектов которые нужно блюрить
		private var blurFilter:BlurFilter;
		
		private var opacity_tween:Tween;
		private var moveX_tween:Tween;
		private var moveY_tween:Tween;
		private var opacity_dur:Number = 0.25;
		
		private var c:Color = new Color();
		


		
		
		
		public function Controller(_stage:Stage, _view:View, _model:Model, _tracker:GATracker) {
			
			tracker = _tracker;
			controller = this;
			view = _view;
			model = _model;
			langArr = Model.langArr;
			STAGE = _stage;
			
			DisplayObjects = [view];
			
			view.addEventListener(EventTypes.INFO_CLICK, ShowInfo);
			view.addEventListener(EventTypes.POWER_CLICK, Power);
			view.addEventListener(EventTypes.LIGHT_CLICK, Light);
			view.addEventListener(EventTypes.CONTRAST_MOUSE_DOWN, ContrastMouseDown);
			
			view.addEventListener(EventTypes.KEY_ESC_ENTER, Key_Esc_or_Enter);
			
			view.addEventListener(EventTypes.ADD_BENDER, add_Bender);
			
			view.addEventListener(Event.ENTER_FRAME, func_ENTER_FRAME); // для слежки mouse distance
			
			
			//для событий OVER, OUT нужно указывать конкретную цель
			view.DC_plug.addEventListener(EventTypes.CHARGER_TARGET_OVER, charge_Over); 
			view.DC_plug.addEventListener(EventTypes.TARGET_OUT, charge_Out);
			
			view.addEventListener(EventTypes.TARGET_CLICK, charge_MOUSE_DOWN);
			
			var charge:int = RAND(charge_min, charge_max);
			model.charge_level = charge;
		}
		
		

		
		
		
		
		
		
		
		
		/*********************************************
		 *               Двигание bender             *
		 *                                           *
		 */ //****************************************
		private function func_ENTER_FRAME(event:Event):void {
		
			if (bender != null && bender.allow_bender_hide) {
			
				var bender_placement:Point = new Point(bender.x, bender.y);
				var cursor_location:Point = new Point(mouseX, mouseY);
				
				var distance:Number = Point.distance(bender_placement, cursor_location);
				
				if (distance < 280) {
					if (bender.y < 1200) { // задвигание
						bender.y += 10;
						//trace ("bender.y = " + bender.y, "distance = " + distance);
					}
				}
				else if (distance >= 380){
					if (bender.y > 770) bender.y -= 10; // выдвигание
				}
			}
			//event.updateAfterEvent();
		}
		
		
		
		
		
		public function add_Bender(event:Event):void {
			if (bender == null && !model.show_tips) {
				
				tracker.trackPageview("Trick found");
				bender = new Bender(STAGE);
				// коррекция цвета мувиклипа
				c.setTint(002600, 0.08);
				bender.transform.colorTransform = c;
				view.addChild(bender);
				
				trick = new Secret();
				trick.x = 620;
				trick.y = 715;
				trick.txt.text = Model.langArr[43][model.LANG];
				view.addChild(trick);
				var dissolve_trick:Tween = new Tween (trick, 'alpha', None.easeInOut, 1, 0, 3, true);
			}
			else if (bender != null){
				bender.destroy();
				view.removeChild(bender);
				bender = null;
			}
		}


		
		
		
		/*********************************************
		 *         Наведение мыши на зарядку         *
		 *                                           *
		 */ //****************************************
		public function charge_Over(event:Event):void {
			if (!model.charge_connected) {
				Opacity();
			}
		}
		public function charge_Out(event:Event):void {
			allTweenStop();
			view.charging_plug.alpha = 0;
		}
		public function charge_MOUSE_DOWN(event:Event):void {
			
			// вынимание зарядки
			if (model.charge_connected) {
				//Opacity();
				view.charging_pluged.visible = false;
				model.charge_connected = false;
				if (firmware && model.loading_ready) {
					firmware.Screen_init();
					firmware.Timer_Deviation.reset();// если вынимать сразу же после вставляния
					firmware.pre_charge_num = 0;
				}
			}
			// подключение зарядки
			else if (!model.charge_connected){
				allTweenStop();
				view.charging_plug.alpha = 0;
				view.charging_pluged.visible = true;
				model.charge_connected = true;
				if (firmware && model.loading_ready) firmware.Timer_Deviation.start();
			}
		}
		

		public function Opacity():void {
			opacity_tween = new Tween (view.charging_plug, "alpha", None.easeOut, 0, 0.6, opacity_dur, true);
			moveX_tween = new Tween (view.charging_plug, "x", Strong.easeOut, 1094, 1006, opacity_dur, true);
			moveY_tween = new Tween (view.charging_plug, "y", Strong.easeOut, 340, 372, opacity_dur, true);
		}
		public function allTweenStop():void {
			opacity_tween.stop();
			moveX_tween.stop();
			moveY_tween.stop();
		}
		
		
		/*********************************************
		 *              Ecc / Enter                  *
		 *                                           *
		 */ //****************************************
		public function Key_Esc_or_Enter(event:Event):void {
		
			if (about_window != null) {
			about_window.ok_button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
			else view.dispatchEvent(new Event (EventTypes.INFO_CLICK));
		}
		
		

		
		/*********************************************
		 *              Рукоятка контраста           *
		 *                                           *
		 */ //****************************************
		public function ContrastMouseDown(event:Event):void {
		
			view.addEventListener(EventTypes.CONTRAST_MOUSE_MOVE, ContrastMouseMove);
			view.addEventListener(EventTypes.CONTRAST_MOUSE_UP, ContrastMouseUp);
			Rotate(view.mouseX, view.mouseY, true, view.contrast_handle);
		}
			
		public function ContrastMouseMove(event:Event):void {

			final_rotation = Rotate(view.mouseX, view.mouseY, false, view.contrast_handle); // получаем в градусах

			// установка видимости contrastMax_scr (нормализованная)
			if (final_rotation >= 0) {
				model.ScreenALPHA = final_rotation / rotate_limit;
				view.LCD.contrastMax_scr.alpha = model.ScreenALPHA;
				view.container.alpha = 1; // поправка в случае перескока мышки
			}
			else if (final_rotation < 0) {
				view.container.alpha = 1 - Math.abs(final_rotation / rotate_limit);
				view.LCD.contrastMax_scr.alpha = 0; // поправка в случае перескока мышки
			}
		}
		
		public function ContrastMouseUp(event:Event):void {
		
			view.removeEventListener(EventTypes.CONTRAST_MOUSE_MOVE, ContrastMouseMove);
			view.removeEventListener(EventTypes.CONTRAST_MOUSE_UP, ContrastMouseUp);
		}
		
		
		// ф-ция поворота Rotate(mouseX, mouseY, флаг начала повророта, объект поворота);
		public function Rotate(angX:Number, angY:Number, begin:Boolean, obj:MovieClip):Number {
		
			var output_number:Number;
			var dx: Number = angX - obj.x;
			var dy: Number = angY - obj.y;
			var ang1:Number = Math.atan2(dy, dx) * 180 / Math.PI;
			
			if (begin) {
				offset = ang1;
				output_number = 0;
			}
			
			else if (!begin) {
				
				obj.rotation += ang1 - offset;
				
				var rot2:Number = obj.rotation;
				if (rot2 > rotate_limit) {
					rot2 = rotate_limit;
					obj.rotation = rotate_limit;
				}
				else if (rot2 < -rotate_limit) {
					rot2 = -rotate_limit;
					obj.rotation = -rotate_limit;
				}
				output_number = obj.rotation;
				offset = ang1;
			}
			return output_number;
		}
		
		
		
		
		
		
		
		
		/*********************************************
		 *              Кнопка подсветки             *
		 *                                           *
		 */ //****************************************
		public function Light(event:Event):void{ 
        
			// если прибор включен
			if (model.TURNED_ON) {
				if (!model.LIGHT_ON) { // если подсветка выключена
					view.LCD.gotoAndStop('frame_on');
					model.LIGHT_ON = true;
				}
				else if (model.LIGHT_ON) { // если подсветка включена
					view.LCD.gotoAndStop('frame_off');
					model.LIGHT_ON = false;
				}
			} 
        }
		
		
		
		

		
		
		/*********************************************
		 *              Кнопка "Info"                *
		 *                                           *
		 */ //****************************************
		public function ShowInfo(event:Event):void {
			
			if (about_window == null) {	
				about_window = new About_Window(model, controller);
				addChild(about_window); // только в отображаемый класс можно добавлять чайлд
				Blur('forward');
			}
		}
		
		public function RemoveAboutWindow():void {
		
			if (about_window != null) {
				removeChild(about_window);
				about_window = null;
				Blur('revers');
				//NOTE: принудительная установка фокуса для возможности послед. нажатия Enter/Esc
				stage.focus = view.button_sync_up;
			}
		}
		
	
		
		
		
		
		
		/*********************************************
		 *           Тумблер "ВКЛ./ВЫКЛ"             *
		 *                                           *
		 */ //****************************************
		public function Power(event:Event):void {
		
			// включение
			if (!model.TURNED_ON) {
				view.power_switcher.gotoAndStop('frame_on');
				model.TURNED_ON = true;
				view.LED_green.gotoAndStop('frame_on');
				view.LCD.contrastMax_scr.visible = true;
				
				firmware = new Firmware(view, model);
				//view.dispatchEvent(new Event(EventTypes.LIGHT_CLICK));
				
			} 
			
			else { // вЫЫЫключение
				model.TURNED_ON = false;
				view.power_switcher.gotoAndStop('frame_off');
				model.LIGHT_ON = false;
				view.LCD.gotoAndStop('frame_off');
				view.LED_green.gotoAndStop('frame_off');
				view.LCD.contrastMax_scr.visible = false;

				
				if (firmware != null) {
					firmware.destroy();
					firmware = null;
				}
			}
		}
		
		
		public function SetText():void {
		
			view.FillTextFields();
			if (firmware != null && model.loading_ready) {
				firmware.Screen_init();
			}
		}
		
		public function set_buttonMode(direction:String):void {
		
			view.set_buttonMode(direction);
		}
		
		
		
		public function Blur(direction:String):void {
			
			// прямое направление
			if (direction == 'forward') {
				
				blurFilter = new BlurFilter();
				blurFilter.blurX = blurFilter.blurY = 16;
				blurFilter.quality = 3;
				
				// наложение фильтров на каждый элемент массива
				for (var i:int = 0; i < DisplayObjects.length; i++) {
					DisplayObjects[i].filters = [blurFilter];
				}
				// не размывать окно About
				about_window.filters = null;
				//model_show_Tween = new Tween (about_window, "alpha", Strong.easeOut, 0, 1, 1, true); 
			}
			
			
			// обратное направление
			else if (direction == 'revers') {

				// снятие фильтров
				for (var j:int = 0; j < DisplayObjects.length; j++) {
					DisplayObjects[j].filters = null;
				}
			}
		}
		
		
		
		// рандомайзер
		public function RAND(min:Number, max:Number):int {
	
			var arg: Number = (max - min) * Math.random() + min;
			return arg;
		}
		
		
		
		
	}
}