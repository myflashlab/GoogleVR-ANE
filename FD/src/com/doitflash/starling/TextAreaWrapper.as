package com.doitflash.starling
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextField;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	
	/**
	 * ...
	 * 
	 * @author Hadi Tavakoli - 9/22/2012 4:44 PM
	 */
	public class TextAreaWrapper extends MyStarlingSprite 
	{
		private var _inputWidth:Number = 0;
		private var _inputHeight:Number = 0;
		
		private var _inputFormat:TextFormat;
		private var _inputBg:MyStarlingSprite;
		private var _inputBgSetting:Array = [1, 0xFFFFFF, 1, 0xFF9900, 1];
		private var _inputTxt:TextArea;
		private var _value:String;
		private var _defValue:String;
		
		private var _nativeInputDialog:NativeTextInputDialog;
		
		public function TextAreaWrapper():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_height = 40;
		}
		
		private function stageRemoved(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.removeEventListener(TouchEvent.TOUCH, onInputFieldTouched);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
		}
		
		private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			initBg();
			initInput();
			
			this.addEventListener(TouchEvent.TOUCH, onInputFieldTouched);
		}
		
		private function initBg():void
		{
			if(!_inputBg) _inputBg = new MyStarlingSprite();
			_inputBg.width = _inputWidth;
			_inputBg.height = _height;
			_inputBg.drawBg(_inputBgSetting[0], _inputBgSetting[1], _inputBgSetting[2], _inputBgSetting[3], _inputBgSetting[4]);
			this.addChild(_inputBg);
			
			_width = _inputBg.width;
		}
		
		private function initInput():void
		{
			if(!_inputTxt) _inputTxt = new TextArea();
			_inputTxt.txt.autoSize = TextFieldAutoSize.LEFT;
			_inputTxt.txt.antiAliasType = AntiAliasType.ADVANCED;
			_inputTxt.txt.mouseEnabled = false;
			_inputTxt.txt.embedFonts = true;
			//_inputTxt.txt.border = true;
			_inputTxt.txt.defaultTextFormat = _inputFormat;
			_inputTxt.txt.text = _value;
			_inputTxt.txt.scaleX = _inputTxt.txt.scaleY = _base.deviceInfo.dpiScaleMultiplier;
			
			var h:Number = _inputTxt.txt.height;
			_inputTxt.txt.autoSize = TextFieldAutoSize.NONE;
			_inputTxt.txt.width = (_inputWidth - 10) * (1 / _base.deviceInfo.dpiScaleMultiplier);
			_inputTxt.txt.height = h;
			
			_inputTxt.refresh(_base.deviceInfo.dpiScaleMultiplier);
			this.addChild(_inputTxt);
			
			_inputTxt.y = _inputBg.height - _inputTxt.txt.height >> 1;
			_inputTxt.x = 5;
			
			/*if (!_inputTxt) _inputTxt = new TextArea();
			_inputTxt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_inputTxt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_inputTxt.antiAliasType = AntiAliasType.ADVANCED;
			_inputTxt.embedFonts = true;
			_inputTxt.displayAsPassword = _displayAsPassword;
			
			if (_inputHeight > 0) 
			{
				//_inputTxt.autoSize = TextFieldAutoSize.LEFT;
				_inputTxt.multiline = true;
				_inputTxt.wordWrap = true;
				//_inputTxt.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			}
			
			_inputTxt.type = TextFieldType.INPUT;
			_inputTxt.defaultTextFormat = _inputFormat;
			_inputTxt.text = _value;
			_body.addChild(_inputTxt);*/
		}
		
		private function onInputFieldTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			
			if (touch.phase == TouchPhase.BEGAN)
			{
				return;
			}
			else if (touch.phase == TouchPhase.MOVED)
			{
				return;
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				if (!_nativeInputDialog) _nativeInputDialog = new NativeTextInputDialog();
				_nativeInputDialog.theme = NativeAlert.ANDROID_HOLO_LIGHT_THEME;
				_nativeInputDialog.addEventListener(NativeDialogEvent.CLOSED, dialogHandler, false, 0, true);
				
				var v:Vector.<NativeTextField> = new Vector.<NativeTextField>();
				
				var ti:* = new NativeTextField("field");
				ti.prompText = _defValue;
				(_value == "" || _value == _defValue)? ti.text = "" : ti.text = _value;
				v.push(ti);
				
				var b:Vector.<String> = new Vector.<String>();
				b.push("cancel", "ok");
				
				_nativeInputDialog.show(v, b);
			}
			
		}
		
		private function dialogHandler(e:*):void
		{
			_nativeInputDialog.removeEventListener(e.type, dialogHandler);
			
			var str:String = e.target.textInputs[0].text;
			if (e.index > 1)
			{
				if (str.length < 1) _value = _defValue;
				else _value = str;
				
				_inputTxt.txt.text = _value;
				_inputTxt.refresh(_base.deviceInfo.dpiScaleMultiplier);
			}
		}
		
//----------------------------------------------------------------------------------------------------- Methods

		

//----------------------------------------------------------------------------------------------------- Getter - Setter
		
		public function get inputWidth():Number
		{
			return _inputWidth;
		}
		
		public function set inputWidth(a:Number):void
		{
			_inputWidth = a;
		}
		
		public function get inputHeight():Number
		{
			return _inputHeight;
		}
		
		public function set inputHeight(a:Number):void
		{
			_inputHeight = a;
		}
		
		public function get value():String
		{
			_value = _inputTxt.txt.text;
			return _value;
		}
		
		public function set value(a:String):void
		{
			_value = a;
			if (_inputTxt) 
			{
				_inputTxt.txt.text = _value;
				_inputTxt.refresh(_base.deviceInfo.dpiScaleMultiplier);
			}
		}
		
		public function get defValue():String
		{
			return _defValue;
		}
		
		public function set defValue(a:String):void
		{
			_defValue = a;
		}
		
		public function set inputFormat(a:TextFormat):void
		{
			_inputFormat = a;
		}
		
		public function set inputBgSetting(a:Array):void
		{
			_inputBgSetting = a;
		}
	}
	
}