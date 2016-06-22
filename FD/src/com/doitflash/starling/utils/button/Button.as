package  com.doitflash.starling.utils.button
{
	import com.doitflash.starling.MyStarlingSprite;
	import com.doitflash.starling.TextArea;
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	
	import starling.events.Event;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	import com.doitflash.tools.sizeControl.CalculateFontSize;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	
	/**
	 * ...
	 * @author Majid Hejazi 9/26/2013 9:03 AM
	 */
	public class Button extends MyStarlingSprite
	{
		// input var
		private var _textureBG:Texture; // texture background
		private var _iconTexture:Texture; // texture icon
		
		private var _colorBgOut:uint;
		private var _colorBgOver:uint;
		private var _colorIconOut:uint;
		private var _colorIconOver:uint;
		private var _colorTextOut:String = "#000000";
		private var _colorTextOver:String = "#ffffff";
		
		private var _alphaBgOut:Number = 0.7;
		private var _alphaBgOver:Number = 1;
		private var _alphaIconOut:Number = 0.7;
		private var _alphaIconOver:Number = 1;
		private var _alphaTextOut:Number = 0.7;
		private var _alphaTextOver:Number = 1;
		
		private var _ratioTextW:Number;
		private var _ratioTextH:Number;
		private var _ratioIconW:Number;
		private var _ratioIconH:Number;
		private var _ratioSpaceLeft:Number = 0;
		private var _ratioSpaceRight:Number = 0;
		private var _ratioSpaceUp:Number = 0;
		private var _ratioSpaceDown:Number = 0;
		private var _ratioSpaceBetween:Number = 0;
		
		private var _timeForAnimation:Number = 1;
		
		private var _changeTypeBg:String = ButtonConst.CHANGE_ALPHA;
		private var _changeTypeIcon:String = ButtonConst.CHANGE_ALPHA;
		private var _changeTypeText:String = ButtonConst.CHANGE_ALPHA;
		
		private var _model:String = ButtonConst.ICON_AND_TEXT;
		private var _iconLocation:String = ButtonConst.ICON_LEFT;
		
		private var _bgDimention:String = ButtonConst.BG_SCALE;
		
		private var _fontSize:int = 0;
		private var _fontType:String;
		private var _text:String;
		
		private var _ease:Function = Elastic.easeOut;
		
		private var _activeBgRoll:Boolean = false;
		private var _activeIconRoll:Boolean = false;
		private var _activeTextRoll:Boolean = false;
		
		private var _embedFont:Boolean = true; // dar in version bayad hatman font embed shode bashad
		
		private var _touchableBg:Boolean = false;
		
		private var _iconMiddle:Boolean = true;
		private var _textMiddle:Boolean = true;
		
		// need var
		private var _imageBGOut:Image;
		private var _imageBGOver:Image;
		private var _iconImageOut:Image;
		private var _iconImageOver:Image;
		
		private var _txtOut:TextArea;
		private var _txtOver:TextArea;
		
		public function Button():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
		}
		
		private function stageRemoved(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			var i:int;
			var lng:int = this.numChildren;
			var item:*;
			
			for (i = lng-1; i >= 0; i--) 
			{
				item = this.getChildAt(i);
				if (item is TextArea)
				{
					item.img.texture.dispose();
					item.img.dispose();
					item.removeFromParent(true);
					item = null;
				}
				else if (item is Image)
				{
					item.texture.dispose();
					item.removeFromParent(true);
					item.dispose();
					item = null;
				}
			}
			
			if (_textureBG) 
			{
				_textureBG.dispose();
				_textureBG = null;
			}
			
			if (_iconTexture) 
			{
				_iconTexture.dispose();
				_iconTexture = null;
			}
			
			trace("--Button--this: ", this.numChildren)
		}
		
		private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			if (_textureBG) initBg();
			
			if (_model == ButtonConst.ONLY_ICON)
			{
				initIcon();
			}
			else if (_model == ButtonConst.ONLY_TEXT)
			{
				initTextField();
			}
			else if (_model == ButtonConst.ICON_AND_TEXT)
			{
				initIcon();
				initTextField();
			}
		}
		
		private function initBg():void
		{
			_imageBGOut = new Image(_textureBG);
			
			var wi:int = _imageBGOut.width;
			var he:int = _imageBGOut.height;
			
			if (_width != 0 && _height == 0)
			{
				_imageBGOut.width = _width;
				_imageBGOut.height = _imageBGOut.width / wi * _imageBGOut.height;
			}
			else if (_width == 0 && _height != 0)
			{
				_imageBGOut.height = _height;
				_imageBGOut.width = _imageBGOut.height / he * _imageBGOut.width;
			}
			else if (_width != 0 && _height != 0)
			{
				if (_bgDimention == ButtonConst.BG_FIT)
				{
					_imageBGOut.width = _width;
					_imageBGOut.height = _height;
				}
				else if (_bgDimention == ButtonConst.BG_SCALE)
				{
					if ((wi / _width) >= (he / _height))
					{
						_imageBGOut.width = _width;
						_imageBGOut.height = _width / wi * he;
					}
					else
					{
						_imageBGOut.height = _height;
						_imageBGOut.width = _height / he * wi;
					}
					
					_imageBGOut.x = (_width - _imageBGOut.width) * 0.5;
					_imageBGOut.y = (_height - _imageBGOut.height) * 0.5;
				}
			}
			
			_imageBGOut.color = _colorBgOut;
			_imageBGOut.alpha = _alphaBgOut;
			_imageBGOut.touchable = _touchableBg;
			this.addChild(_imageBGOut);
			
			if (_changeTypeBg == ButtonConst.CHANGE_COLOR)
			{
				_imageBGOver = new Image(_textureBG);
				_imageBGOver.width = _imageBGOut.width;
				_imageBGOver.height = _imageBGOut.height;
				_imageBGOver.x = _imageBGOut.x;
				_imageBGOver.y = _imageBGOut.y;
				_imageBGOver.color = _colorBgOver;
				_imageBGOver.alpha = 0;
				_imageBGOver.touchable = false;
				this.addChild(_imageBGOver);
			}
			
			//trace("_imageBGOut", _imageBGOut.width, _imageBGOut.height, _imageBGOut.x, _imageBGOut.y, _imageBGOut.alpha, _imageBGOut.color)
		}
		
		private function initIcon():void
		{
			var bgW:int;
			var bgH:int;
			var globalX:int;
			var globalY:int;
			
			if (_imageBGOut)
			{
				bgW = _imageBGOut.width;
				bgH = _imageBGOut.height;
				globalX = _imageBGOut.x;
				globalY = _imageBGOut.y;
			}
			else
			{
				bgW = _width;
				bgH = _height;
				globalX = 0;
				globalY = 0;
			}
			
			var frameW:int = bgW * _ratioIconW;
			var frameH:int = bgH * _ratioIconH;
			
			_iconImageOut = new Image(_iconTexture);
			
			var wi:int = _iconImageOut.width;
			var he:int = _iconImageOut.height;
			if ((wi / frameW) >= (he / frameH))
			{
				_iconImageOut.width = frameW;
				_iconImageOut.height = frameW / wi * he;
			}
			else
			{
				_iconImageOut.height = frameH;
				_iconImageOut.width = frameH / he * wi;
			}
			wi = _iconImageOut.width;
			he = _iconImageOut.height;
			
			if (_model == ButtonConst.ONLY_ICON)
			{
				if (_iconMiddle)
				{
					_iconImageOut.x = globalX + (bgW - wi) * 0.5;
					_iconImageOut.y = globalY + (bgH - he) * 0.5;
				}
				else
				{
					_iconImageOut.x = globalX + bgW * _ratioSpaceLeft + (frameW - wi) * 0.5;
					_iconImageOut.y = globalY + bgH * _ratioSpaceUp + (frameH - he) * 0.5;
				}
			}
			else if (_model == ButtonConst.ICON_AND_TEXT)
			{
				switch (_iconLocation) 
				{
					case ButtonConst.ICON_LEFT:
						
						_iconImageOut.x = globalX + bgW * _ratioSpaceLeft + (frameW - wi) * 0.5;
						if (_iconMiddle) _iconImageOut.y = globalY + (bgH - he) * 0.5;
						else _iconImageOut.y = globalY + bgH * _ratioSpaceUp + (frameH - he) * 0.5;
						
					break;
					case ButtonConst.ICON_RIGHT:
						
						_iconImageOut.x = globalX + bgW - bgW * _ratioSpaceRight - (frameW - wi) * 0.5 - wi;
						if (_iconMiddle) _iconImageOut.y = globalY + (bgH - he) * 0.5;
						else _iconImageOut.y = globalY + bgH * _ratioSpaceUp + (frameH - he) * 0.5;
						
					break;
					case ButtonConst.ICON_UP:
						
						_iconImageOut.y = globalY + bgH * _ratioSpaceUp + (frameH - he) * 0.5;
						if (_iconMiddle) _iconImageOut.x = globalX + (bgW - wi) * 0.5;
						else _iconImageOut.x = globalX + bgW * _ratioSpaceLeft + (frameW - wi) * 0.5;
						
					break;
					case ButtonConst.ICON_DOWN:
						
						_iconImageOut.y = globalY + bgH - bgH * _ratioSpaceDown - (frameH - he) * 0.5 - he;
						if (_iconMiddle) _iconImageOut.x = globalX + (bgW - wi) * 0.5;
						else _iconImageOut.x = globalX + bgW * _ratioSpaceLeft + (frameW - wi) * 0.5;
						
					break;
					default:
				}
			}
			
			_iconImageOut.color = _colorIconOut;
			_iconImageOut.alpha = _alphaIconOut;
			_iconImageOut.touchable = false;
			this.addChild(_iconImageOut);
			
			if (_changeTypeIcon == ButtonConst.CHANGE_COLOR)
			{
				_iconImageOver = new Image(_iconTexture);
				_iconImageOver.width = _iconImageOut.width;
				_iconImageOver.height = _iconImageOut.height;
				_iconImageOver.y = _iconImageOut.y;
				_iconImageOver.x = _iconImageOut.x;
				_iconImageOver.color = _colorIconOver;
				_iconImageOver.alpha = 0;
				_iconImageOver.touchable = false;
				this.addChild(_iconImageOver);
			}
			
			//trace("_iconImageOut", _iconImageOut.width, _iconImageOut.height, _iconImageOut.x, _iconImageOut.y, _iconImageOut.alpha, _iconImageOut.color)
		}
		
		private function initTextField():void
		{
			var bgW:int;
			var bgH:int;
			var globalX:int;
			var globalY:int;
			
			if (_imageBGOut)
			{
				bgW = _imageBGOut.width;
				bgH = _imageBGOut.height;
				globalX = _imageBGOut.x;
				globalY = _imageBGOut.y;
			}
			else
			{
				bgW = _width;
				bgH = _height;
				globalX = 0;
				globalY = 0;
			}
			
			var frameW:int = bgW * _ratioTextW;
			var frameH:int = bgH * _ratioTextH;
			
			var fontSizeOut:int
			if (_fontSize == 0)
			{
				fontSizeOut = CalculateFontSize.fontSizeByWH(_text, _fontType, frameW, frameH);
			}
			else
			{
				fontSizeOut = _fontSize;
			}
			
			
			_txtOut = new TextArea();
			_txtOut.txt.autoSize = TextFieldAutoSize.LEFT;
			_txtOut.txt.antiAliasType = AntiAliasType.ADVANCED;
			_txtOut.txt.embedFonts = true;
			_txtOut.txt.mouseEnabled = false;
			_txtOut.txt.multiline = false;
			_txtOut.txt.htmlText = "<font face='" + _fontType + "' color='" + _colorTextOut + "' size='" + fontSizeOut + "'>" + _text + "</font>";
			_txtOut.refresh();
			
			var wi:int = _txtOut.txt.width;
			var he:int = _txtOut.txt.height;
			
			if (_model == ButtonConst.ONLY_TEXT)
			{
				if (_textMiddle) 
				{
					_txtOut.x = globalX + (bgW - wi) * 0.5;
					_txtOut.y = globalY + (bgH - he) * 0.5;
				}
				else
				{
					_txtOut.x = globalX +  bgW * _ratioSpaceLeft;
					_txtOut.y = globalY + bgH * _ratioSpaceUp;
				}
			}
			else if (_model == ButtonConst.ICON_AND_TEXT)
			{
				switch (_iconLocation) 
				{
					case ButtonConst.ICON_LEFT:
						
						_txtOut.x = globalX +  bgW * (_ratioSpaceLeft + _ratioIconW + _ratioSpaceBetween) + (frameW - wi) * 0.5;
						if (_textMiddle) _txtOut.y = globalY + (bgH - he) * 0.5;
						else _txtOut.y = globalY + bgH * _ratioSpaceUp + (frameH - he) * 0.5;
						
					break;
					case ButtonConst.ICON_RIGHT:
						
						_txtOut.x = globalX + bgW * _ratioSpaceLeft + (frameW - wi) * 0.5;
						if (_textMiddle) _txtOut.y = globalY + (bgH - he) * 0.5;
						else _txtOut.y = globalY + bgH * _ratioSpaceUp + (frameH - he) * 0.5;
						
					break;
					case ButtonConst.ICON_UP:
						
						_txtOut.y = globalY + bgH * (_ratioSpaceUp + _ratioIconH + _ratioSpaceBetween) + (frameH - he) * 0.5;
						if (_textMiddle) _txtOut.x = globalX + (bgW - wi) * 0.5;
						else _txtOut.x = globalX +  bgW * _ratioSpaceLeft + (frameW - wi) * 0.5;
						
					break;
					case ButtonConst.ICON_DOWN:
						
						_txtOut.y = globalY + bgH * _ratioSpaceUp + (frameH - he) * 0.5;
						if (_textMiddle) _txtOut.x = globalX + (bgW - wi) * 0.5;
						else _txtOut.x = globalX +  bgW * _ratioSpaceLeft + (frameW - wi) * 0.5;
						
					break;
					default:
				}
			}
			
			_txtOut.touchable = false;
			_txtOut.alpha = _alphaTextOut;
			this.addChild(_txtOut);
			
			if (_changeTypeText == ButtonConst.CHANGE_COLOR)
			{
				_txtOver = new TextArea();
				_txtOver.txt.autoSize = TextFieldAutoSize.LEFT;
				_txtOver.txt.antiAliasType = AntiAliasType.ADVANCED;
				_txtOver.txt.embedFonts = true;
				_txtOver.txt.mouseEnabled = false;
				_txtOver.txt.multiline = false;
				_txtOver.txt.htmlText = "<font face='" + _fontType + "' color='" + _colorTextOver + "' size='" + fontSizeOut + "'>" + _text + "</font>";
				_txtOver.refresh();
				_txtOver.x = _txtOut.x;
				_txtOver.y = _txtOut.y;
				_txtOver.touchable = false;
				_txtOver.alpha = 0;
				this.addChild(_txtOver);
			}
		}
		
