package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	public class View extends Sprite {
		
		private var model:Model;
		private var STAGE:Stage;


		private var power_sound:Sound = new _power_sound();
		private var click_robot_202:Sound = new _click_robot_202();
		private var langArr:Array = [];
		

		
		

		
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
			
			// слушатели на нажатие и зажимание
			button_sync_up.addEventListener(MouseEvent.MOUSE_DOWN, functional_button_MOUSE_DOWN);
			button_sync_down.addEventListener(MouseEvent.MOUSE_DOWN, functional_button_MOUSE_DOWN);
			button_light.addEventListener(MouseEvent.MOUSE_DOWN, functional_button_MOUSE_DOWN);
			button_mode.addEventListener(MouseEvent.MOUSE_DOWN, functional_button_MOUSE_DOWN);
			button_amp_up.addEventListener(MouseEvent.MOUSE_DOWN, functional_button_MOUSE_DOWN);
			button_amp_down.addEventListener(MouseEvent.MOUSE_DOWN, functional_button_MOUSE_DOWN);
			
			// слушатели отпускания кнопки
			button_sync_up.addEventListener(MouseEvent.MOUSE_UP, functional_button_MOUSE_UP);
			button_sync_down.addEventListener(MouseEvent.MOUSE_UP, functional_button_MOUSE_UP);
			button_amp_up.addEventListener(MouseEvent.MOUSE_UP, functional_button_MOUSE_UP);
			button_amp_down.addEventListener(MouseEvent.MOUSE_UP, functional_button_MOUSE_UP);
			button_mode.addEventListener(MouseEvent.MOUSE_UP, functional_button_MOUSE_UP);
			
			// слушатели если при зажимании мышка съезжает с кнопки
			button_sync_up.addEventListener(MouseEvent.MOUSE_OUT, functional_button_MOUSE_UP);
			button_sync_down.addEventListener(MouseEvent.MOUSE_OUT, functional_button_MOUSE_UP);
			button_amp_up.addEventListener(MouseEvent.MOUSE_OUT, functional_button_MOUSE_UP);
			button_amp_down.addEventListener(MouseEvent.MOUSE_OUT, functional_button_MOUSE_UP);
			button_mode.addEventListener(MouseEvent.MOUSE_OUT, functional_button_MOUSE_UP);
			
			
			
			contrast_handle.addEventListener(MouseEvent.MOUSE_DOWN, contrast_handle_MOUSE_DOWN);
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE, contrast_handle_MOUSE_MOVE);
			STAGE.addEventListener(MouseEvent.MOUSE_UP, contrast_handle_MOUSE_UP);
			
			contrast_handle.buttonMode = true;
			contrast_handle.mouseChildren = false;
			LCD.contrastMax_scr.visible = false;
			LCD.contrastMax_scr.alpha = 0.03; // видимость клеточек по умолчанию, не более 0.04
			container.visible = false;
			
			FillTextFields();
		}
		
		

		

		
		
		// ручка контраста
		public function contrast_handle_MOUSE_DOWN(event:MouseEvent):void {
			//click_sound1.play();
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
	}
}