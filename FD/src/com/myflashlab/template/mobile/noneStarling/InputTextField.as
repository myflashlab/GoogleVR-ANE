package com.myflashlab.template.mobile.noneStarling 
{
	import com.doitflash.text.modules.MySprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	// http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html
	import flash.text.StageText;
	import flash.text.ReturnKeyLabel;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent; 
	import flash.ui.Keyboard;
	import flash.text.TextFormatAlign;
	import flash.events.FocusEvent;
	import flash.text.engine.FontWeight;
	import flash.text.engine.FontPosture;
	import flash.text.AutoCapitalize;
	import flash.text.SoftKeyboardType;
	import flash.text.StageTextInitOptions;
	
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	
	/**
	 * 		
	 *		
	 * @author Majid Hejazi - 11/25/2014 11:49 AM
	 */
	public class InputTextField extends MySprite
	{
		private var _bgColorFocusOut:uint = 0xffffff;
		private var _bgColorFocusIn:uint = 0xffffff;
		private var _bgAlphaFocusOut:Number = 1;
		private var _bgAlphaFocusIn:Number = 1;
		
		private var _bgStrokeColorFocusOut:uint = 0xffffff;
		private var _bgStrokeColorFocusIn:uint = 0xffffff;
		private var _bgStrokeAlphaFocusOut:Number = 0;
		private var _bgStrokeAlphaFocusIn:Number = 0;
		private var _bgStrokeThicknessFocusOut:int = 0;
		private var _bgStrokeThicknessFocusIn:int = 0;
		private var _bgRadius:int = 0;
		
		private var _inputStageText:StageText;
		
		private var _textColorFocusOut:uint = 0xbb9999;
		private var _textColorFocusIn:uint = 0x555555;
		private var _fontSize:int = 25;
		private var _maxChars:int = -1;
		private var _defaultLabel:String = "";
		private var _fontFamily:String = "";
		private var _returnKeyLabel:String = ReturnKeyLabel.DEFAULT;
		private var _fontPosture:String = FontPosture.NORMAL;
		private var _fontWeight:String = FontWeight.NORMAL;
		private var _softKeyboardType:String = SoftKeyboardType.DEFAULT;
		private var _textAlign:String = TextFormatAlign.LEFT;
		private var _autoCapitalize:String = AutoCapitalize.NONE;
		private var _restrict:String = "";
		private var _locale:String = "en-US";
		private var _editable:Boolean = true;
		private var _displayAsPassword:Boolean = false;
		private var _stage:Stage;
		private var _dpiScaleMultiplier:Number;
		private var _multiline:Boolean = false;
		
		private var _parentPageName:String = "";
		
		private var _isDefault:Boolean = true;
		
		public function InputTextField($satge:Stage, $dpiScaleMultiplier:Number = 1, $multiline:Boolean = false):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			
			_margin = 5;
			_stage = $satge;
			_dpiScaleMultiplier = $dpiScaleMultiplier;
			_multiline = $multiline;
		}
		
		private function onAddedStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			initBg();
			initStageText();
		}
		
		private function onRemoveStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			_inputStageText.removeEventListener(FocusEvent.FOCUS_IN, onInFocus);
			_inputStageText.removeEventListener(FocusEvent.FOCUS_OUT, onOutFocus);
			_inputStageText.removeEventListener(Event.CHANGE, onChangeText);
			_inputStageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onKeyboardActive);
			_inputStageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onKeyboarDeactive);
			
			dispose();
			
			_inputStageText = null;
		}
		
		private function initBg():void
		{
			_bgAlpha = _bgAlphaFocusOut;
			_bgColor = _bgColorFocusOut;
			_bgBottomLeftRadius = _bgRadius;
			_bgBottomRightRadius = _bgRadius;
			_bgTopLeftRadius = _bgRadius;
			_bgTopRightRadius = _bgRadius;
			_bgStrokeAlpha = _bgStrokeAlphaFocusOut;
			_bgStrokeColor = _bgStrokeColorFocusOut;
			_bgStrokeThickness = _bgStrokeThicknessFocusOut;
			drawBg();
		}
		
		private function initStageText():void
		{
			if (_multiline) _inputStageText = new StageText(new StageTextInitOptions(true));
			else _inputStageText = new StageText();
			_inputStageText.returnKeyLabel = _returnKeyLabel;
			_inputStageText.text = _defaultLabel;
			_inputStageText.editable = _editable;
			_inputStageText.fontFamily = _fontFamily;
			_inputStageText.fontPosture = _fontPosture;
			_inputStageText.fontWeight = _fontWeight;
			_inputStageText.fontSize = _fontSize;
			_inputStageText.color =  _textColorFocusOut;
			_inputStageText.displayAsPassword =  false;
			if (_maxChars > 0) _inputStageText.maxChars =  _maxChars;
			if (_restrict.length > 0) _inputStageText.restrict = _restrict;
			_inputStageText.softKeyboardType = _softKeyboardType;
			_inputStageText.textAlign = _textAlign;
			_inputStageText.stage = _stage;
			var globalPoint:Point = this.localToGlobal(new Point(0, 0));
			_inputStageText.viewPort = new Rectangle((globalPoint.x + _marginX),  (globalPoint.y + _marginY), (_width - 2 * _marginX) * _dpiScaleMultiplier, (_height - 2 * _marginY) * _dpiScaleMultiplier);
			_inputStageText.locale = _locale;	// all English; "ja" is Japanese
			_inputStageText.autoCapitalize = _autoCapitalize;
			_inputStageText.addEventListener(FocusEvent.FOCUS_IN, onInFocus);
			_inputStageText.addEventListener(FocusEvent.FOCUS_OUT, onOutFocus);
			_inputStageText.addEventListener(Event.CHANGE, onChangeText);
			_inputStageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onKeyboardActive);
			_inputStageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onKeyboarDeactive);
		}
		
