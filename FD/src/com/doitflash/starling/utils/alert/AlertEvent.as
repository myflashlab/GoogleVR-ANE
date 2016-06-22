package com.doitflash.starling.utils.alert
{
	import flash.events.Event;
	
	/**
	 * AlertEvent class shows all the events being dispatched by the Alert.
	 * @author Ali Tavakoli
	 */
	public class AlertEvent extends Event
	{
		/**
		 * Dispatches when the mask width is modified.
		 */
		public static const MASK_WIDTH:String = "myMaskWidth";
		
		
		private var _param:*;
		
		/**
		 * @private
		 * @param	type
		 * @param	data
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function AlertEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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