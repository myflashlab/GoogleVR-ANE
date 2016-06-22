package com.myflashlab.template.mobile.noneStarling 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Majid Hejazi
	 */
	public class InputTextFieldEvent extends Event
	{
		public static const CHANGE_TEXT_OF_DEFAULT:String = "changeTextOfDefault";
		public static const CHANGE_TEXT_TO_DEFAULT:String = "changeTextToDefault";
		
		public static const SOFT_KEYBOARD_ACTIVED:String = "sontKeyboardAvtived";
		public static const SOFT_KEYBOARD_DEACTIVED:String = "sontKeyboardDeavtived";
		
		private var _param:*;
		
		public function InputTextFieldEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			_param = data;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @private
		 */
		public function get param():*
		{
			return _param;
		}
		
	}

}