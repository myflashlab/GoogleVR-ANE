package com.doitflash.starling
{
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * 
	 * @author Hadi Tavakoli - 7/11/2013 3:41 PM
	 */
	public class MovieClip extends starling.display.MovieClip 
	{
		protected var _data:Object = { };
		
		public function MovieClip(textures:Vector.<Texture>, fps:Number=12)
		{
			super(textures, fps);
		}
		
		public function set data(a:Object):void
		{
			_data = a;
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
	
}