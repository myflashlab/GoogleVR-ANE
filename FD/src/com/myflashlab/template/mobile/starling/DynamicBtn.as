package com.myflashlab.template.mobile.starling 
{
	import com.doitflash.starling.MyStarlingSprite;
	import com.doitflash.consts.Position;
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
	 * 		var btn:DynamicBtn = new DynamicBtn();
	 *		btn.addEventListener(MouseEvent.CLICK, onClick);
	 *		btn.width = 100;
	 *		btn.height = 100;
	 *		btn.setupFont(DynamicBtn.RTL, "B Koodak", 50);
	 *		btn.setupColors(_textures.bgTexture3, 0x88ff44, 0xffd800, 0x333333, 0xAAAAAA);
	 * 		btn_start.setupIcon(_baseData.dmt.getAssetByUniqueAlias("icArrow") as Image, _baseData.dmt.getAssetByUniqueAlias("icArrow") as Image, Position.RIGHT);
	 *		btn.label = "دکمه!";
	 *		
	 *		btn.x = _width - btn.width;
	 *		this.addChild(btn);
	 *		
	 * @author Hadi Tavakoli - 9/16/2014 10:27 AM
	 */
	public class DynamicBtn extends MyStarlingSprite
	{
		public static const LTR:String = "ltr";
		public static const RTL:String = "rtl";
		
		private var _texture:Texture;
		private var _bgImg:Image;
		
		private var _bgColorOver:uint = 0xffd800;
		private var _bgColorOut:uint = 0xffd800;
		private var _textColorOut:uint = 0x333333;
		private var _textColorOver:uint = 0xAAAAAA;
		
		private var _fontSize:int = 25;
		
		private var _label:String = "";
		
		private var _txt:*;
		private var _lang:String = DynamicBtn.LTR;
		private var _font:String;
		
		private var _iconOver:Image;
		private var _iconOut:Image;
		private var _iconPosition:String;
		
		public function DynamicBtn():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			
			_margin = 5;
		}
		
		private function onAddedStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			initBg();
			initText();
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onRemoveStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function initBg():void
		{
			if (_bgImg) return;
			
			_bgImg = new Image(_texture);
			_bgImg.width = _width;
			_bgImg.height = _height;
			_bgImg.color = _bgColorOut;
			this.addChild(_bgImg);
		}
		
		private function initText():void
		{
			if (_txt) return;
			
			var iconSpace:Number = 0.3;
			var txtSpace:Number = 1;
			if (_iconOver)
			{
				txtSpace = 0.7;
				
				_iconOver.height = _iconOver.width = Math.min((_width - _margin * 2) * iconSpace, _height - _margin * 2);
				
				_iconOut.width = _iconOver.width;
				_iconOut.height = _iconOver.height;
				
				if (_iconPosition == Position.RIGHT) _iconOver.x = _width - _iconOver.width - _margin;
				else if (_iconPosition == Position.LEFT) _iconOver.x = _margin;
				
				_iconOver.y = _height - _iconOver.height >> 1;
				
				_iconOut.x = _iconOver.x;
				_iconOut.y = _iconOver.y;
				
				this.addChild(_iconOver);
				this.addChild(_iconOut);
				
				_iconOver.visible = false;
			}
			
			if (_lang == DynamicBtn.LTR) 		_txt = new TextField	((_width - _margin*2) * txtSpace, _height - _margin*2, _label, _font, _fontSize, 0xFFFFFF);
			else if (_lang == DynamicBtn.RTL) 	_txt = new RTLTextField	((_width - _margin*2) * txtSpace, _height - _margin*2, _label, _font, _fontSize, 0xFFFFFF);
			
			_txt.touchable = false;
			_txt.batchable = true;
			_txt.hAlign = HAlign.CENTER;
			_txt.vAlign = VAlign.CENTER;
			_txt.color = _textColorOut;
			_txt.autoScale = true;
			_txt.x = _margin;
			_txt.y = this.height - _txt.height >> 1;
			this.addChild(_txt);
			
			if (_iconOver)
			{
				if (_iconPosition == Position.RIGHT) _txt.x = _margin;
				else if (_iconPosition == Position.LEFT) _txt.x = _width - _txt.width - _margin;
			}
		}
		
		private function onOver(e:Event):void
		{
			_bgImg.color = _bgColorOver;
			_txt.color = _textColorOver;
			if (_iconOver)
			{
				_iconOver.visible = true;
				_iconOut.visible = false;
			}
		}
		
		private function onOut(e:Event):void
		{
			_bgImg.color = _bgColorOut;
			_txt.color = _textColorOut;
			
			if (_iconOver)
			{
				_iconOver.visible = false;
				_iconOut.visible = true;
			}
		}
		
		private function onClick(e:Event):void
		{
			onOut(e);
		}
		
//----------------------------------------------------------------------- methods

		public function setupColors($texture:Texture, $textColorOver:uint, $textColorOut:uint, $bgColorOver:uint, $bgColorOut:uint):void
		{
			_texture = $texture;
			_textColorOver = $textColorOver;
			_textColorOut = $textColorOut;
			_bgColorOver = $bgColorOver;
			_bgColorOut = $bgColorOut;
		}
		
		public function setupFont($lang:String, $font:String, $fontSize:int):void
		{
			_lang = $lang;
			_font = $font;
			_fontSize = $fontSize;
		}
		
		public function setupIcon($icon:Image, $iconOver:Image, $position:String):void
		{
			_iconOut = $icon;
			if (!$iconOver) _iconOver = _iconOut;
			else _iconOver = $iconOver;
			_iconPosition = $position;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if (_bgImg)
			{
				_bgImg.removeFromParent(true);
				_bgImg.dispose();
				_bgImg = null;
			}
			
			if (_txt)
			{
				_txt.removeFromParent(true);
				_txt.dispose();
				_txt = null;
			}
			
			if (_iconOver)
			{
				_iconOver.removeFromParent(true);
				_iconOver.dispose();
				_iconOver = null;
			}
			
			if (_iconOut)
			{
				_iconOut.removeFromParent(true);
				_iconOut.dispose();
				_iconOut = null;
			}
		}

//----------------------------------------------------------------------- properties
		
		public function get label():String
		{
			return _label;
		}
		public function set label(a:String):void
		{
			_label = a;
			
			if (_txt)
			{
				_txt.text = _label;
			}
		}
		
	}

}