package
{
	import About_Window;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.filters.BlurFilter;
	
	/**
	 * ...
	 * @author zslavman
	 * http://www.cyberforum.ru/actionscript/thread577183.html
	 */
	
	 
	public class Controller extends Sprite {
		
		private var model:Model;
		private var view:View;
		private var controller:Controller;
		
		
		private var firmware:Firmware;
		private var about_window:About_Window;
		
		
		private var langArr:Array = [];
		private var offset:Number;
		private var rotate_limit:Number = 150;// лимит поворота ручки контраст в градусах
		private var final_rotation:Number = 0;
		
		private var charge_min:int = 21; // пределы заряда в процентах
		private var charge_max:int = 100;
		
		private var DisplayObjects:Array = []; // массив дисплейобъектов которые нужно блюрить
		private var blurFilter:BlurFilter;
		
		
		
		
		
		
		
		public function Controller(_view:View, _model:Model) {
			
			controller = this;
			view = _view;
			model = _model;
			langArr = Model.langArr;
			
			DisplayObjects = [view];
			
			view.addEventListener(EventTypes.INFO_CLICK, ShowInfo);
			view.addEventListener(EventTypes.POWER_CLICK, Power);
			view.addEventListener(EventTypes.LIGHT_CLICK, Light);
			view.addEventListener(EventTypes.CONTRAST_MOUSE_DOWN, ContrastMouseDown);
			
			var charge:int = RAND(charge_min, charge_max);
			model.charge_level = charge;
			trace ("charge = " + charge);
			//addEventListener(Event.ENTER_FRAME, testing);
		}
		
		
		
		
		
		public function testing(e:Event):void {
			
			//trace ("loading_ready = " + model.loading_ready);
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
				view.dispatchEvent(new Event(EventTypes.LIGHT_CLICK));
				
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
		public function RAND(min:Number, max:Number): int {

			var arg: Number = (max - min) * Math.random() + min;
			return arg;
		}
		
		
		
		
		

		
		
		// обработка клавиатуры (если таковая будет имется)
		public function key_Pressed(event:KeyboardEvent):void {
		
			//switch (event.keyCode){
			//
			//case Keyboard.LEFT:
			//}
		}
	}
}