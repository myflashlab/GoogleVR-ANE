package com.myflashlab.template.mobile.noneStarling 
{
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.text.modules.MySprite;
	import fl.motion.Color;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fl.text.TLFTextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.VerticalAlign;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	
	/**
	 * 		
	 *		
	 * @author Majid Hejazi - 11/25/2014 11:49 AM
	 */
	public class MenuDynamicBtnArabic extends MySprite
	{
		private var _bgColorOut:uint = 0xffd800;
		private var _bgColorOver:Color;
		private var _textColorOut:uint = 0x333333;
		private var _textColorOver:uint = 0xAAAAAA;
		private var _iconColorOut:uint = 0x333333;
		private var _iconColorOver:uint = 0xAAAAAA;
		
		private var _bgRadius:int = 0;
		
		private var _fontSizeLabel:int = 24;
		private var _fontSizeIcon:int = 30;
		
		private var _label:String = "";
		private var _icon:String = "";
		
		private var _txtLabel:TLFTextField;
		private var _txtIcon:TextField;
		private var _fontLabel:String;
		private var _fontIcon:String;
		
		private var _tintValue:Number = 0.8;
		
		private var _rect:Rectangle;
		
		private var _startP:Point;
		
		private var _touch:Boolean;
		
		private var _ratioMarginLeft:Number = 0.05;
		private var _ratioMarginBetween:Number = 0.05;
		private var _ratioMarginRight:Number = 0.05;
		private var _ratioIconWidth:Number = 0.2;
		private var _ratioLabelWidth:Number = 0.65;
		
		private var _marginLeft:int = 0;
		private var _marginBetween:int = 0;
		private var _marginRight:int = 0;
		private var _iconWidth:int = 0;
		private var _labelWidth:int = 0;
		
		private var _holdArea:int = 20 * DeviceInfo.dpiScaleMultiplier;
		
		public function MenuDynamicBtnArabic():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			
			_margin = 5;
		}
		
		private function onAddedStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			_marginLeft = _width * _ratioMarginLeft;
			_marginBetween = _width * _ratioMarginBetween;
			_marginRight = _width * _ratioMarginRight;
			_iconWidth = _width * _ratioIconWidth;
			_labelWidth = _width * _ratioLabelWidth;
			
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
			
			if (_txtLabel)
			{
				this.removeChild(_txtLabel);
				_txtLabel = null;
			}
			
			if (_txtIcon)
			{
				this.removeChild(_txtIcon);
				_txtIcon = null;
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
			_txtIcon = new TextField();
			_txtIcon.embedFonts = true;
			_txtIcon.autoSize = TextFieldAutoSize.NONE;
			_txtIcon.antiAliasType = AntiAliasType.ADVANCED;
			_txtIcon.selectable = false;
			_txtIcon.width = _iconWidth;
			_txtIcon.height = _height;
			_txtIcon.htmlText = "<p align='right'><font face='" + _fontIcon + "' size='" + _fontSizeIcon + "'>" + _icon + "</font></p>";
			_txtIcon.mouseEnabled = false;
			_txtIcon.textColor = _iconColorOut;
			_txtIcon.multiline = false;
			_txtIcon.wordWrap = false;
			_txtIcon.x = _width - _marginRight - _iconWidth;
			_txtIcon.y = _height - _txtIcon.textHeight >> 1;
			this.addChild(_txtIcon);
			
			_txtLabel = new TLFTextField();
			_txtLabel.embedFonts = true;
			_txtLabel.autoSize = TextFieldAutoSize.NONE;
			_txtLabel.antiAliasType = AntiAliasType.ADVANCED;
			_txtLabel.selectable = false;
			_txtLabel.width = _labelWidth;
			//_txtLabel.height = _height;
			_txtLabel.htmlText = "<p align='right'><font face='" + _fontLabel + "' size='" + _fontSizeLabel + "'>" + _label + "</font></p>";
			_txtLabel.direction = Direction.RTL;
			_txtLabel.verticalAlign = VerticalAlign.MIDDLE;
			_txtLabel.mouseEnabled = false;
			_txtLabel.mouseChildren = false;
			_txtLabel.textColor = _textColorOut;
			_txtLabel.multiline = false;
			_txtLabel.wordWrap = false;
			_txtLabel.x = _txtIcon.x - _marginBetween - _labelWidth;
			//_txtLabel.y = _height - _txtLabel.textHeight >> 1;
			this.addChild(_txtLabel);
			
			_txtLabel.height = _txtLabel.textHeight;
			_txtLabel.y = _height - _txtLabel.height >> 1;
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
				_txtLabel.textColor = _textColorOver;
				_txtIcon.textColor = _iconColorOver;
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
					_txtLabel.textColor = _textColorOut;
					_txtIcon.textColor = _iconColorOut;
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
				_txtLabel.textColor = _textColorOut;
				_txtIcon.textColor = _iconColorOut;
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
				_txtLabel.textColor = _textColorOut;
				_txtIcon.textColor = _iconColorOut;
				_touch = false;
				
				dispatchEvent(new DynamicBtnEvent(DynamicBtnEvent.BTN_MOUSE_UP));
				
				if (Point.distance(_startP, moveP) <= _holdArea)
				{
					dispatchEvent(new DynamicBtnEvent(DynamicBtnEvent.CLICKED));
				}
			}
		}
		
//----------------------------------------------------------------------- methods

		public function setupColors($textColorOver:uint, $textColorOut:uint, $iconColorOver:uint, $iconColorOut:uint, $bgColorOut:uint, $tintValue:Number = 0.8):void
		{
			_textColorOver = $textColorOver;
			_textColorOut = $textColorOut;
			_iconColorOver = $iconColorOver;
			_iconColorOut = $iconColorOut;
			_bgColorOut = $bgColorOut;
			_tintValue = $tintValue;
			
			_bgColorOver = new Color();
			_bgColorOver.setTint(_bgColorOut, _tintValue);
			
			if (stage)
			{
				if (_txtLabel && _txtLabel.stage)
				{
					_txtLabel.textColor = _textColorOut;
				}
				
				if (_txtIcon && _txtIcon.stage)
				{
					_txtIcon.textColor = _iconColorOut;
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
		
		public function setDimentions($ratioMarginLeft:Number = 0.05, $ratioMarginBetween:Number = 0.05, $ratioMarginRight:Number = 0.05, $ratioIconWidth:Number = 0.2):void
		{
			_ratioMarginLeft = $ratioMarginLeft;
			_ratioMarginBetween = $ratioMarginBetween;
			_ratioMarginRight = $ratioMarginRight;
			_ratioIconWidth = $ratioIconWidth;
			_ratioLabelWidth = 1 - (_ratioMarginLeft + _ratioMarginBetween + _ratioMarginRight + _ratioIconWidth);
		}
		

//----------------------------------------------------------------------- properties
		
		public function get label():String
		{
			return _label;
		}
		public function set label(a:String):void
		{
			_label = a;
			if (_txtLabel) _txtLabel.htmlText = "<p align='right'><font face='" + _fontLabel + "' size='" + _fontSizeLabel + "'>" + _label + "</font></p>";
		}
		
		public function get icon():String
		{
			return _icon;
		}
		public function set icon(a:String):void
		{
			_icon = a;
			if (_txtIcon) _txtIcon.htmlText = "<p align='right'><font face='" + _fontIcon + "' size='" + _fontSizeIcon + "'>" + _icon + "</font></p>";
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