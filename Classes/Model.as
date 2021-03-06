package
{
	
	/**
	 * ...
	 * @author zslavman
	 * Класс хранения констант, массивов
	 */
	
	 import flash.net.SharedObject;
	 import flash.system.Capabilities;
	 
	 
	 
	public class Model {
		
		public static const langArr:Array = [];
		public static var gainFilterConst = [];
		public static var gainAcusticaConst = []
		
		private var _LANG:uint;
		private var _TURNED_ON:Boolean = false;
		private var _LIGHT_ON:Boolean = false;
		private var _ScreenALPHA:Number = 0;
		private var _loading_ready:Boolean = false;
		
		private var _charge_level:int; // число заряда батареи (от 20 до 100), вычисляется после загрузки Controller.as, т.к. там ф-ция рандомазера
		private var charge_min:int = 30; // пределы заряда в процентах
		private var charge_max:int = 100;
		
		private var _charge_connected:Boolean = false; // подключена ли зарядка
		private var _show_tips:Boolean; // показывать подсказки

		public static var SharedObj:SharedObject;
		private var lang:String; 
		

		
		
		
		public function Model() {
			
			langArr[0] = ["Загрузка...", "Loading..."];
			langArr[1] = ["П-900 v.2.0", "P-900 v.2.0"];
			langArr[2] = ["RU", "EN"];
			langArr[3] = ["П-900", "P-900"];
			langArr[4] = ["Приёмник", "Surge wave locator set"];
			langArr[5] = ["КОНТРАСТ", "CONTRAST"];
			langArr[6] = ["ТЛФ.", "PHONES"];
			langArr[7] = ["СИНХР.", "SYNC."];
			langArr[8] = ["ЯРКОСТЬ", "BRIGHTNESS"];
			langArr[9] = ["РЕЖИМ", "MODE"];
			langArr[10] = ["БАТАРЕЯ", "CHARGE"];
			langArr[11] = ["УСИЛ.", "AMPL."];
			langArr[12] = ["ВКЛ.", "ON"];
			langArr[13] = ["ЗАРЯД", "CHARGE"];
			langArr[14] = ["ВХОД", "INPUT"];
			langArr[15] = [" Фильтр 1024Гц", " Filter 1024Hz"];
			langArr[16] = [" Фильтр 2048Гц", " Filter 2048Hz"];
			langArr[17] = ["мВ", "mV"];
			langArr[18] = ["мс", "ms"];
			langArr[19] = [" Ver 3.2.9", " Ver 3.2.9"];
			langArr[20] = ["+S", "+S"];
			langArr[21] = ["-S", "-S"];
			langArr[22] = ["32768$", "32768$"];
			langArr[36] = ["    Зарядка", "    Charging"];
			
			langArr[23] = ["Окно справки симулятора ", "Simulator help window "];
			langArr[24] = [" v.2.0", " v.2.0"];
			langArr[25] = ["Язык интерфейса:", "Interface language:"];
			langArr[26] = ["русский", "english"];
			langArr[27] = ["Симулятор создан для ознакомления с функционалом реального оборудования поиска залегания трассы П-900 и предназначен для обучения пользователя.", "The simulator is designed to represent a functionality of a real tracing equipment P-900 and intended for both – customer familiarisation and user training."];
			langArr[28] = ['Разработано для KEP Power Testing Ltd., \r © Вячеслав Зинько, 2016 г. \r <a href="event:myMail">v.zinko@kep.ua</a>', 'Designed for KEP Power Testing Ltd. \r © Viacheslav Zinko, 2016 \r <a href="event:myMail">v.zinko@kep.ua</a>'];
			//langArr[236] = ["mailto:zslavman@gmail.com", "mailto:zslavman@gmail.com"];
			langArr[29] = ["mailto:v.zinko@kep.ua", "mailto:v.zinko@kep.ua"];
			langArr[30] = ["ХАРЬКОВЭНЕРГОПРИБОР", "KharkovEnergoPribor"];
			langArr[31] = ["Питание:   12В", "Power supply:   12V"];
			langArr[32] = ["Потр. мощность, не более: 6 Вт", "Power consumption: 6W max"];
			langArr[33] = ["Зав. №: 1234    Изготовлено: 2016", "Serial: #1234    Manufactured: 2016"];
			langArr[34] = ["Сделано в Украине", "Made in Ukraine"];
			langArr[35] = ["http://www.kep.ua/ru/", "http://www.kep.ua/en/"];
			langArr[37] = ["Показывать \rподсказки", "Show \rtips"];
			langArr[38] = ["Подключаемые датчики:", "Connectable sensors:"];
			langArr[39] = ["акустический", "acoustic"];
			langArr[40] = ["индукционный", "inductive"];
			langArr[41] = ["Индикатор приема сигнала внутренней антенной приемника в режиме акустики", "LED, indicating a signal receiving by internal antenna in acoustic mode"];
			langArr[42] = ["Индикатор питания", "Power LED"];
			langArr[43] = ["Вы нашли секрет!", "You have found the trick!"];
			
			// синхронизация с кукисами клиента, для начала заменим пробелы в названии создаваемого шаредобжект (не допускаются пробелы в названии шаредобджект)
			// создаем регулярное выражение для поска пробелов в названии
			
			var reg:RegExp = / /g; // парамерт /g маска для всех " " в выражении
			var str1:String = langArr[1][1].replace(reg, '_');

			SharedObj = SharedObject.getLocal(str1, "/"); // параметр "/" - записывает *.SOL не создавая директории
			
			_LANG = SharedObj.data.LANG;
			if (SharedObj.data.LANG == null) { // если в кукисах нет инфы о языке

				lang = Capabilities.language; // определяем язык ОС
				
				switch (lang) {
					case "ru":
					LANG = 0; // тут идет вызов ф-ции set LANG();
					break;
					
					case "en":
					LANG = 1; // тут идет вызов ф-ции set LANG();
					break;
					
					default: 
					LANG = 1; // тут идет вызов ф-ции set LANG();
					break;
				}
			}
			
			_show_tips = SharedObj.data.show_tips;
			if (SharedObj.data.show_tips == null) {
				show_tips = true; // тут идет вызов ф-ции set show_tips();
			}
			
			
			gainFilterConst = ["1.0", "1.2", "1.5", "1.9", "2.4", "3.0", "3.7", "4.8", "6.0", "7.5", "10.0", "12.5", "15.5", "19.5", 24, 31, 40, 50, 65, 80, 100, 130, 160, 200, 250, 325, 420, 520, 650, 850, 1050, 1300, 1700, 2100, 2800, 3500, 4300, 5500, 8000, 10000, 12000, 16000, 20000, 25000, 50000]; //45 элементов, начинать с 21-го
			gainAcusticaConst = [1, "1.3", "1.6", 2, "2.4", 3, 4, 5, 6, 8, 10, 13, 16, 20, 26, 33, 44, 53, 67, 92, 110, 200, 400, 800, 1600, 3000, 6000, 12000, 20000, 40000]; //30 элементов, начинать с 5-го
		}
		
		

		
		
		
		public function get give_charge_limits():Array {
			var array:Array = [];
			array['min'] = charge_min;
			array['max'] = charge_max;
			return array;
		}
		
		
		public function get LANG():uint {
			return _LANG;
		}
		public function set LANG(value:uint):void {
			_LANG = value;
			SharedObj.data.LANG = _LANG;
			SharedObj.flush();
		}
		
		
		public function get show_tips():Boolean {
			return _show_tips;
		}
		public function set show_tips(value:Boolean):void {
			_show_tips = value;
			SharedObj.data.show_tips = _show_tips;
			SharedObj.flush();
		}
		
		
		public function get TURNED_ON():Boolean {
			return _TURNED_ON;
		}
		public function set TURNED_ON(value:Boolean):void {
			_TURNED_ON = value;
		}
		
		
		public function get LIGHT_ON():Boolean {
			return _LIGHT_ON;
		}
		public function set LIGHT_ON(value:Boolean):void {
			_LIGHT_ON = value;
		}
		
		
		public function get ScreenALPHA():Number {
			return _ScreenALPHA;
		}
		public function set ScreenALPHA(value:Number):void {
			_ScreenALPHA = value;
		}
		
		
		
		public function get loading_ready():Boolean {
			return _loading_ready;
		}
		public function set loading_ready(value:Boolean):void {
			_loading_ready = value;
		}
		
		
		public function get charge_level():int {
			return _charge_level;
		}
		public function set charge_level(value:int):void {
			_charge_level = value;
		}
		
		
		public function get charge_connected():Boolean {
			return _charge_connected;
		}
		public function set charge_connected(value:Boolean):void {
			_charge_connected = value;
		}
	}
}