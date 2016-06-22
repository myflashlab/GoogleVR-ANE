package com.doitflash.starling.utils.menu
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author Ali Tavakoli - 6/3/2013 2:10 PM
	 */
	public class MenuEvent extends Event
	{
		/**
		 * @private
		 */
		public static const OPEN:String = "onOpen";
		public static const CLOSE:String = "onClose";
		
		public static const ITEM_ADDED:String = "onItemAdded";
		public static const ITEM_REMOVED:String = "onItemRemoved";
		
		public static const ITEM_SELECTED:String = "onItemSelected";
		public static const ITEM_UNSELECTED:String = "onItemUnselected";
		
		
		private var _param:*;
		
		/**
		 * 
		 */
		public function MenuEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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