//----------------------------touch control
		
		private function onInFocus(event:FocusEvent):void
		{
			_bgAlpha = _bgAlphaFocusIn;
			_bgColor = _bgColorFocusIn;
			_bgBottomLeftRadius = _bgRadius;
			_bgBottomRightRadius = _bgRadius;
			_bgTopLeftRadius = _bgRadius;
			_bgTopRightRadius = _bgRadius;
			_bgStrokeAlpha = _bgStrokeAlphaFocusIn;
			_bgStrokeColor = _bgStrokeColorFocusIn;
			_bgStrokeThickness = _bgStrokeThicknessFocusIn;
			drawBg();
			
			if (_inputStageText.text == _defaultLabel) _inputStageText.text = "";
			_inputStageText.color = _textColorFocusIn;
			_inputStageText.displayAsPassword =  _displayAsPassword;
		}
		
		private function onOutFocus(event:FocusEvent = null):void
		{
			_bgAlpha = _bgAlphaFocusOut;
			_bgColor = _bgColorFocusOut;
			_bgBottomLeftRadius = _bgRadius;
			_bgBottomRightRadius = _bgRadius;
			_bgTopLeftRadius = _bgRadius;
			_bgTopRightRadius = _bgRadius;
			_bgStrokeAlpha = _bgStrokeAlphaFocusOut;
			_bgStrokeColor = _bgStrokeColorFocusOut;
			_bgStrokeThickness = _bgStrokeThicknessFocusOut;
			drawBg();
			
			if (_inputStageText.text == "") 
			{
				_inputStageText.text = _defaultLabel;
				_inputStageText.displayAsPassword =  false;
			}
			_inputStageText.color = _textColorFocusOut;
		}
		
		private function onChangeText(e:Event = null):void
		{
			if (_isDefault && _inputStageText.text.length > 0 && _inputStageText.text != _defaultLabel) 
			{
				_isDefault = false;
				dispatchEvent(new InputTextFieldEvent(InputTextFieldEvent.CHANGE_TEXT_OF_DEFAULT));
			}
			else if (!_isDefault && (_inputStageText.text == _defaultLabel || _inputStageText.text == ""))
			{
				_isDefault = true;
				dispatchEvent(new InputTextFieldEvent(InputTextFieldEvent.CHANGE_TEXT_TO_DEFAULT));
			}
		}
		
		private function onKeyboardActive(e:SoftKeyboardEvent):void
		{
			var rect:Rectangle = _stage.softKeyboardRect;
			onChangeText();
			dispatchEvent(new InputTextFieldEvent(InputTextFieldEvent.SOFT_KEYBOARD_ACTIVED, rect.height));
		}
		
		private function onKeyboarDeactive(e:SoftKeyboardEvent):void
		{
			onOutFocus();
			onChangeText();
			dispatchEvent(new InputTextFieldEvent(InputTextFieldEvent.SOFT_KEYBOARD_DEACTIVED));
		}
		
