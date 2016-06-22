package com.myflashlab.template.mobile.starling 
{
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.starling.MyStarlingSprite;
	import com.xtdstudios.DMT.DMTBasic;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	import flash.events.SoftKeyboardEvent;
	import flash.events.KeyboardEvent;
	import flash.text.AutoCapitalize;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.utils.setTimeout;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import feathers.controls.text.StageTextTextEditor;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.TextFormatAlign;
	import flash.text.ReturnKeyLabel;
	
	/**
	 * 
	 * 		Examples of restrict property settings:
	 *
	 *		The following example allows a user to enter only the dash (-) and caret (^) characters:
	 *		
	 *				 my_txt.restrict = "\\-\\^";
	 *				 
	 *		The following example allows a user to enter only uppercase characters, spaces, and numbers:
	 *					
	 *				 my_txt.restrict = "A-Z 0-9";
	 *				 
	 *		The following example excludes only lowercase letters:
	 *			
	 *				 my_txt.restrict = "^a-z";
	 *				 
	 *		The following example allows a user to enter only uppercase letters, but excludes the uppercase letter Q:
	 *			
	 *				 my_txt.restrict = "A-Z^Q";
	 *				 
	 *		The following example allows a user to enter only the characters from ASCII 32 (space) to ASCII 126 (tilde).
	 *			
	 *				 my_txt.restrict = "\u0020-\u007E";
	 * 
	 * 
	 * @author majid
	 */
	public class InputTextField extends MyStarlingSprite
	{
		public static const SOFT_KEYBOARD_ACTIVATING:String = "softKeyboardActivating";
		public static const SOFT_KEYBOARD_ACTIVATE:String = "softKeyboardActivate";
		public static const SOFT_KEYBOARD_DEACTIVATE:String = "softKeyboardDeactivate";
		public static const FOCUS_IN:String = "FOCUS_IN";
		public static const FOCUS_OUT:String = "FOCUS_OUT";
		public static const KEYBOARD_ENTER:String = "KEYBOARD_ENTER";
		
		private var _texture:Texture;
		
		private var _nativeStageText:StageText;
		private var _textInput:ExposedTextInput;
		private var _multiline:Boolean = false;
		
		private var _defaultMsg:String = "";
		
		private var _fontSize:int = 20;
		
		private var _textColor:uint = 0xfefefe;
		
		private var _bgOver:Image;
		private var _bgOut:Image;
		
		private var _bgColorOut:uint = 0x00A29B;
		private var _bgColorOver:uint = 0x007987;
		
		private var _paddingTop:Number = 0;
		private var _paddingBottom:Number = 0;
		private var _paddingLeft:Number = 0;
		private var _paddingRight:Number = 0;
		
		private var _softKeyboardType:String = SoftKeyboardType.DEFAULT;
		private var _returnKeyLabel:String = ReturnKeyLabel.DEFAULT;
		
		private var _borderThickness:int = 2;
		
		//private var _dmtBasic:DMTBasic;
		
		private var aa:StageTextTextEditor;
		
		public function InputTextField():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			
			_textInput = new ExposedTextInput();
		}
		
		private function onAddedStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			//_dmtBasic = _base.data.dmtBasic;
			
			initBg();
			initTextInput();
			
			setTimeout(addStageTextListeners, 200);
			function addStageTextListeners():void
			{
				_nativeStageText = _textInput.nativeStageText as StageText;
				_nativeStageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, 	onSoftKeyboardActivating);
				_nativeStageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, 	onSoftKeyboardActivate);
				_nativeStageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, 	onSoftKeyboardDeactivate);
				
				//trace(_nativeStageText.viewPort);
			}
		}
		
		private function onRemoveStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
			if (_nativeStageText)
			{
				_nativeStageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, 	onSoftKeyboardActivating);
				_nativeStageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, 		onSoftKeyboardActivate);
				_nativeStageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, 	onSoftKeyboardDeactivate);
			}
			
			if (_textInput) 
			{
				_textInput.removeEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
				_textInput.removeEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);
				_textInput.removeEventListener(FeathersEventType.ENTER, onEnter);
				_textInput.removeFromParent(true);
				_textInput.dispose();
				_textInput = null;
			}
			
			if (_bgOver)
			{
				_bgOver.removeFromParent(true);
				_bgOver.dispose();
				_bgOver = null;
			}
			
			if (_bgOut)
			{
				_bgOut.removeFromParent(true);
				_bgOut.dispose();
				_bgOut = null;
			}
		}
		
		private function initTextInput():void
		{
			if (_multiline)
			{
				_textInput.textEditorFactory = function():ITextEditor
				{
					var stageTextEditor:ExposedStageTextTextEditor = new ExposedStageTextTextEditor();
					stageTextEditor.multiline = true;
					return stageTextEditor;
				}
			}
			
			_textInput.textEditorProperties.autoCapitalize = AutoCapitalize.NONE;
			_textInput.textEditorProperties.autoCorrect = false;
			_textInput.textEditorProperties.fontSize = _fontSize;
			_textInput.textEditorProperties.color = _textColor;
			_textInput.textEditorProperties.softKeyboardType = _softKeyboardType;
			_textInput.textEditorProperties.returnKeyLabel = _returnKeyLabel;
			_textInput.textEditorProperties.isEditable = true;
			//_textInput.textEditorProperties.fontFamily = "Roboto";
			_textInput.textEditorProperties.fontPosture = FontPosture.NORMAL;
			_textInput.textEditorProperties.fontWeight = FontWeight.NORMAL;
			_textInput.textEditorProperties.textAlign = TextFormatAlign.START;
			_textInput.width = _width;
			if (_multiline) _textInput.height = _height * 0.9;
			else _textInput.height = _height * 0.8;
			_textInput.text = _defaultMsg;
			
			_textInput.selectRange( 0, _textInput.text.length );
			_textInput.paddingRight = _paddingRight;
			_textInput.paddingLeft = _paddingLeft;
			_textInput.paddingTop = _paddingTop;
			_textInput.paddingBottom = _paddingBottom;
			_textInput.x = _width - _textInput.width >> 1;
			_textInput.y = _height - _textInput.height >> 1;
			this.addChild(_textInput);
			
			_textInput.addEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
			_textInput.addEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);
			_textInput.addEventListener(FeathersEventType.ENTER, onEnter);
			
			//trace("_textInput.height = " + _textInput.height) 
			//trace("_textInput.bounds = " + _textInput.bounds)
			//trace("_height = " + _height)
			
			
		}
		
		private function initBg():void
		{
			_bgOver = new Image(_texture);
			_bgOver.width = _width;
			_bgOver.height = _height;
			_bgOver.color = _bgColorOver;
			_bgOver.visible = false;
			this.addChild(_bgOver);
			
			_bgOut = new Image(_texture);
			_bgOut.width = _width - 2 * _borderThickness;
			_bgOut.height = _height - 2 * _borderThickness;
			_bgOut.color = _bgColorOut;
			_bgOut.x = _borderThickness;
			_bgOut.y = _borderThickness;
			this.addChild(_bgOut);
		}
		
		private function onFocusIn(e:Event):void
		{
			if (_textInput.text == _defaultMsg) _textInput.text = "";
			_bgOver.visible = true;
			
			dispatchEventWith(InputTextField.FOCUS_IN);
		}
		
		private function onFocusOut(e:Event):void
		{
			if (_textInput.text == "") 
			{
				_textInput.text = _defaultMsg;
			}
			
			_bgOver.visible = false;
			
			dispatchEventWith(InputTextField.FOCUS_OUT);
		}
		
		private function onEnter(e:Event):void
		{
			trace("keyboard enter key is hit!")
			dispatchEventWith(InputTextField.KEYBOARD_ENTER);
		}
		
		private function onSoftKeyboardActivating(e:SoftKeyboardEvent):void
		{
			dispatchEventWith(InputTextField.SOFT_KEYBOARD_ACTIVATING);
		}
		
		private function onSoftKeyboardActivate(e:SoftKeyboardEvent):void
		{
			dispatchEventWith(InputTextField.SOFT_KEYBOARD_ACTIVATE);
		}
		
		private function onSoftKeyboardDeactivate(e:SoftKeyboardEvent):void
		{
			dispatchEventWith(InputTextField.SOFT_KEYBOARD_DEACTIVATE);
		}
		
		
