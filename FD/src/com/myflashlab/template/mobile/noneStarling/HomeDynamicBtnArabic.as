package com.myflashlab.template.mobile.noneStarling 
{
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.text.modules.MySprite;
	import fl.motion.Color;
	import flash.display.Shape;
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
	public class HomeDynamicBtnArabic extends MySprite
	{
		private var _bgLineColor:uint = 0xffd800;
		private var _bgColorOut:uint = 0xffd800;
		private var _bgColorOver:Color;
		private var _textColorOut:uint = 0x333333;
		private var _textColorOver:uint = 0xAAAAAA;
		
		private var _bgRadius:int = 0;
		
		private var _fontSizeLabel:int = 24;
		private var _fontSizeIcon:int = 30;
		
		private var _label:String = "";
		private var _icon:String = "";
		
		private var _labelTxt:TLFTextField;
		private var _iconTxt:TextField;
		private var _fontLabel:String;
		private var _fontIcon:String;
		
		private var _iconHeightRatio:Number = 0.5;
		
		private var _iconHeight:int;
		private var _labelHeight:int;
		
		private var _tintValue:Number = 0.8;
		
		private var _rect:Rectangle;
		
		private var _startP:Point;
		
		private var _touch:Boolean;
		
		private var _holdArea:int = 20 * DeviceInfo.dpiScaleMultiplier;
		
		private var _line:Shape;
		
		public function HomeDynamicBtnArabic():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			
			_margin = 5;
		}
		
		private function onAddedStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			_iconHeight = _height * _iconHeightRatio;
			_labelHeight = _height - _iconHeight - 1;
			
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
			
			if (_line)
			{
				this.removeChild(_line);
				_line = null;
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
			
			_line = new Shape();
			_line.graphics.lineStyle(1, _bgLineColor, 1);
			_line.graphics.moveTo(0, _iconHeight + 1);
			_line.graphics.lineTo(_width, _iconHeight + 1);
			_line.graphics.endFill();
			this.addChild(_line);
		}
		
		private function initText():void
		{
			_iconTxt = new TextField();
			_iconTxt.embedFonts = true;
			_iconTxt.autoSize = TextFieldAutoSize.LEFT;
			_iconTxt.antiAliasType = AntiAliasType.ADVANCED;
			_iconTxt.selectable = false;
			_iconTxt.height = _iconHeight;
			_iconTxt.htmlText = "<p align='center'><font face='" + _fontIcon + "' size='" + _fontSizeIcon + "'>" + _icon + "</font></p>";
			_iconTxt.mouseEnabled = false;
			_iconTxt.textColor = _textColorOut;
			_iconTxt.multiline = false;
			_iconTxt.wordWrap = false;
			_iconTxt.y = (_iconHeight - _iconTxt.textHeight) * 0.5;
			this.addChild(_iconTxt);
			_iconTxt.x = _width - _iconTxt.textWidth >> 1;
			
			_labelTxt = new TLFTextField();
			_labelTxt.embedFonts = true;
			_labelTxt.autoSize = TextFieldAutoSize.RIGHT;
			_labelTxt.antiAliasType = AntiAliasType.ADVANCED;
			_labelTxt.selectable = false;
			_labelTxt.height = _labelHeight;
			_labelTxt.htmlText = "<p align='center'><font face='" + _fontLabel + "' size='" + _fontSizeLabel + "'>" + _label + "</font></p>";
			_labelTxt.direction = Direction.RTL;
			_labelTxt.verticalAlign = VerticalAlign.MIDDLE;
			_labelTxt.mouseEnabled = false;
			_labelTxt.mouseChildren = false;
			_labelTxt.textColor = _textColorOut;
			_labelTxt.multiline = false;
			_labelTxt.wordWrap = false;
			this.addChild(_labelTxt);
			_labelTxt.y = _height - _labelHeight + (_labelHeight - _labelTxt.textHeight) * 0.5;
			_labelTxt.x = _width - _labelTxt.textWidth >> 1;
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
				_iconTxt.textColor = _textColorOver;
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
					_iconTxt.textColor = _textColorOut;
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
				_iconTxt.textColor = _textColorOut;
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
				_iconTxt.textColor = _textColorOut;
				_touch = false;
				
				dispatchEvent(new DynamicBtnEvent(DynamicBtnEvent.BTN_MOUSE_UP));
				
				if (Point.distance(_startP, moveP) <= _holdArea)
				{
					dispatchEvent(new DynamicBtnEvent(DynamicBtnEvent.CLICKED));
				}
			}
		}
		
//----------------------------------------------------------------------- methods

		public function setupColors($textColorOver:uint, $textColorOut:uint, $bgColorOut:uint, $tintValue:Number = 0.8, $bgLineColor:uint = 0xffd800):void
		{
			_textColorOver = $textColorOver;
			_textColorOut = $textColorOut;
			_bgColorOut = $bgColorOut;
			_tintValue = $tintValue;
			
			_bgColorOver = new Color();
			_bgColorOver.setTint(_bgColorOut, _tintValue);
			
			_bgLineColor = $bgLineColor;
			
			if (stage)
			{
				if (_labelTxt && _labelTxt.stage)
				{
					_labelTxt.textColor = _textColorOut;
				}
				
				if (_iconTxt && _iconTxt.stage)
				{
					_iconTxt.textColor = _textColorOut;
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
				this.removeChild(_labelTxt);
				_labelTxt.embedFonts = true;
				_labelTxt.autoSize = TextFieldAutoSize.RIGHT;
				_labelTxt.antiAliasType = AntiAliasType.ADVANCED;
				_labelTxt.selectable = false;
				_labelTxt.height = _labelHeight;
				_labelTxt.htmlText = "<p align='center'><font face='" + _fontLabel + "' size='" + _fontSizeLabel + "'>" + _label + "</font></p>";
				_labelTxt.direction = Direction.RTL;
				_labelTxt.verticalAlign = VerticalAlign.MIDDLE;
				_labelTxt.mouseEnabled = false;
				_labelTxt.mouseChildren = false;
				_labelTxt.textColor = _textColorOut;
				_labelTxt.multiline = false;
				_labelTxt.wordWrap = false;
				this.addChild(_labelTxt);
				_labelTxt.y = _height - _labelHeight + (_labelHeight - _labelTxt.textHeight) * 0.5;
				_labelTxt.x = _width - _labelTxt.textWidth >> 1;
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
				_iconTxt.x = _width - _iconTxt.textWidth >> 1;
				_iconTxt.y = (_iconHeight - _iconTxt.textHeight) * 0.5;
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
		
		public function get iconHeightRatio():Number
		{
			return _iconHeightRatio;
		}
		public function set iconHeightRatio(a:Number):void
		{
			_iconHeightRatio = a;
		}
		
		public function set holdArea(a:int):void
		{
			_holdArea = a * DeviceInfo.dpiScaleMultiplier;
		}
		
	}

}