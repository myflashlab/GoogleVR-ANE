package com.myflashlab.template.mobile.noneStarling 
{
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.text.modules.MySprite;
	import fl.motion.Color;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 		
	 *		
	 * @author Majid Hejazi - 11/25/2014 11:49 AM
	 */
	public class DynamicBtnEnglish extends MySprite
	{
		private var _bgColorOut:uint = 0xffd800;
		private var _bgColorOver:Color;
		private var _textColorOut:uint = 0x333333;
		private var _textColorOver:uint = 0xAAAAAA;
		
		private var _iconColorOut:uint = 0x333333;
		private var _iconColorOver:uint = 0xAAAAAA;
		
		private var _differentIconColor:Boolean = false;
		
		private var _bgRadius:int = 0;
		
		private var _fontSizeLabel:int = 24;
		private var _fontSizeIcon:int = 30;
		
		private var _label:String = "";
		private var _icon:String = "";
		
		private var _labelTxt:TextField;
		private var _iconTxt:TextField;
		private var _fontLabel:String;
		private var _fontIcon:String;
		
		private var _tintValue:Number = 0.8;
		
		private var _rect:Rectangle;
		
		private var _startP:Point;
		
		private var _touch:Boolean;
		
		private var _holdArea:int = 20 * DeviceInfo.dpiScaleMultiplier;
		
		public function DynamicBtnEnglish():void
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
			
			_rect = new Rectangle(0, 0, _width, _height);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onRemoveStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if (_labelTxt)
			{
				this.removeChild(_labelTxt);
				_labelTxt = null;
			}
			
			if (_iconTxt)
			{
				this.removeChild(_iconTxt);
				_iconTxt = null;
			}
			
			if (_rect) _rect = null;
		}
		
		private function initBg():void
		{
			_bgAlpha = 1;
			_bgColor = _bgColorOut;
			_bgBottomLeftRadius = _bgRadius;
			_bgBottomRightRadius = _bgRadius;
			_bgTopLeftRadius = _bgRadius;
			_bgTopRightRadius = _bgRadius;
			drawBg();
		}
		
		private function initText():void
		{
			_iconTxt = new TextField();
			_iconTxt.embedFonts = true;
			_iconTxt.autoSize = TextFieldAutoSize.RIGHT;
			_iconTxt.antiAliasType = AntiAliasType.ADVANCED;
			_iconTxt.selectable = false;
			_iconTxt.height = _height;
			_iconTxt.htmlText = "<p align='center'><font face='" + _fontIcon + "' size='" + _fontSizeIcon + "'>" + _icon + "</font></p>";
			_iconTxt.mouseEnabled = false;
			_iconTxt.textColor = _iconColorOut;
			_iconTxt.multiline = false;
			_iconTxt.wordWrap = false;
			_iconTxt.y = (_height * 0.95 - _iconTxt.textHeight) * 0.5;
			this.addChild(_iconTxt);
			
			_labelTxt = new TextField();
			_labelTxt.embedFonts = true;
			_labelTxt.autoSize = TextFieldAutoSize.LEFT;
			_labelTxt.antiAliasType = AntiAliasType.ADVANCED;
			_labelTxt.selectable = false;
			//_labelTxt.width = _width - _margin * 2;
			//_labelTxt.height = _height;
			_labelTxt.htmlText = "<p align='center'><font face='" + _fontLabel + "' size='" + _fontSizeLabel + "'>" + _label + "</font></p>";
			_labelTxt.mouseEnabled = false;
			_labelTxt.textColor = _textColorOut;
			_labelTxt.multiline = false;
			_labelTxt.wordWrap = false;
			//_labelTxt.y = _height - _labelTxt.textHeight >> 1;
			this.addChild(_labelTxt);
			
			_labelTxt.height = _labelTxt.textHeight;
			_labelTxt.y = _height - _labelTxt.height >> 1;
			
			_iconTxt.width = _iconTxt.textWidth;
			_labelTxt.width = _labelTxt.textWidth;
			
			if (_icon.length > 0 && _label.length > 0) 
			{
				_iconTxt.x = (_width - _iconTxt.width - _labelTxt.width - _margin) * 0.5;
				_labelTxt.x = _iconTxt.x + _iconTxt.width + _margin;
			}
			else if (_icon.length > 0) 
			{
				_iconTxt.x = (_width - _iconTxt.width) * 0.5;
			}
			else if (_label.length > 0) 
			{
				_labelTxt.x = (_width - _labelTxt.width) * 0.5;
			}
		}
		
		private function isContain($point:Point):Boolean
		{
			return _rect.contains($point.x, $point.y);
		}
		
//----------------------------touch control
		
		private function onMouseDown(e:MouseEvent):void
		{
			_startP = new Point(e.localX, e.localY);
			if (isContain(_startP))
			{
				_touch = true;
				_bgColor = _bgColorOver.color;
				drawBg();
				_labelTxt.textColor = _textColorOver;
				_iconTxt.textColor = _iconColorOver;
				dispatchEvent(new DynamicBtnEvent(DynamicBtnEvent.BTN_MOUSE_DOWN));
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (_touch && _startP)
			{
				var moveP:Point = new Point(e.localX, e.localY);
				if (Point.distance(_startP, moveP) > _holdArea)
				{
					_touch = false;
					_bgColor = _bgColorOut;
					drawBg();
					_labelTxt.textColor = _textColorOut;
					_iconTxt.textColor = _iconColorOut;
					dispatchEvent(new DynamicBtnEvent(DynamicBtnEvent.BTN_MOUSE_UP));
				}
			}
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			if (_touch)
			{
				_touch = false;
				_bgColor = _bgColorOut;
				drawBg();
				_labelTxt.textColor = _textColorOut;
				_iconTxt.textColor = _iconColorOut;
				dispatchEvent(new DynamicBtnEvent(DynamicBtnEvent.BTN_MOUSE_UP));
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (_touch && _startP)
			{
				var moveP:Point = new Point(e.localX, e.localY);
				
				_bgColor = _bgColorOut;
				drawBg();
				_labelTxt.textColor = _textColorOut;
				_iconTxt.textColor = _iconColorOut;
				_touch = false;
				
				dispatchEvent(new DynamicBtnEvent(DynamicBtnEvent.BTN_MOUSE_UP));
				
				if (Point.distance(_startP, moveP) <= _holdArea)
				{
					dispatchEvent(new DynamicBtnEvent(DynamicBtnEvent.CLICKED));
				}
			}
		}
		
//----------------------------------------------------------------------- methods

		public function setupColors($textColorOver:uint, $textColorOut:uint, $bgColorOut:uint, $tintValue:Number = 0.8, $differentIconColor:Boolean = false, $iconColorOver:uint = 0, $iconColorOut:uint = 0):void
		{
			_textColorOver = $textColorOver;
			_textColorOut = $textColorOut;
			_differentIconColor = $differentIconColor;
			if (_differentIconColor)
			{
				_iconColorOut = $iconColorOut;
				_iconColorOver = $iconColorOver;
			}
			else
			{
				_iconColorOut = $textColorOut;
				_iconColorOver = $textColorOver;
			}
			_bgColorOut = $bgColorOut;
			_tintValue = $tintValue;
			
			_bgColorOver = new Color();
			_bgColorOver.setTint(_bgColorOut, _tintValue);
			
			if (stage)
			{
				if (_labelTxt && _labelTxt.stage)
				{
					_labelTxt.textColor = _textColorOut;
				}
				
				if (_iconTxt && _iconTxt.stage)
				{
					_iconTxt.textColor = _iconColorOut;
				}
				
				_bgColor = _bgColorOut;
				drawBg();
			}
			
		}
		
		public function setupFont($fontLabel:String, $fontSizeLabel:int, $fontIcon:String, $fontSizeIcon:int):void
		{
			_fontLabel = $fontLabel;
			_fontSizeLabel = $fontSizeLabel;
			_fontIcon = $fontIcon;
			_fontSizeIcon = $fontSizeIcon;
		}
		

//----------------------------------------------------------------------- properties
		
		public function get label():String
		{
			return _label;
		}
		public function set label(a:String):void
		{
			_label = a;
			if (_labelTxt) 
			{
				_labelTxt.htmlText = "<p align='center'><font face='" + _fontLabel + "' size='" + _fontSizeLabel + "'>" + _label + "</font></p>";
				
				_iconTxt.width = _iconTxt.textWidth;
				_labelTxt.width = _labelTxt.textWidth;
				
				if (_icon.length > 0 && _label.length > 0) 
				{
					_iconTxt.x = (_width - _iconTxt.width - _labelTxt.width - _margin) * 0.5;
					_labelTxt.x = _iconTxt.x + _iconTxt.width + _margin;
				}
				else if (_icon.length > 0) 
				{
					_iconTxt.x = (_width - _iconTxt.width) * 0.5;
				}
				else if (_label.length > 0) 
				{
					_labelTxt.x = (_width - _labelTxt.width) * 0.5;
				}
			}
		}
		
		public function get icon():String
		{
			return _icon;
		}
		public function set icon(a:String):void
		{
			_icon = a;
			if (_iconTxt) 
			{
				_iconTxt.htmlText = "<p align='center'><font face='" + _fontIcon + "' size='" + _fontSizeIcon + "'>" + _icon + "</font></p>";
				
				_iconTxt.width = _iconTxt.textWidth;
				_labelTxt.width = _labelTxt.textWidth;
				
				if (_icon.length > 0 && _label.length > 0) 
				{
					_iconTxt.x = (_width - _iconTxt.width - _labelTxt.width - _margin) * 0.5;
					_labelTxt.x = _iconTxt.x + _iconTxt.width + _margin;
				}
				else if (_icon.length > 0) 
				{
					_iconTxt.x = (_width - _iconTxt.width) * 0.5;
				}
				else if (_label.length > 0) 
				{
					_labelTxt.x = (_width - _labelTxt.width) * 0.5;
				}
			}
		}
		
		public function get bgRadius():int
		{
			return _bgRadius;
		}
		public function set bgRadius(a:int):void
		{
			_bgRadius = a;
		}
		
		public function set holdArea(a:int):void
		{
			_holdArea = a * DeviceInfo.dpiScaleMultiplier;
		}
		
	}

}