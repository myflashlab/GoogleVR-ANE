package com.doitflash.starling.charts
{
	
	
	public class Axis
	{
		private var _type:String;
		public var name:String = "axis";
		
		public var prefix:String = "";
		public var suffix:String = "";
		
		public var min:Number = 0;
		public var max:Number = 0;
		
		public var start:Number = 0;
		public var end:Number = 100;
		public var period:Number = 10;
		
		/**
		 * if highlight is 0, all the periods will be shown.
		 */
		public var highlight:Number = 0;
		
		public function Axis($type:String):void
		{
			_type = $type;
		}
		
// --------------------------------------------------------------------------------------------- private

		

// --------------------------------------------------------------------------------------------- helpful

		

// --------------------------------------------------------------------------------------------- Methods

		

// --------------------------------------------------------------------------------------------- getter - setter

		public function get type():String
		{
			return _type;
		}
	}
}