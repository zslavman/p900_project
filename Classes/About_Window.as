package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.media.Sound;
	
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.*;
	
	
	
	/**
	 * ...
	 * @author zslavman
	 */
	
	 
	 
	 
	 
	public class About_Window extends Sprite {
	
		
		private var model:Model;
		private var controller:Controller;
		
		
		private var langArr:Array;
		
		private var role_tween1:Tween;
		private var role_start_y:Number;
		private var role_finish_y:Number;
		
		private var logo_shiner:Tween;
		private var shine_start_x:Number;
		private var shine_finish_x:Number;
		private var shine_duration:Number = 2; // скорость пробегания полосы по логотипу
		
		private var click_sound1:Sound = new _click_sound1();
		private var click_robot_202:Sound = new _click_robot_202();
		
		
		private var mailCSS:StyleSheet = new StyleSheet();
		
		
	
		
		public function About_Window(_model:Model, _controller:Controller) {
		
			model = _model;
			controller = _controller;
			langArr = Model.langArr;
			
			logo.addEventListener(MouseEvent.MOUSE_DOWN, logo_MOUSE_DOWN);
			logo.buttonMode = true;
			logo.mouseChildren = false;
			ok_button.addEventListener(MouseEvent.MOUSE_DOWN, ok_button_MOUSE_DOWN);
			ok_button.buttonMode = true;
			ok_button.mouseChildren = false;
			
			LANG_button.addEventListener(MouseEvent.MOUSE_DOWN, LANG_button_MOUSE_DOWN);
			LANG_button.buttonMode = true;
			LANG_button.mouseChildren = false;
			lang_line.mouseEnabled = false;
			lang_line.mouseChildren = false;
			
			//view.addEventListener(EventTypes.KEY_ESC_ENTER, Key_Esc_or_Enter);
			
			role_start_y = lang_line.y;
			role_finish_y = lang_line.y + 43;
			
			shine_start_x = logo.shine_line.x;
			shine_finish_x = logo.shine_line.x + 200;
			
			LangTween('pre');
			
			// запуск твина анииации блеска логотипа
			startShine();
			
			// линка с почтой:
			mailCSS.setStyle("a:link", {color:'#FFFFFF', textDecoration:'none'}); // 0000CC
			mailCSS.setStyle("a:hover", {color:'#B4FAF9', textDecoration:'underline'}); // 0000FF
			
			author.styleSheet = mailCSS;
			author.addEventListener(TextEvent.LINK, linkHandler); // слушатель линка в тексте
			
			FillTextFields();
		
		}
		
		
		
		


		
		
		/*********************************************
		 *              Анимация логотипа            *
		 *                                           *
		 *///*****************************************
		public function ifShineFinish(event:TweenEvent):void {
			
			logo_shiner.removeEventListener(TweenEvent.MOTION_FINISH, ifShineFinish);
			startShine();
		}
		public function startShine():void {
		
			logo_shiner = new Tween (logo.shine_line, "x", None.easeOut, shine_start_x, shine_finish_x, shine_duration, true);
			logo_shiner.addEventListener(TweenEvent.MOTION_FINISH, ifShineFinish);
		}
		
		
		/*********************************************
		 *              Клик по логотипу             *
		 *                                           *
		 *///*****************************************
		public function logo_MOUSE_DOWN(event:MouseEvent):void { 
			
			var request: URLRequest = new URLRequest(langArr[35][model.LANG]);
			navigateToURL(request);
		}
		
		
		
		
		/*********************************************
		 *                 Л и н к и                 *
		 *                                           *
		 */ //****************************************
		public function linkHandler(linkEvent:TextEvent):void {
			
			if (linkEvent.text == "myMail") {
				var myRequest:URLRequest = new URLRequest(langArr[29][model.LANG]);
				navigateToURL(myRequest);
			}
		}
		
		
		
		
		/*********************************************
		 *       Ф-ция заполнения текст. полей       *
		 *                                           *
		 *///*****************************************
		public function FillTextFields():void {
			
			var LANG:uint = model.LANG; 
			
			h1.text = langArr[23][LANG] + langArr[3][LANG] + langArr[24][LANG]; 
			ui_lang.text = langArr[25][LANG];
			ui_lang_value.text = langArr[26][LANG];
			designed_to.text = langArr[27][LANG];
			author.text = langArr[28][LANG];
			
			//шильдик
			shildik.factory_name.text = langArr[30][LANG];
			shildik.p900.text = langArr[3][LANG];
			shildik.voltage.text = langArr[31][LANG];
			shildik.power.text = langArr[32][LANG];
			shildik.serial.text = langArr[33][LANG];
			shildik.made.text = langArr[34][LANG];
			if (LANG == 1) shildik.DC_symbol.x = -80;
			else if (LANG == 0) shildik.DC_symbol.x = -135;
			
		}
		
		
		/*********************************************
		 *              Кнопка "LANG"                *
		 *                                           *
		 */ //****************************************
		public function LANG_button_MOUSE_DOWN(event:MouseEvent):void{ 
        
			click_sound1.play();
			
			model.LANG++;
			if (model.LANG > 1) model.LANG = 0;
			LangTween();
			FillTextFields();
			controller.SetText();
        }
		
		
		
		
		
		public function ok_button_MOUSE_DOWN(event:MouseEvent):void {
		
			click_robot_202.play();
			destroy();
			controller.RemoveAboutWindow();
			
		}
		
		
				// Анимация языковой кнопки
		public function LangTween(direction:String = 'def'):void {
			
			var a:uint = 1;
			var b:uint = 0;

			if (direction == 'pre') { //при загрузке класса
				a = 0;
				b = 1
			}

			if (model.LANG == 1) {
				lang_line.tf1.text = langArr[2][a];
				lang_line.tf2.text = langArr[2][b];
			}
			else if (model.LANG == 0) {
				lang_line.tf1.text = langArr[2][b];
				lang_line.tf2.text = langArr[2][a];
			}
			
			if (direction != 'pre') role_tween1 = new Tween (lang_line, "y", Elastic.easeOut, role_start_y, role_finish_y, 1.9, true);
		}
		
		
		
		public function destroy():void {
		
			ok_button.removeEventListener(MouseEvent.MOUSE_DOWN, ok_button_MOUSE_DOWN);
			LANG_button.removeEventListener(MouseEvent.MOUSE_DOWN, LANG_button_MOUSE_DOWN);
		}
		
		
		
	}
}