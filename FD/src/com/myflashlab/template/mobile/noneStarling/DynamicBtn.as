package com.myflashlab.template.mobile.noneStarling 
{
	import com.doitflash.text.modules.MySprite;
	import events.MyEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import fl.motion.Color;
	import flash.text.TextFormat;
	
	import fl.text.TLFTextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.VerticalAlign;
	import flash.text.TextFieldType;
	
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	
	/**
	 * 		
	 *		
	 * @author Majid Hejazi - 11/25/2014 11:49 AM
	 */
	public class DynamicBtn extends MySprite
	{
		public static const LTR:String = "ltr";
		public static const RTL:String = "rtl";
		
		private var _bgColorOut:uint = 0xffd800;
		private var _bgColorOver:Color;
		private var _textColorOut:uint = 0x333333;
		private var _textColorOver:uint = 0xAAAAAA;
		
		private var _bgRadius:int = 0;
		
		private var _fontSize:int = 25;
		
		private var _label:String = "";
		
		private var _txt:TLFTextField;
		private var _lang:String = DynamicBtn.LTR;
		private var _font:String;
		
		private var _tintValue:Number = 0.8;
		
		private var _rect:Rectangle;
		
		private var _startP:Point;
		
		private var _touch:Boolean;
		
		private var _holdArea:int = 20 * DeviceInfo.dpiScaleMultiplier;
		
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
			if(!_txt) initText();
			
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
			
			if (_txt)
			{
				this.removeChild(_txt);
				_txt = null;
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
			_txt = new TLFTextField();
			_txt.embedFonts = true;
			_txt.autoSize = TextFieldAutoSize.NONE;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.selectable = false;
			_txt.width = _width - _margin * 2;
			_txt.height = _height;
			_txt.htmlText = "<p align='center'><font face='" + _font + "' size='" + _fontSize + "'>" + _label + "</font></p>";
			if (_lang == RTL) _txt.direction = Direction.RTL;		
			else if (_lang == LTR) _txt.direction = Direction.LTR;
			_txt.verticalAlign = VerticalAlign.MIDDLE;
			_txt.mouseEnabled = false;
			_txt.mouseChildren = false;
			_txt.textColor = _textColorOut;
			//_txt.defaultTextFormat = new TextFormat(_font, _fontSize, _textColorOut);
			_txt.x = _margin;
			_txt.y = _height - _txt.height >> 1;
			this.addChild(_txt);
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
				_txt.textColor = _textColorOver;
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
					_txt.textColor = _textColorOut;
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
				_txt.textColor = _textColorOut;
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (_touch && _startP)
			{
				var moveP:Point = new Point(e.localX, e.localY);
				
				_bgColor = _bgColorOut;
				drawBg();
				_txt.textColor = _textColorOut;
				_touch = false;
				
				if (Point.distance(_startP, moveP) <= _holdArea)
				{
					dispatchEvent(new MyEvent(MyEvent.CLICKED));
				}
			}
		}
		
//----------------------------------------------------------------------- methods

		public function setupColors($textColorOver:uint, $textColorOut:uint, $bgColorOut:uint, $tintValue:Number = 0.8):void
		{
			_textColorOver = $textColorOver;
			_textColorOut = $textColorOut;
			_bgColorOut = $bgColorOut;
			_tintValue = $tintValue;
			
			_bgColorOver = new Color();
			_bgColorOver.setTint(_bgColorOut, _tintValue);
		}
		
		public function setupFont($lang:String, $font:String, $fontSize:int):void
		{
			_lang = $lang;
			_font = $font;
			_fontSize = $fontSize;
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
				//_txt.text = _label;
				_txt.htmlText = "<p align='center'><font face='" + _font + "' size='" + _fontSize + "'>" + _label + "</font></p>"
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