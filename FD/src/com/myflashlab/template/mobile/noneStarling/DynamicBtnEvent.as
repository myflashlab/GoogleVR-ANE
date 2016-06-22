package com.myflashlab.template.mobile.noneStarling 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Majid Hejazi
	 */
	public class DynamicBtnEvent extends Event
	{
		public static const CLICKED:String = "clicked";
		public static const BTN_MOUSE_DOWN:String = "btnMouseDown";
		public static const BTN_MOUSE_UP:String = "btnMouseUp";
		
		private var _param:*;
		
		public function DynamicBtnEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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