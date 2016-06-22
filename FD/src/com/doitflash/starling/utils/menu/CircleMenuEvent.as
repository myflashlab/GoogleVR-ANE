package com.doitflash.starling.utils.menu
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Majid Hejazi
	 */
	public class CircleMenuEvent extends Event
	{
		public static const TOUCH_PHOTO:String = "touchPhoto";
		public static const TOUCH_ICON:String = "touchIcon";
		public static const TOUCH_ICON_IS_UP:String = "touchIconISUp";
		
		private var _param:*;
		
		public function CircleMenuEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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