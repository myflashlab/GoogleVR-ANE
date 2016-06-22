package com.doitflash.starling
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import com.doitflash.text.TextArea;
	
	/**
	 * ...
	 * 
	 * @author Hadi Tavakoli - 8/7/2012 12:39 PM
	 */
	public class TextArea extends MyStarlingSprite 
	{
		private var _txt:com.doitflash.text.TextArea = new com.doitflash.text.TextArea();
		private var _bmd:BitmapData;
		private var _texture:Texture;
		private var _img:Image;
		
		private const MAX_TEXTURE_SIZE:Number = 2048;
		private const MAX_BITMAPDATA_SIZE:Number = 8192;
		
		public function TextArea():void
		{
			//this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
		}
		
		/*private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			
		}*/
		
		
		
//----------------------------------------------------------------------------------------------------- Methods

		public function refresh($scale:Number=1):void
		{
			if (_bmd) _bmd.dispose();
			if (_texture) _texture.dispose();
			if (_img) 
			{
				_img.dispose();
				this.removeChild(_img, true);
			}
			
			/*if (_txt.height > MAX_BITMAPDATA_SIZE)
			{
				
			}*/
			
			_bmd = new BitmapData(_txt.width * $scale, _txt.height, true, 0x00000000);
			var matrix:Matrix = new Matrix();
			matrix.scale($scale, $scale);
			_bmd.draw(_txt, matrix, null, null, null, true);
			
			if (_bmd.height > MAX_TEXTURE_SIZE)
			{
				var numRequiredTextures:int = Math.ceil(_bmd.height / MAX_TEXTURE_SIZE);
				
				for (var i:int = 0; i < numRequiredTextures; i++) 
				{
					var bmdHeight:Number = MAX_TEXTURE_SIZE;
					if (i == numRequiredTextures - 1) bmdHeight = _bmd.height - (i * MAX_TEXTURE_SIZE);
					
					var tmpBmd:BitmapData = new BitmapData(_bmd.width, bmdHeight, true, 0x00000000);
					tmpBmd.copyPixels(_bmd, new Rectangle(0, i * MAX_TEXTURE_SIZE, _bmd.width, bmdHeight), new Point(0, 0));
					
					var img:Image = new Image(Texture.fromBitmapData(tmpBmd));
					img.y = i * MAX_TEXTURE_SIZE;
					this.addChild(img);
				}
			}
			else
			{
				_texture = Texture.fromBitmapData(_bmd);
				_img = new Image(_texture);
				this.addChild(_img);
			}
			
			_width = _bmd.width;
			_height = _bmd.height;
		}

//----------------------------------------------------------------------------------------------------- Getter - Setter
		
		public function get txt():com.doitflash.text.TextArea
		{
			return _txt;
		}
		
		public function get img():Image
		{
			return _img;
		}
	}
	
}