//------------------------------------------properties
		
		public function get textInput():ExposedTextInput
		{
			return _textInput;
		}
		
		public function get text():String
		{
			return _textInput.text;
		}
		public function set text(a:String):void
		{
			if (_textInput) _textInput.text = a;
		}
		
		public function get defaultMsg():String
		{
			return _defaultMsg;
		}
		public function set defaultMsg(a:String):void
		{
			_defaultMsg = a;
			if (_textInput) _textInput.text = _defaultMsg;
		}
		
		public function get fontSize():int
		{
			return _fontSize;
		}
		public function set fontSize(a:int):void
		{
			_fontSize = a;
		}
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		public function set paddingBottom(a:Number):void
		{
			_paddingBottom = a;
		}
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		public function set paddingLeft(a:Number):void
		{
			_paddingLeft = a;
		}
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		public function set paddingRight(a:Number):void
		{
			_paddingRight = a;
		}
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		public function set paddingTop(a:Number):void
		{
			_paddingTop = a;
		}
		
		public function get textColor():uint
		{
			return _textColor;
		}
		public function set textColor(a:uint):void
		{
			_textColor = a;
		}
		
		public function get bgColorOut():uint
		{
			return _bgColorOut;
		}
		public function set bgColorOut(a:uint):void
		{
			_bgColorOut = a;
		}
		
		public function get bgColorOver():uint
		{
			return _bgColorOver;
		}
		public function set bgColorOver(a:uint):void
		{
			_bgColorOver = a;
		}
		
		public function get softKeyboardType():String
		{
			return _softKeyboardType;
		}
		public function set softKeyboardType(a:String):void
		{
			_softKeyboardType = a;
		}
		
		public function get multiline():Boolean
		{
			return _multiline;
		}
		
		public function set multiline(a:Boolean):void
		{
			_multiline = a;
		}
		
		public function set texture($texture:Texture):void
		{
			_texture = $texture;
		}
		
		public function set returnKeyLabel(a:String):void
		{
			_returnKeyLabel = a;
		}
		
		public function set borderThickness(a:int):void
		{
			_borderThickness = a;
		}
		
		public function get borderThickness():int
		{
			return _borderThickness;
		}
		
	}

}