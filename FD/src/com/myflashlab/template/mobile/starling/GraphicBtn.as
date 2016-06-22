package com.myflashlab.template.mobile.starling 
{
	import com.doitflash.starling.MyStarlingSprite;
	import com.xtdstudios.DMT.starlingConverter.StarlingImageProxy;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import starling.extensions.RTL_BitmapFont.RTLTextField;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.VAlign;
	import starling.utils.HAlign;
	
	/**
	 * 		var mc:MovieClip = _baseData.dmt.getAssetByUniqueAlias("icBack") as MovieClip;
	 *		var btn0:GraphicBtn = new GraphicBtn();
	 *		btn0.addEventListener(MouseEvent.CLICK, onBack);
	 *		btn0.setupTextures(mc.getFrameTexture(0), mc.getFrameTexture(1));
	 *		this.addChild(btn0);
	 *		
	 * @author Hadi Tavakoli - 9/17/2014 10:27 AM
	 */
	public class GraphicBtn extends MyStarlingSprite
	{
		private var _outImg:Image;
		private var _overImg:Image;
		
		public function GraphicBtn():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			
			
		}
		
		private function onAddedStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			this.addChild(_outImg);
			this.addChild(_overImg);
			_overImg.visible = false;
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onRemoveStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			removeEventListener(MouseEvent.CLICK, onClick);
			
			if (_outImg)
			{
				_outImg.removeFromParent(true);
				_outImg.dispose();
				_outImg = null;
				
				_overImg.removeFromParent(true);
				_overImg.dispose();
				_overImg = null;
			}
		}
		
		
		
		private function onOver(e:Event):void
		{
			_overImg.visible = true;
		}
		
		private function onOut(e:Event):void
		{
			_overImg.visible = false;
		}
		
		private function onClick(e:Event):void
		{
			_overImg.visible = false;
		}
		
//----------------------------------------------------------------------- methods

		public function setupTextures($out:Texture, $over:Texture):void
		{
			_outImg = new Image($out);
			_overImg = new Image($over);
			
			_width = _outImg.width;
			_height = _outImg.height;
		}

//----------------------------------------------------------------------- properties
		
		
		
	}

}