//----------------------------------------------------------------------- methods

		
		public function dispose():void
		{
			if (_inputStageText)
			{
				if (_inputStageText.hasEventListener(FocusEvent.FOCUS_IN)) _inputStageText.removeEventListener(FocusEvent.FOCUS_IN, onInFocus);
				if (_inputStageText.hasEventListener(FocusEvent.FOCUS_OUT)) _inputStageText.removeEventListener(FocusEvent.FOCUS_OUT, onOutFocus);
				if (_inputStageText.hasEventListener(Event.CHANGE)) _inputStageText.removeEventListener(Event.CHANGE, onChangeText);
				if (_inputStageText.hasEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE)) _inputStageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onKeyboardActive);
				if (_inputStageText.hasEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE)) _inputStageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onKeyboarDeactive);
				_inputStageText.dispose();
			}
			
		}
		
		public function setupBgInfo(	$bgColorFocusOut:uint = 0xffffff, 
										$bgColorFocusIn:uint = 0xffffff, 
										$bgStrokeColorFocusOut:uint = 0xcccccc, 
										$bgStrokeColorFocusIn:uint = 0x66afe9, 
										$bgRadius:int = 0, 
										$bgStrokeThicknessFocusOut:int = 0, 
										$bgStrokeThicknessFocusIn:int = 0, 
										$bgAlphaFocusOut:Number = 1,
										$bgAlphaFocusIn:Number = 1, 
										$bgStrokeAlphaFocusOut:Number = 0, 
										$bgStrokeAlphaFocusIn:Number = 0):void
		{
			_bgColorFocusOut = $bgColorFocusOut;
			_bgColorFocusIn = $bgColorFocusIn;
			_bgAlphaFocusOut = $bgAlphaFocusOut;
			_bgAlphaFocusIn = $bgAlphaFocusIn;
			
			_bgStrokeColorFocusOut = $bgStrokeColorFocusOut;
			_bgStrokeColorFocusIn = $bgStrokeColorFocusIn;
			_bgStrokeAlphaFocusOut = $bgStrokeAlphaFocusOut;
			_bgStrokeAlphaFocusIn = $bgStrokeAlphaFocusIn;
			_bgStrokeThicknessFocusOut = $bgStrokeThicknessFocusOut;
			_bgStrokeThicknessFocusIn = $bgStrokeThicknessFocusIn;
			_bgRadius = $bgRadius;
		}
		
		public function setupFont(	$textColorFocusOut:uint = 0x333333,
									$textColorFocusIn:uint = 0xAAAAAA,
									$fontSize:int = 25,
									$maxChars:int = -1,
									$defaultLabel:String = "",
									$fontFamily:String = "",
									$returnKeyLabel:String = ReturnKeyLabel.DEFAULT,
									$fontPosture:String = FontPosture.NORMAL,
									$fontWeight:String = FontWeight.NORMAL,
									$softKeyboardType:String = SoftKeyboardType.DEFAULT,
									$textAlign:String = TextFormatAlign.LEFT,
									$autoCapitalize:String = AutoCapitalize.NONE,
									$restrict:String = "",
									$locale:String = "en-US",
									$editable:Boolean = true,
									$displayAsPassword:Boolean = false):void
		{
			_textColorFocusOut = $textColorFocusOut;
			_textColorFocusIn = $textColorFocusIn;
			_fontSize = $fontSize;
			_maxChars = $maxChars;
			_defaultLabel = $defaultLabel;
			_fontFamily = $fontFamily;
			_returnKeyLabel = $returnKeyLabel;
			_fontPosture = $fontPosture;
			_fontWeight = $fontWeight;
			_softKeyboardType = $softKeyboardType;
			_textAlign = $textAlign;
			_autoCapitalize = $autoCapitalize;
			_restrict = $restrict;
			_locale = $locale;
			_editable = $editable;
			_displayAsPassword = $displayAsPassword;
		}
		
		public function manageVisibility($show:Boolean):void
		{
			if ($show) _inputStageText.visible = false;
			else 
			{
				_inputStageText.visible = true;
				
				var globalPoint:Point = this.localToGlobal(new Point(0, 0));
				_inputStageText.viewPort = new Rectangle((globalPoint.x + _marginX),  (globalPoint.y + _marginY), 10, 10);
				_inputStageText.viewPort = new Rectangle((globalPoint.x + _marginX),  (globalPoint.y + _marginY), (_width - 2 * _marginX) * _dpiScaleMultiplier, (_height - 2 * _marginY) * _dpiScaleMultiplier);
			}
		}
		
		public function assignFocus():void
		{
			_inputStageText.assignFocus();
		}
		
		public function updateSize():void
		{
			var globalPoint:Point = this.localToGlobal(new Point(0, 0));
			_inputStageText.viewPort = new Rectangle((globalPoint.x + _marginX),  (globalPoint.y + _marginY), (_width - 2 * _marginX) * _dpiScaleMultiplier, (_height - 2 * _marginY) * _dpiScaleMultiplier);
		}

//----------------------------------------------------------------------- properties
		
		public function get text():String
		{
			return _inputStageText.text;
		}
		
		public function set text(a:String):void
		{
			_inputStageText.text = a;
		}
		
		public function get parentPageName():String
		{
			return _parentPageName;
		}
		public function set parentPageName(a:String):void
		{
			_parentPageName = a;
		}
		
		public function get defaultLabel():String
		{
			return _defaultLabel;
		}
		
	}

}