//----------------------method
		
		public function changeText($text:String):void
		{
			if (_txtOut)
			{
				_txtOut.img.texture.dispose();
				_txtOut.img.dispose();
				_txtOut.removeFromParent(true);
			}
			
			if (_txtOut)
			{
				_txtOver.img.texture.dispose();
				_txtOver.img.dispose();
				_txtOver.removeFromParent(true);
			}
			
			_text = $text;
			initTextField();
		}
		
		public function rollOver():void
		{
			if (_imageBGOut && _activeBgRoll)
			{
				if (_changeTypeBg == ButtonConst.CHANGE_COLOR)
				{
					TweenMax.to(_imageBGOut, _timeForAnimation, { alpha:0, ease:_ease } );
					TweenMax.to(_imageBGOver, _timeForAnimation, { alpha:_alphaBgOver, ease:_ease } );
				}
				else
				{
					TweenMax.to(_imageBGOut, _timeForAnimation, { alpha:_alphaBgOver, ease:_ease } );
				}
			}
			
			if (_iconImageOut && _activeIconRoll)
			{
				if (_changeTypeIcon == ButtonConst.CHANGE_COLOR)
				{
					TweenMax.to(_iconImageOut, _timeForAnimation, { alpha:0, ease:_ease } );
					TweenMax.to(_iconImageOver, _timeForAnimation, { alpha:_alphaIconOver, ease:_ease } );
				}
				else
				{
					TweenMax.to(_iconImageOut, _timeForAnimation, { alpha:_alphaIconOver, ease:_ease } );
				}
			}
			
			if (_txtOut && _activeTextRoll)
			{
				if (_changeTypeText == ButtonConst.CHANGE_COLOR)
				{
					TweenMax.to(_txtOut, _timeForAnimation, { alpha:0, ease:_ease } );
					TweenMax.to(_txtOver, _timeForAnimation, { alpha:_alphaTextOver, ease:_ease } );
				}
				else
				{
					TweenMax.to(_txtOut, _timeForAnimation, { alpha:_alphaTextOver, ease:_ease } );
				}
			}
		}
		
		public function rollOut():void
		{
			if (_imageBGOut && _activeBgRoll)
			{
				if (_changeTypeBg == ButtonConst.CHANGE_COLOR)
				{
					TweenMax.to(_imageBGOut, _timeForAnimation, { alpha:_alphaBgOut, ease:_ease } );
					TweenMax.to(_imageBGOver, _timeForAnimation, { alpha:0, ease:_ease } );
				}
				else
				{
					TweenMax.to(_imageBGOut, _timeForAnimation, { alpha:_alphaBgOut, ease:_ease } );
				}
			}
			
			if (_iconImageOut && _activeIconRoll)
			{
				if (_changeTypeIcon == ButtonConst.CHANGE_COLOR)
				{
					TweenMax.to(_iconImageOut, _timeForAnimation, { alpha:_alphaIconOut, ease:_ease } );
					TweenMax.to(_iconImageOver, _timeForAnimation, { alpha:0, ease:_ease } );
				}
				else
				{
					TweenMax.to(_iconImageOut, _timeForAnimation, { alpha:_alphaIconOut, ease:_ease } );
				}
			}
			
			if (_txtOut && _activeTextRoll)
			{
				if (_changeTypeText == ButtonConst.CHANGE_COLOR)
				{
					TweenMax.to(_txtOut, _timeForAnimation, { alpha:_alphaTextOut, ease:_ease } );
					TweenMax.to(_txtOver, _timeForAnimation, { alpha:0, ease:_ease } );
				}
				else
				{
					TweenMax.to(_txtOut, _timeForAnimation, { alpha:_alphaTextOut, ease:_ease } );
				}
			}
		}
		
