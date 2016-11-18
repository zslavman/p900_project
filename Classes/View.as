package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event
	import flash.media.Sound;
	
	import flash.events.FocusEvent
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	public class View extends Sprite {
		
		private var model:Model;
		private var STAGE:Stage;


		private var power_sound:Sound = new _power_sound();
		private var click_robot_202:Sound = new _click_robot_202();
		private var charger_in:Sound = new _charger_in();
		private var charger_out:Sound = new _charger_out();
		private var langArr:Array = [];
		
		private var buttons_array:Array = []; // массив кнопок
		private var tips_array:Array = []; // массив подсказок
		

		
		

		
		public function View(_stage:Stage, _model_data:Model) {
			
			STAGE = _stage;
			model = _model_data;
			
			langArr = Model.langArr;

			about_button.addEventListener(MouseEvent.MOUSE_DOWN, about_button_MOUSE_DOWN);
			about_button.buttonMode = true;
			about_button.mouseChildren = false;
			
			power_switcher.addEventListener(MouseEvent.MOUSE_DOWN, power_switcher_MOUSE_DOWN);
			power_switcher.buttonMode = true;
			power_switcher.mouseChildren = false;
			
			buttons_array = [button_sync_up, button_sync_down, button_mode, button_amp_up, button_amp_down, button_light];
			tips_array ['target'] = [input_socket]; // строка целей наведения мышки
			tips_array ['tip'] = [tip1]; // строка соотвествующих им (целям) подсказок
			
			// добавление слушателей 6-ти кнопок
			for (var i:int = 0; i < buttons_array.length; i++){ 
				buttons_array[i].addEventListener(MouseEvent.MOUSE_DOWN, functional_button_MOUSE_DOWN); // слушатели на нажатие и зажимание
				if (i < 5){
					buttons_array[i].addEventListener(MouseEvent.MOUSE_UP, functional_button_MOUSE_UP); // слушатели отпускания кнопки
					buttons_array[i].addEventListener(MouseEvent.MOUSE_OUT, functional_button_MOUSE_UP); // слушатели если при зажимании мышка съезжает с кнопки
				}
			}
			// добавление слушателей наведения и уведения мыши с мест подсказок
			for (var j:int = 0; j < tips_array ['target'].length; j++){ 
				tips_array ['target'][j].addEventListener(MouseEvent.MOUSE_OVER, tip_target_MOUSE_OVER); 
				tips_array ['target'][j].addEventListener(MouseEvent.MOUSE_OUT, tip_target_MOUSE_OUT);
				tips_array ['target'][j].buttonMode = true;
				tips_array ['tip'][j].mouseEnabled = false;
				tips_array ['tip'][j].visible = false;
			}
			
			
			//STAGE.addEventListener(Event.RESIZE, resizeListener); 
			STAGE.addEventListener(KeyboardEvent.KEY_DOWN, Key_DOWN);
			
			charging_target.addEventListener(MouseEvent.MOUSE_DOWN, charging_target_MOUSE_DOWN);
			charging_target.addEventListener(MouseEvent.MOUSE_OVER, charging_target_MOUSE_OVER);
			charging_target.addEventListener(MouseEvent.MOUSE_OUT, charging_target_MOUSE_OUT);
			charging_target.buttonMode = true;
			

			contrast_handle.addEventListener(MouseEvent.MOUSE_DOWN, contrast_handle_MOUSE_DOWN);
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, contrast_handle_MOUSE_MOVE);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, contrast_handle_MOUSE_UP);
			
			contrast_handle.buttonMode = true;
			contrast_handle.mouseChildren = false;
			LCD.contrastMax_scr.visible = false;
			LCD.contrastMax_scr.alpha = 0.03; // видимость клеточек по умолчанию, не более 0.04
			container.visible = false;
			
			charging_plug.mouseEnabled = false;
			charging_plug.alpha = 0;
			
			charging_pluged.mouseEnabled = false;
			charging_pluged.visible = false;
			
			
			
			FillTextFields();


			/*********************************************
			 *          Проверки разного рода            *
			 */ //****************************************
			
			
			//addEventListener(Event.ENTER_FRAME, testing);
			//STAGE.addEventListener(Event.ACTIVATE, act);
			//STAGE.addEventListener(Event.DEACTIVATE, deact);
			//STAGE.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
		}
		
		
		//BUG: не работает слушатель на OVER
		// мышка над целями подсказок
		public function tip_target_MOUSE_OVER(event:MouseEvent):void {
			
			var str:* = event.currentTarget.name;
			for (var i:int = 0; i < tips_array ['target'].length; i++){ 
				if (str == tips_array ['target'][i]) {
					tips_array ['tip'][i].visible = true;
					var tre:Boolean = true;
				}
			}
		}
		
		public function tip_target_MOUSE_OUT(event:MouseEvent):void {
			
			var str:String = event.currentTarget.name;
			for (var i:int = 0; i < tips_array ['target'].length; i++){ 
				if (str == tips_array ['target'][i]) tips_array ['tip'][i].visible = false;
			}
		}
		
		
		
		
		
		
		
		
		
		
		

		// мышка над разъемом зарядки
		public function charging_target_MOUSE_OVER(event:MouseEvent):void {
			dispatchEvent(new Event(EventTypes.CHARGER_TARGET_OVER));
		}
		public function charging_target_MOUSE_OUT(event:MouseEvent):void {
			dispatchEvent(new Event(EventTypes.TARGET_OUT));
		}
		public function charging_target_MOUSE_DOWN(event:MouseEvent):void {
			dispatchEvent(new Event(EventTypes.TARGET_CLICK));
			if (!model.charge_connected) charger_out.play();
			else if (model.charge_connected) charger_in.play();
		}
		
		
		
		
		// ручка контраста
		public function contrast_handle_MOUSE_DOWN(event:MouseEvent):void {
			dispatchEvent(new Event(EventTypes.CONTRAST_MOUSE_DOWN));
		}
		public function contrast_handle_MOUSE_MOVE(event:MouseEvent):void {
			dispatchEvent(new Event(EventTypes.CONTRAST_MOUSE_MOVE));
		}
		public function contrast_handle_MOUSE_UP(event:MouseEvent):void {
			dispatchEvent(new Event(EventTypes.CONTRAST_MOUSE_UP));
		}
		
		

		
		// Кнопка "About"
		public function about_button_MOUSE_DOWN(event:MouseEvent):void { 

			click_robot_202.play();
			dispatchEvent(new Event(EventTypes.INFO_CLICK));
		}
		

		// Тумблер "ВКЛ./ВЫКЛ"
		public function power_switcher_MOUSE_DOWN(event:MouseEvent):void { 

			power_sound.play();
			dispatchEvent(new Event(EventTypes.POWER_CLICK));
		}
		
		
		// нажатие кнопок
		public function functional_button_MOUSE_DOWN(event:MouseEvent):void { 

			switch (event.target.name){ 
			
				case 'button_sync_up':
					dispatchEvent(new Event(EventTypes.SYNC_UP_CLICK));
				break;
				case 'button_sync_down':
					dispatchEvent(new Event(EventTypes.SYNC_DOWN_CLICK));
				break;
				case 'button_light':
					dispatchEvent(new Event(EventTypes.LIGHT_CLICK));
				break;
				case 'button_mode':
					dispatchEvent(new Event(EventTypes.MODE_CLICK));
				break;
				case 'button_amp_up':
					dispatchEvent(new Event(EventTypes.AMPL_UP_CLICK));
				break;
				case 'button_amp_down':
					dispatchEvent(new Event(EventTypes.AMPL_DOWN_CLICK));
				break;
			}
			dispatchEvent(new Event(EventTypes.JAMM_BUTTON)); // зажимание любой кнопки
		}
		
		
		// отпускание кнопок
		public function functional_button_MOUSE_UP(event:MouseEvent):void {
			
			dispatchEvent(new Event(EventTypes.UNJAMM_BUTTON));
		}
		
		
		
		
		/*********************************************
		 *             Обработка клавиатуры          *
		 *                                           *
		 *///*****************************************
		public	function Key_DOWN(event:KeyboardEvent) {

			if (event.keyCode == 27 || event.keyCode == 13) { // клавиша "Esc" или "Enter"
				dispatchEvent(new Event(EventTypes.KEY_ESC_ENTER));
			}
			
			if (event.keyCode == 112) { // нажатие "F1"
				//dispatchEvent(new Event(EventTypes.KEY_F1));
			}
		}
		
		
		
		
		/*********************************************
		 *       Ф-ция заполнения текст. полей       *
		 *                                           *
		 *///*****************************************
		public function FillTextFields():void {
			
			// фальша
			var LANG:uint = model.LANG;

			title.text = langArr[3][LANG]; // П-900
			title_long.text = langArr[4][LANG]; // Приёмник:
			contrast.text = langArr[5][LANG]; // Контраст
			phones.text = langArr[6][LANG]; // Телефоны
			sync1.text = langArr[7][LANG]; // Синхро
			sync2.text = langArr[7][LANG]; // Синхро
			bright.text = langArr[8][LANG]; // Яркость
			mode.text = langArr[9][LANG]; // Режим
			battery.text = langArr[10][LANG]; // Батарея
			amplif.text = langArr[11][LANG]; // Усил.
			turn_on.text = langArr[12][LANG]; // Вкл.
			zaryad.text = langArr[13][LANG]; // Заряд.
			input.text = langArr[14][LANG]; // Вход.
	
		}
		
		
		

		//public function testing(e:Event):void {
			//
			////trace ("loading_ready = " + model.loading_ready);
		//}
		
		//public function act(e:Event):void {
			//
			//trace ('activated_');
		//}
		//public function deact(e:Event):void {
			//
			//trace ('deactivated_');
		//}
		//
		//public function focusInHandler(e:Event):void {
			//
			//trace ('target = ' + e.target.name);
		//}
	}
}