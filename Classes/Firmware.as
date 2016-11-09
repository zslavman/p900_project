package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	//TODO: сделать наложение шума на мВ
	//TODO: сделать случайную вариацию заряда батареи при включении
	//TODO: сделать визуализацию подключение зарядки
	//TODO: сделать окно About
	//TODO: сделать всплывающие подсказки
	//TODO: поправить переключалку языка (съехал текст)
	
	
	 
	 
	 
	 
	 
	public class Firmware {
	
		private var model:Model;
		private var view:View;
		
		private var Timer_LoadingFwr:Timer = new Timer(250);
		private var Timer_Miganie:Timer = new Timer(200);
		private var Timer_Jamming:Timer = new Timer(100);
		private var Timer_FastInput:Timer = new Timer(100);
		
		
		private var count_mig:uint = 0; // счетчик для управл. миганием
		private var loading_duration:uint = 8; //длительность загрузки 
		private var menu_now:String; // для обработки кнопок, что бы понимать в каком меню сейчас
		private var N:uint = 0; // номер текущего меню (номер элемента из массива меню)
		
		private var mode_akustika:Object = {};
		private var mode_filter1024:Object = {};
		private var mode_filter2048:Object = {};
		private var menu_array:Array = [];
		private var plus_minus_flag:Boolean = false;
		private var button_flag:String = '';
		

		
		
		public function Firmware(_view:View, _model:Model) {
			
			view = _view;
			model = _model;
			view.addEventListener(EventTypes.SYNC_UP_CLICK, func_Sync_UP);
			view.addEventListener(EventTypes.SYNC_DOWN_CLICK, func_Sync_DOWN);
			view.addEventListener(EventTypes.MODE_CLICK, func_MODE);
			view.addEventListener(EventTypes.AMPL_UP_CLICK, func_Ampl_UP);
			view.addEventListener(EventTypes.AMPL_DOWN_CLICK, func_Ampl_DOWN);
			
			
			// слушатель на зажимание кнопок
			view.addEventListener(EventTypes.JAMM_BUTTON, func_all_Buttons_DOWN);
			view.addEventListener(EventTypes.UNJAMM_BUTTON, func_all_Buttons_UP);
			

			
			Timer_LoadingFwr.addEventListener(TimerEvent.TIMER, func_Timer_LoadingFwr);
			Timer_LoadingFwr.start();
			Timer_Miganie.addEventListener(TimerEvent.TIMER, func_Timer_Miganie);
			Timer_Jamming.addEventListener(TimerEvent.TIMER, func_Timer_Jamming);
			Timer_FastInput.addEventListener(TimerEvent.TIMER, func_Timer_FastInput);
			view.container.battery_indication.visible = false;
			view.container.visible = true;
			

			// объекты в которых храняться текущие настройки выбранного режима
			mode_filter1024.id = 'mode_filter1024';
			mode_filter1024.name = Model.langArr[15];
			mode_filter1024.gain = 20; // номер элемента массива коэффициентов усиления
			mode_filter1024.gain_val = '0.001';
			
			mode_filter2048.id = 'mode_filter2048';
			mode_filter2048.name = Model.langArr[16];
			mode_filter2048.gain = 20;
			mode_filter2048.gain_val = '0.001';
			
			mode_akustika.id = 'mode_akustika';
			mode_akustika.name = '';
			mode_akustika.gain = 5;
			mode_akustika.gain_val = 0;
			mode_akustika.sync_value = '0.00';
			
			menu_array = [mode_akustika, mode_filter1024, mode_filter2048];

			menu_now = menu_array[N].id;

		}
		
		
		
		
		
		
		
		
		/*********************************************
		 *            Зажимание  кнопок              *
		 *                                           *
		 */ //****************************************
		public function func_all_Buttons_DOWN(event:Event):void {
			
			Timer_Jamming.start();
			trace ('JAMM');
		}
		
		
		/*********************************************
		 *     Таймер задержки зажимания кнопок      *
		 *                                           *
		 */ //****************************************
		public function func_Timer_Jamming(event:TimerEvent):void {
			
			if (Timer_Jamming.currentCount == 8) {
				Timer_Jamming.reset();
				trace ('Jamming_' + Timer_Jamming.currentCount);
				// запуск таймера повтора
				Timer_FastInput.start();
			} 
		}
		
		
		
		/*********************************************
		 *            Отпускание  кнопок             *
		 *                                           *
		 */ //****************************************
		public function func_all_Buttons_UP(event:Event):void {
			
			Timer_Jamming.reset();
			Timer_FastInput.reset();
			button_flag = '';
		}
		

		
		/*********************************************
		 *          Таймер быстрого ввода            *
		 *                                           *
		 */ //****************************************
		public function func_Timer_FastInput(event:TimerEvent):void {
			
			// в зависимости от флага запуск диспатчера
			trace ('FastInput_' + Timer_FastInput.currentCount);
			switch (button_flag){ 
				case 'button_sync_up':
					view.dispatchEvent(new Event(EventTypes.SYNC_UP_CLICK));
				break;
				case 'button_sync_down':
					view.dispatchEvent(new Event(EventTypes.SYNC_DOWN_CLICK));
				break;
				case 'button_amp_up':
					view.dispatchEvent(new Event(EventTypes.AMPL_UP_CLICK));
				break;
				case 'button_amp_down':
					view.dispatchEvent(new Event(EventTypes.AMPL_DOWN_CLICK));
				break;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *        Таймер загрузки прошивки           *
		 *                                           *
		 */ //****************************************
		public function func_Timer_LoadingFwr(event:TimerEvent):void {
			
			if (Timer_LoadingFwr.currentCount < loading_duration) {
				view.container.line2.text = Model.langArr[19][model.LANG];
			}
			
			else if (Timer_LoadingFwr.currentCount == loading_duration) {
				view.container.battery_indication.visible = true;
				Screen_init();
			
				Timer_LoadingFwr.reset();
				model.loading_ready = true;
			}
		}
		
		
		
		/*********************************************
		 *        Таймер мигания красным LED         *
		 *                                           *
		 */ //****************************************
		public function func_Timer_Miganie(event:TimerEvent):void {
			
			count_mig++;
			if (count_mig > 10) count_mig = 0;
			
			if (count_mig == 8) {
				view.LED_red.gotoAndStop('frame_on');
				if (plus_minus_flag) {
					view.container.s_plus_place.text = Model.langArr[20][model.LANG];
					plus_minus_flag = false;
				}
				else {
					view.container.s_plus_place.text = Model.langArr[21][model.LANG];
					plus_minus_flag = true;
				}
				
			}
			if (count_mig == 10) {
				view.LED_red.gotoAndStop('frame_off');
				view.container.s_plus_place.text = '';
			}
		}
		
		
		
		
		
		
		
		
		
		
		/*********************************************
		 *              Кнопка SYNC_UP               *
		 *                                           *
		 */ //****************************************
		public function func_Sync_UP(event:Event):void {
		
			button_flag = 'button_sync_up';
			view.addEventListener(EventTypes.BUTTON_MOUSE_OUT, func_all_Buttons_UP);
			
			if (menu_now == 'mode_akustika') {
				menu_array[N].gain_val++;
				if (menu_array[N].gain_val > 9) menu_array[N].gain_val = 9;
				if (menu_array[N].gain_val > 8) Timer_Miganie.start();
				Screen_init();
			}
		}
		
		
		
		
		/*********************************************
		 *              Кнопка SYNC_DOWN               *
		 *                                           *
		 */ //****************************************
		public function func_Sync_DOWN(event:Event):void {
		
			button_flag = 'button_sync_down';
			view.addEventListener(EventTypes.BUTTON_MOUSE_OUT, func_all_Buttons_UP);
			
			if (menu_now == 'mode_akustika') {
				menu_array[N].gain_val--;
				if (menu_array[N].gain_val < 0) menu_array[N].gain_val = 0;
				Screen_init();
				Miganie_Off();
			}
		}
		
		
		
		
		/*********************************************
		 *                Кнопка MODE                *
		 *                                           *
		 */ //****************************************
		public function func_MODE(event:Event):void {
		
			N++;
			if (N > menu_array.length - 1) N = 0;
			menu_now = menu_array[N].id;
			Screen_init();
			
			// включение и выключение красной мигалки 
			if (menu_now == 'mode_akustika' && menu_array[N].gain_val > 8) Timer_Miganie.start();
			else if (menu_now != 'mode_akustika') Miganie_Off();
		
			//trace ("menu_now = " + menu_now);
		}
		
		
		
		
		/*********************************************
		 *                Кнопка AMPL_UP             *
		 *                                           *
		 */ //****************************************
		public function func_Ampl_UP(event:Event):void {

			button_flag = 'button_amp_up';
			view.addEventListener(EventTypes.BUTTON_MOUSE_OUT, func_all_Buttons_UP);
			menu_array[N].gain++;
			
			if (menu_now == 'mode_akustika') {
				if (menu_array[N].gain > Model.gainAcusticaConst.length - 1) menu_array[N].gain = Model.gainAcusticaConst.length - 1;
			}
			else {
				if (menu_array[N].gain > Model.gainFilterConst.length - 1) menu_array[N].gain = Model.gainFilterConst.length - 1;
			}
			Screen_init();
		}
		
		
		
		
		/*********************************************
		 *              Кнопка AMPL_DOWN             *
		 *                                           *
		 */ //****************************************
		public function func_Ampl_DOWN(event:Event):void {
		
			button_flag = 'button_amp_down';
			view.addEventListener(EventTypes.BUTTON_MOUSE_OUT, func_all_Buttons_UP);
			menu_array[N].gain--;
			
			if (menu_now == 'mode_akustika') {
				if (menu_array[N].gain < 0) menu_array[N].gain = 0;
			}
			else {
				if (menu_array[N].gain < 0) menu_array[N].gain = 0;
			}
			Screen_init();
		}
		
		
		
		
		
		
		
		// инициализация экрана в любом из меню
		public function Screen_init ():void {
			
			Destroy_text();

			if (menu_now == 'mode_akustika') {
				view.container.line2.text = '×00' + menu_array[N].gain_val;
				view.container.line1.text = menu_array[N].sync_value  + Model.langArr[18][model.LANG];
				view.container.gain_place.text = '×' + Model.gainAcusticaConst[menu_array[N].gain];
			}
			else {
				view.container.line1.text = menu_array[N].name[model.LANG];
				view.container.line2.text = menu_array[N].gain_val + Model.langArr[17][model.LANG];
				view.container.gain_place.text = '×' + Model.gainFilterConst[menu_array[N].gain];
			}
		}
		
		
		
		
		
		
		
		
		private function Destroy_text():void {
		
			view.container.line1.text = '';
			view.container.line2.text = '';
			view.container.gain_place.text = '';
			view.container.s_plus_place.text = '';
			
		}
		
		
		
		public function destroy():void {
		
			view.removeEventListener(EventTypes.SYNC_UP_CLICK, func_Sync_UP);
			view.removeEventListener(EventTypes.SYNC_DOWN_CLICK, func_Sync_DOWN);
			view.removeEventListener(EventTypes.MODE_CLICK, func_MODE);
			view.removeEventListener(EventTypes.AMPL_UP_CLICK, func_Ampl_UP);
			view.removeEventListener(EventTypes.AMPL_DOWN_CLICK, func_Ampl_DOWN);
			Timer_LoadingFwr.reset();
			Miganie_Off();
			view.container.visible = false;
			Destroy_text();
			model.loading_ready = false;
		}
		
		public function Miganie_Off():void {
		
			Timer_Miganie.reset();
			count_mig = 0;
			view.LED_red.gotoAndStop('frame_off');
			view.container.s_plus_place.text = '';
		}
	}
}