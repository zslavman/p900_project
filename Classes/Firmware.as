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
	public class Firmware {
	
		private var model:Model;
		private var view:View;
		
		private var Timer_LoadingFwr:Timer = new Timer(250);
		private var loading_duration:uint = 8; //длительность загрузки 
		private var menu_screen:Array = [];
		private var N:uint = 0;
		
		
		
		
		public function Firmware(_view:View, _model:Model) {
			
			view = _view;
			model = _model;
			view.addEventListener(EventTypes.SYNC_UP_CLICK, func_Sync_UP);
			view.addEventListener(EventTypes.SYNC_DOWN_CLICK, func_Sync_DOWN);
			view.addEventListener(EventTypes.MODE_CLICK, func_MODE);
			view.addEventListener(EventTypes.AMPL_UP_CLICK, func_Ampl_UP);
			view.addEventListener(EventTypes.AMPL_DOWN_CLICK, func_Ampl_DOWN);
			
			Timer_LoadingFwr.addEventListener(TimerEvent.TIMER, func_Timer_LoadingFwr);
			Timer_LoadingFwr.start();
			view.container.battery_indication.visible = false;
			view.container.visible = true;
			
			menu_screen = ['akustika', 'filter1024', 'filter2048'];

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
				view.container.line2.text = '';
				view.container.line1.text = Model.langArr[15][model.LANG];
				view.container.battery_indication.visible = true;
			
				Timer_LoadingFwr.reset();
				model.loading_ready = true;
			}
		}
		
		
		
		
		
		/*********************************************
		 *              Кнопка SYNC_UP               *
		 *                                           *
		 */ //****************************************
		public function func_Sync_UP(event:Event):void {
		
			trace ('SYNC_UP');
		}
		
		
		
		
		/*********************************************
		 *              Кнопка SYNC_DOWN               *
		 *                                           *
		 */ //****************************************
		public function func_Sync_DOWN(event:Event):void {
		
			trace ('SYNC_DOWN');
		}
		
		
		
		
		/*********************************************
		 *                Кнопка MODE                *
		 *                                           *
		 */ //****************************************
		public function func_MODE(event:Event):void {
		
			//trace ('MODE');
			N++;
			if (N > menu_screen.length - 1) N = 0;
			trace (menu_screen[N]);
		}
		
		
		
		
		/*********************************************
		 *                Кнопка AMPL_UP             *
		 *                                           *
		 */ //****************************************
		public function func_Ampl_UP(event:Event):void {
		
			trace ('AMPL_UP');
		}
		
		
		
		
		/*********************************************
		 *              Кнопка AMPL_DOWN             *
		 *                                           *
		 */ //****************************************
		public function func_Ampl_DOWN(event:Event):void {
		
			trace ('AMPL_DOWN');
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
			view.container.visible = false;
			Destroy_text();
			model.loading_ready = false;
		}
		

	}
}