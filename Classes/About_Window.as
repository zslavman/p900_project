package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.media.Sound;
	
	
	
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
		private var click_sound1:Sound = new _click_sound1();
		private var click_robot_202:Sound = new _click_robot_202();
		
		
	
		
		public function About_Window(_model:Model, _controller:Controller) {
		
			model = _model;
			controller = _controller;
			langArr = Model.langArr;
			
			ok_button.addEventListener(MouseEvent.MOUSE_DOWN, ok_button_MOUSE_DOWN);
			ok_button.buttonMode = true;
			ok_button.mouseChildren = false;
			
			LANG_button.addEventListener(MouseEvent.MOUSE_DOWN, LANG_button_MOUSE_DOWN);
			LANG_button.buttonMode = true;
			LANG_button.mouseChildren = false;
			lang_line.mouseEnabled = false;
			lang_line.mouseChildren = false;
			
			role_start_y = lang_line.y;
			role_finish_y = lang_line.y + 43;//43
			
			LangTween('pre');
			//FillTextFields();
		
		}
		
		
		
		
		
		
		
		/*********************************************
		 *       Ф-ция заполнения текст. полей       *
		 *                                           *
		 *///*****************************************
		public function FillTextFields():void {
			
			
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