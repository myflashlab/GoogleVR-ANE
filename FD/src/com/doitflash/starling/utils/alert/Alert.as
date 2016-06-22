package com.doitflash.starling.utils.alert
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.utils.getTimer;
	//import flash.events.TimerEvent;
	//import flash.utils.Timer;
	
	import com.greensock.plugins.*;
	import com.greensock.*; 
	import com.greensock.events.*;
	import com.greensock.easing.*;
	//import com.greensock.easing.EaseLookup;
	
	import com.doitflash.starling.utils.alert.AlertEvent;
	import com.doitflash.consts.Easing;
	
	
	/**
	 * Alert is an abstract class that helps you to easily create Alert windows in your projects, specially useful in mobile app projects, 3D environment and Starling projects.
	 * 
	 * <b>Copyright 2012-2013, MyAppSnippet. All rights reserved.</b>
	 * For seeing the scroll preview and sample files visit <a href="http://myappsnippet.com/">http://www.myappsnippet.com/</a>
	 * 
	 * @see com.doitflash.starling.utils.alert.AlertEvent
	 * @see com.doitflash.consts.Easing
	 * 
	 * @author Ali Tavakoli - 8/31/2013 4:06 PM
	 * modified - 8/31/2013 4:06 PM
	 * @version 1.0
	 * 
	 * @example The following example shows you how to create a simple Alert window and make it work.
	 * 
	 * <listing version="3.0">
	 * import com.doitflash.starling.utils.alert.Alert;
	 * import com.doitflash.starling.utils.alert.AlertEvent;
	 * import com.doitflash.consts.Easing;
	 * 
	 * 
	 * 
	 * </listing>
	 */
	public class Alert extends EventDispatcher
	{
// ----------------------------------------------------------------------------------------------------------------------- vars
		
		TweenPlugin.activate([ThrowPropsPlugin]);
		
		/**
		 * @private
		 * set the object to save the setters value inside it self
		 */
		protected var _propSaver:Object = new Object();
		
		// input vars
		private var _base:*; // it holds everything
		private var _window:Sprite; // it can be dragged
		private var _resizer:*; // it resizes the _window
		private var _stageRec:Rectangle = new Rectangle(0, 0, 300, 300);
		
		private var _easeType:String = Easing.Expo_easeOut;
		private var _duration:Number = .5;
		
		private var _visible:Boolean = true; // it visible/invisible the _base
		
		// needed vars
		private var _touchPoint:Point;
		
// ----------------------------------------------------------------------------------------------------------------------- constructor func
		
		public function Alert():void
		{
			trace("alert!");
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		
		
// ----------------------------------------------------------------------------------------------------------------------- Methods
		
		public function startDrag($point:Point):void
		{
			_touchPoint = $point;
			
		}
		
		
// ----------------------------------------------------------------------------------------------------------------------- Properties
		
		public function set window(a:*):void
		{
			_window = a;
			
			
		}
		
		/**
		 * export the class and send the Object that holds all of the setters values.
		 */
		public function get exportProp():Object
		{
			return _propSaver;
		}
		/**
		 * import the class and get the Object that holds all of the setters values.
		 */
		public function set importProp(a:Object):void
		{
			for (var prop:* in a)
			{
				this[prop] = a[prop];
			}
		}
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}