//----------------------getter & setter
		// set Textures
		
		public function set textureBG(a:Texture):void
		{
			_textureBG = a;
		}
		
		public function set iconTexture(a:Texture):void
		{
			_iconTexture = a;
		}
		
		// set colors
		
		public function set colorBgOut(a:uint):void
		{
			_colorBgOut = a;
		}
		
		public function set colorBgOver(a:uint):void
		{
			_colorBgOver = a;
		}
		
		public function set colorIconOut(a:uint):void
		{
			_colorIconOut = a;
		}
		
		public function set colorIconOver(a:uint):void
		{
			_colorIconOver = a;
		}
		
		public function set colorTextOut(a:String):void
		{
			_colorTextOut = a;
		}
		
		public function set colorTextOver(a:String):void
		{
			_colorTextOver = a;
		}
		
		// set alpha
		
		public function set alphaBgOut(a:Number):void
		{
			if (a < 0) _alphaBgOut = 0;
			else if (a > 1) _alphaBgOut = 1;
			else _alphaBgOut = a;
		}
		
		public function set alphaBgOver(a:Number):void
		{
			if (a < 0) _alphaBgOver = 0;
			else if (a > 1) _alphaBgOver = 1;
			else _alphaBgOver = a;
		}
		
		public function set alphaIconOut(a:Number):void
		{
			if (a < 0) _alphaIconOut = 0;
			else if (a > 1) _alphaIconOut = 1;
			else _alphaIconOut = a;
		}
		
		public function set alphaIconOver(a:Number):void
		{
			if (a < 0) _alphaIconOver = 0;
			else if (a > 1) _alphaIconOver = 1;
			else _alphaIconOver = a;
		}
		
		public function set alphaTextOut(a:Number):void
		{
			if (a < 0) _alphaTextOut = 0;
			else if (a > 1) _alphaTextOut = 1;
			else _alphaTextOut = a;
		}
		
		public function set alphaTextOver(a:Number):void
		{
			if (a < 0) _alphaTextOver = 0;
			else if (a > 1) _alphaTextOver = 1;
			else _alphaTextOver = a;
		}
		
		// set ratio
		
		public function set ratioTextH(a:Number):void
		{
			_ratioTextH = a;
		}
		
		public function set ratioTextW(a:Number):void
		{
			_ratioTextW = a;
		}
		
		public function set ratioIconH(a:Number):void
		{
			_ratioIconH = a;
		}
		
		public function set ratioIconW(a:Number):void
		{
			_ratioIconW = a;
		}
		
		public function set ratioSpaceBetween(a:Number):void
		{
			_ratioSpaceBetween = a;
		}
		
		public function set ratioSpaceDown(a:Number):void
		{
			_ratioSpaceDown = a;
		}
		
		public function set ratioSpaceLeft(a:Number):void
		{
			_ratioSpaceLeft = a;
		}
		
		public function set ratioSpaceRight(a:Number):void
		{
			_ratioSpaceRight = a;
		}
		
		public function set ratioSpaceUp(a:Number):void
		{
			_ratioSpaceUp = a;
		}
		
		// set state type
		
		public function set changeTypeBg(a:String):void
		{
			_changeTypeBg = a;
		}
		
		public function set changeTypeIcon(a:String):void
		{
			_changeTypeIcon = a;
		}
		
		public function set changeTypeText(a:String):void
		{
			_changeTypeText = a;
		}
		
		public function set iconLocation(a:String):void
		{
			_iconLocation = a;
		}
		
		public function set bgDimention(a:String):void
		{
			_bgDimention = a;
		}
		
		public function set model(a:String):void
		{
			_model = a;
		}
		
		// set activity
		
		public function set activeBgRoll(a:Boolean):void
		{
			_activeBgRoll = a;
		}
		
		public function set activeIconRoll(a:Boolean):void
		{
			_activeIconRoll = a;
		}
		
		public function set activeTextRoll(a:Boolean):void
		{
			_activeTextRoll = a;
		}
		
		public function set touchableBg(a:Boolean):void
		{
			_touchableBg = a;
		}
		
		// set font
		
		public function set fontType(a:String):void
		{
			_fontType = a;
		}
		
		public function set text(a:String):void
		{
			_text = a;
		}
		
		public function set ease(a:Function):void
		{
			_ease = a;
		}
		
		public function set embedFont(a:Boolean):void
		{
			_embedFont = a;
		}
		
		public function set iconMiddle(a:Boolean):void
		{
			_iconMiddle = a;
		}
		
		public function set textMiddle(a:Boolean):void
		{
			_textMiddle = a;
		}
		
		public function set timeForAnimation(a:Number):void
		{
			_timeForAnimation = a;
		}
		
		public function set fontSize(a:int):void
		{
			_fontSize = a;
		}
	}

}