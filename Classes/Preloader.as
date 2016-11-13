package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.ui.ContextMenu;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.display.Stage;
	
	//import com.google.analytics.AnalyticsTracker;
	//import com.google.analytics.GATracker;
	//import com.google.analytics.utils.URL;
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	public class Preloader extends MovieClip{ 
	

		//public static var STAGE:Stage;
		
		private var model_data:Model;
		private var view:View;
		private var controller:Controller;
		
		
		
		
		private var preVisual:PreloaderVisual;
		private var bLoaded: uint = loaderInfo.bytesLoaded;
		private var bTotal: uint = loaderInfo.bytesTotal;
		private var Timer_Test:Timer = new Timer(50, 1); //50 ;100
		private var my_menu:ContextMenu;
		private var LANG:uint;
		private var lang: String = Capabilities.language // определение языка ОС
		
		//Аналитика
		//public var ACCOUNT_ID: String = "UA-78572464-1";  
		//public var BRIDGE_MODE: String = "AS3";
		//public var DEBUG_MODE: Boolean = false;
		//public var tracker:GATracker;
		
		

		
		/*********************************************
		 *      Конструктор основного класса         *
		 *                                           *
		 */ //****************************************
		
		 public function Preloader() {
		
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		 }
		 
		 public function init(e:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			stage.addEventListener(Event.RESIZE, resizeListener);

			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT;
			

			
			// вывод на сцену индикации загрузки
			preVisual = new PreloaderVisual();
			addChild(preVisual);
			preVisual.x = stage.stageWidth/2; // 630
			preVisual.y = stage.stageHeight / 2; // 420
			
			Timer_Test.addEventListener(TimerEvent.TIMER, checkLoading);
			Timer_Test.start();
			
			
			//tracker = new GATracker(this, ACCOUNT_ID, BRIDGE_MODE, DEBUG_MODE);
			//tracker.trackPageview("Uspeshnaya zagruzka");

			// удаление лишнего меню флешки
			my_menu = new ContextMenu();
			my_menu.hideBuiltInItems();
			contextMenu = my_menu;
			
			//определение языка флешки
			
			switch (lang) {
				case "ru":
				LANG = 0;
				break;
				
				case "en":
				LANG = 1;
				break;
				
				default: 
				LANG = 1;
				break;
			}
			
			model_data = new Model(LANG);

			preVisual.INFORMATOR.text = Model.langArr[0][LANG]; // Загрузка...
			preVisual.version.text = Model.langArr[1][LANG]; // P-900 v.2.0
			
		}
	
		private function ioError(e:IOErrorEvent):void { 
			trace(e.text);
		}
		
		
		
		
		public function resizeListener (event:Event):void { 
			trace("stageWidth: " + stage.stageWidth + " stageHeight: " + stage.stageHeight);
		}
		
		
		
		
		/*********************************************
		 *        Проверка процента загрузки         *
		 *             и вывод на экран              *
		 */ //****************************************
		
		 private function checkLoading(event: TimerEvent):void {
			
			var drop: int = 100 * (Timer_Test.currentCount * bLoaded) / (Timer_Test.repeatCount * bTotal);
			
			// заполнение индикатора загрузки
			preVisual.loading_mask.scaleX = drop / 100;
			
			if (drop >= 100) loadingFinished();
		}
		
		
		/*********************************************
		 *       Когда вся флешка загрузится         *
		 *                  до 100%                  *
		 */ //****************************************
		
		private function loadingFinished():void {
		
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			Timer_Test.reset();
			removeChild(preVisual);
			
			// удаление желтой рамочки с элементов для листания элементов с клавиатуры
			stage.stageFocusRect = false;

			nextFrame();
			view = new View(stage, model_data);
			controller = new Controller(view, model_data);
			addChild(view);
			addChild(controller);
		}
		

		
	}
}



