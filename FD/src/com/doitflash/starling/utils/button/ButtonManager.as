package  com.doitflash.starling.utils.button
{
	import com.doitflash.starling.MyStarlingSprite;
	import starling.display.Image;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	import com.doitflash.tools.sizeControl.CalculateFontSize;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	
	/**
	 * ...
	 * @author Majid Hejazi 9/26/2013 7:39 AM
	 */
	
	public class ButtonManager extends MyStarlingSprite
	{
		// input var
		private var _textureBG:Texture;
		private var _iconTextureOne:Texture;
		private var _iconTextureTwo:Texture;
		private var _iconTextureDeactive:Texture;
		
		private var _colorBgStateOneOut:uint;
		private var _colorBgStateOneOver:uint;
		private var _colorBgStateTwoOut:uint;
		private var _colorBgStateTwoOver:uint;
		private var _colorBgDeactiveOut:uint;
		private var _colorBgDeactiveOver:uint;
		private var _colorIconOneOut:uint;
		private var _colorIconOneOver:uint;
		private var _colorIconTwoOut:uint;
		private var _colorIconTwoOver:uint;
		private var _colorIconDeactiveOut:uint;
		private var _colorIconDeactiveOver:uint;
		private var _colorTextOut:String = "#000000";
		private var _colorTextOver:String = "#ffffff";
		private var _colorTextOutState2:String = "";
		private var _colorTextOverState2:String = "";
		private var _colorTextOutDeactive:String = "";
		private var _colorTextOverDeactive:String = "";
		
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
		private var _ratioSpaceLeft:Number;
		private var _ratioSpaceRight:Number;
		private var _ratioSpaceUp:Number;
		private var _ratioSpaceDown:Number;
		private var _ratioSpaceBetween:Number;
		
		private var _marginUp:Number = 0;
		private var _marginRight:Number = 0;
		private var _marginLeft:Number = 0;
		private var _marginDown:Number = 0;
		
		private var _timeForAnimation:Number = 1;
		
		private var _stateType:String = ButtonConst.ONE_STATE;
		private var _changeTypeBg:String = ButtonConst.CHANGE_ALPHA;
		private var _changeTypeIcon:String = ButtonConst.CHANGE_ALPHA;
		private var _changeTypeText:String = ButtonConst.CHANGE_ALPHA;
		
		private var _model:String = ButtonConst.ICON_AND_TEXT;
		private var _iconLocation:String = ButtonConst.ICON_LEFT;
		
		private var _bgDimention:String = ButtonConst.BG_SCALE;
		
		private var _fontType:String;
		private var _textStateOne:String;
		private var _textStateTwo:String;
		private var _textStateDeactive:String;
		
		private var _ease:Function = Elastic.easeOut;
		
		private var _activeBgRoll:Boolean = false;
		private var _activeIconRoll:Boolean = false;
		private var _activeTextRoll:Boolean = false;
		private var _changeRollDeactive:Boolean = false;
		
		private var _embedFont:Boolean = true; // dar in version bayad hatman font embed shode bashad
		
		private var _touchableBg:Boolean = false;
		
		private var _iconMiddle:Boolean = true;
		private var _textMiddle:Boolean = true;
		
		// need var
		private var _btnStateOne:Button;
		private var _btnStateTwo:Button;
		private var _btnStateDeactive:Button;
		
		private var _btnWidth:int;
		private var _btnHeight:int;
		private var _fontSize:int = 0;
		
		private var _isWidth:Boolean = false;
		private var _isHeight:Boolean = false;
		
		private var _rectangle:Rectangle;
		
		private var _state:int = 0;
		
		public function ButtonManager():void
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
				if (item is Button)
				{
					item.removeFromParent(true);
					item = null;
				}
				else if (item is Image)
				{
					item.texture.dispose();
					item.removeFromParent(true);
					item = null;
				}
			}
			
			if (_textureBG) 
			{
				_textureBG.dispose();
				_textureBG = null;
			}
			
			if (_iconTextureOne) 
			{
				_iconTextureOne.dispose();
				_iconTextureOne = null;
			}
			
			if (_iconTextureTwo) 
			{
				_iconTextureTwo.dispose();
				_iconTextureTwo = null;
			}
			
			if (_iconTextureDeactive) 
			{
				_iconTextureDeactive.dispose();
				_iconTextureDeactive = null;
			}
			
			if (_rectangle) _rectangle = null;
			
			trace("--ButtonManager--this: ", this.numChildren);
		}
		
		private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			calculates();
			
			drawBg(0, 0x000000, 0, 0x000000, 2);
			
			initBtns();
			initRectangle();
		}
		
		private function calculates():void
		{
			if (_width > 0)
			{
				_isWidth = true;
				_btnWidth = _width - _marginLeft - _marginRight;
			}
			
			if (_height > 0)
			{
				_isHeight = true;
				_btnHeight = _height - _marginUp - _marginDown;
			}
			
			if (_textureBG)
			{
				var wi:int = _textureBG.width;
				var he:int = _textureBG.height;
				
				if (_width != 0 && _height == 0)
				{
					_isHeight = true;
					_btnHeight = (_btnWidth / wi * he);
					_height = _btnHeight + _marginDown + _marginUp;
				}
				else if (_width == 0 && _height != 0)
				{
					_isWidth = true;
					_btnWidth = (_btnHeight / he * wi);
					_width = _btnWidth + _marginLeft + _marginRight;
				}
			}
		}
		
		private function initBtns():void
		{
			if (_stateType != ButtonConst.ONLY_DEACTIVE)
			{
				_btnStateOne = new Button();
				if (_textureBG) _btnStateOne.textureBG = Texture.fromTexture(_textureBG);
				if (_iconTextureOne) _btnStateOne.iconTexture = Texture.fromTexture(_iconTextureOne);
				
				if (_btnWidth > 0) _btnStateOne.width = _btnWidth;
				if (_btnHeight > 0) _btnStateOne.height = _btnHeight;
				_btnStateOne.x = _marginLeft;
				_btnStateOne.y = _marginUp;
				
				_btnStateOne.alphaBgOut = _alphaBgOut;
				_btnStateOne.alphaBgOver = _alphaBgOver;
				_btnStateOne.alphaIconOut = _alphaIconOut;
				_btnStateOne.alphaIconOver = _alphaIconOver;
				_btnStateOne.alphaTextOut = _alphaTextOut;
				_btnStateOne.alphaTextOver = _alphaTextOver;
				
				_btnStateOne.colorBgOut = _colorBgStateOneOut;
				_btnStateOne.colorBgOver = _colorBgStateOneOver;
				_btnStateOne.colorIconOut = _colorIconOneOut;
				_btnStateOne.colorIconOver = _colorIconOneOver;
				_btnStateOne.colorTextOut = _colorTextOut;
				_btnStateOne.colorTextOver = _colorTextOver;
				
				_btnStateOne.embedFont = _embedFont;
				_btnStateOne.fontType = _fontType;
				_btnStateOne.text = _textStateOne;
				_btnStateOne.fontSize = _fontSize;
				
				_btnStateOne.ratioIconH = _ratioIconH;
				_btnStateOne.ratioIconW = _ratioIconW;
				_btnStateOne.ratioSpaceBetween = _ratioSpaceBetween;
				_btnStateOne.ratioSpaceDown = _ratioSpaceDown;
				_btnStateOne.ratioSpaceLeft = _ratioSpaceLeft;
				_btnStateOne.ratioSpaceRight = _ratioSpaceRight;
				_btnStateOne.ratioSpaceUp = _ratioSpaceUp;
				_btnStateOne.ratioTextH = _ratioTextH;
				_btnStateOne.ratioTextW = _ratioTextW;
				
				_btnStateOne.timeForAnimation = _timeForAnimation;
				
				_btnStateOne.changeTypeBg = _changeTypeBg;
				_btnStateOne.changeTypeIcon = _changeTypeIcon;
				_btnStateOne.changeTypeText = _changeTypeText;
				
				_btnStateOne.model = _model;
				_btnStateOne.iconLocation = _iconLocation;
				_btnStateOne.bgDimention = _bgDimention;
				
				_btnStateOne.activeBgRoll = _activeBgRoll;
				_btnStateOne.activeIconRoll = _activeIconRoll;
				_btnStateOne.activeTextRoll = _activeTextRoll;
				
				_btnStateOne.touchableBg = _touchableBg;
				_btnStateOne.touchable = false;
				_btnStateOne.iconMiddle = _iconMiddle;
				_btnStateOne.textMiddle = _textMiddle;
				
				_btnStateOne.ease = _ease;
				
				this.addChild(_btnStateOne);
			}
			
			if (_stateType == ButtonConst.TWO_STATE || _stateType == ButtonConst.TWO_STATE_AND_DEACTIVE)
			{
				if (_colorTextOutState2 == "") _colorTextOutState2 = _colorTextOut;
				if (_colorTextOverState2 == "") _colorTextOverState2 = _colorTextOver;
				
				_btnStateTwo = new Button();
				if (_textureBG) _btnStateTwo.textureBG = Texture.fromTexture(_textureBG);
				if (_iconTextureTwo) _btnStateTwo.iconTexture = Texture.fromTexture(_iconTextureTwo);
				
				if (_btnWidth > 0) _btnStateTwo.width = _btnWidth;
				if (_btnHeight > 0) _btnStateTwo.height = _btnHeight;
				_btnStateTwo.x = _marginLeft;
				_btnStateTwo.y = _marginUp;
				
				_btnStateTwo.alphaBgOut = _alphaBgOut;
				_btnStateTwo.alphaBgOver = _alphaBgOver;
				_btnStateTwo.alphaIconOut = _alphaIconOut;
				_btnStateTwo.alphaIconOver = _alphaIconOver;
				_btnStateTwo.alphaTextOut = _alphaTextOut;
				_btnStateTwo.alphaTextOver = _alphaTextOver;
				
				_btnStateTwo.colorBgOut = _colorBgStateTwoOut;
				_btnStateTwo.colorBgOver = _colorBgStateTwoOver;
				_btnStateTwo.colorIconOut = _colorIconTwoOut;
				_btnStateTwo.colorIconOver = _colorIconTwoOver;
				_btnStateTwo.colorTextOut = _colorTextOutState2;
				_btnStateTwo.colorTextOver = _colorTextOverState2;
				
				_btnStateTwo.embedFont = _embedFont;
				_btnStateTwo.fontType = _fontType;
				_btnStateTwo.text = _textStateTwo;
				_btnStateTwo.fontSize = _fontSize;
				
				_btnStateTwo.ratioIconH = _ratioIconH;
				_btnStateTwo.ratioIconW = _ratioIconW;
				_btnStateTwo.ratioSpaceBetween = _ratioSpaceBetween;
				_btnStateTwo.ratioSpaceDown = _ratioSpaceDown;
				_btnStateTwo.ratioSpaceLeft = _ratioSpaceLeft;
				_btnStateTwo.ratioSpaceRight = _ratioSpaceRight;
				_btnStateTwo.ratioSpaceUp = _ratioSpaceUp;
				_btnStateTwo.ratioTextH = _ratioTextH;
				_btnStateTwo.ratioTextW = _ratioTextW;
				
				_btnStateTwo.timeForAnimation = _timeForAnimation;
				
				_btnStateTwo.changeTypeBg = _changeTypeBg;
				_btnStateTwo.changeTypeIcon = _changeTypeIcon;
				_btnStateTwo.changeTypeText = _changeTypeText;
				
				_btnStateTwo.model = _model;
				_btnStateTwo.iconLocation = _iconLocation;
				_btnStateTwo.bgDimention = _bgDimention;
				
				_btnStateTwo.activeBgRoll = _activeBgRoll;
				_btnStateTwo.activeIconRoll = _activeIconRoll;
				_btnStateTwo.activeTextRoll = _activeTextRoll;
				
				_btnStateTwo.touchableBg = _touchableBg;
				_btnStateTwo.touchable = false;
				_btnStateTwo.iconMiddle = _iconMiddle;
				_btnStateTwo.textMiddle = _textMiddle;
				
				_btnStateTwo.ease = _ease;
				
				this.addChild(_btnStateTwo);
			}
			
			
			if (_stateType == ButtonConst.ONE_STATE_AND_DEACTIVE || _stateType == ButtonConst.TWO_STATE_AND_DEACTIVE || _stateType == ButtonConst.ONLY_DEACTIVE)
			{
				if (_colorTextOutDeactive == "") _colorTextOutDeactive = _colorTextOut;
				if (_colorTextOverDeactive == "") _colorTextOverDeactive = _colorTextOver;
				
				_btnStateDeactive = new Button();
				if (_textureBG) _btnStateDeactive.textureBG = Texture.fromTexture(_textureBG);
				if (_iconTextureDeactive) _btnStateDeactive.iconTexture = Texture.fromTexture(_iconTextureDeactive);
				
				if (_btnWidth > 0) _btnStateDeactive.width = _btnWidth;
				if (_btnHeight > 0) _btnStateDeactive.height = _btnHeight;
				_btnStateDeactive.x = _marginLeft;
				_btnStateDeactive.y = _marginUp;
				
				_btnStateDeactive.alphaBgOut = _alphaBgOut;
				_btnStateDeactive.alphaBgOver = _alphaBgOut;
				_btnStateDeactive.alphaIconOut = _alphaIconOut;
				_btnStateDeactive.alphaIconOver = _alphaIconOut;
				_btnStateDeactive.alphaTextOut = _alphaTextOut;
				_btnStateDeactive.alphaTextOver = _alphaTextOut;
				
				_btnStateDeactive.colorBgOut = _colorBgDeactiveOut;
				_btnStateDeactive.colorBgOver = _colorBgDeactiveOver;
				_btnStateDeactive.colorIconOut = _colorIconDeactiveOut;
				_btnStateDeactive.colorIconOver = _colorIconDeactiveOver;
				_btnStateDeactive.colorTextOut = _colorTextOutDeactive;
				_btnStateDeactive.colorTextOver = _colorTextOverDeactive;
				
				_btnStateDeactive.embedFont = _embedFont;
				_btnStateDeactive.fontType = _fontType;
				_btnStateDeactive.text = _textStateDeactive;
				_btnStateDeactive.fontSize = _fontSize;
				
				_btnStateDeactive.ratioIconH = _ratioIconH;
				_btnStateDeactive.ratioIconW = _ratioIconW;
				_btnStateDeactive.ratioSpaceBetween = _ratioSpaceBetween;
				_btnStateDeactive.ratioSpaceDown = _ratioSpaceDown;
				_btnStateDeactive.ratioSpaceLeft = _ratioSpaceLeft;
				_btnStateDeactive.ratioSpaceRight = _ratioSpaceRight;
				_btnStateDeactive.ratioSpaceUp = _ratioSpaceUp;
				_btnStateDeactive.ratioTextH = _ratioTextH;
				_btnStateDeactive.ratioTextW = _ratioTextW;
				
				_btnStateDeactive.timeForAnimation = _timeForAnimation;
				
				_btnStateDeactive.changeTypeBg = _changeTypeBg;
				_btnStateDeactive.changeTypeIcon = _changeTypeIcon;
				_btnStateDeactive.changeTypeText = _changeTypeText;
				
				_btnStateDeactive.model = _model;
				_btnStateDeactive.iconLocation = _iconLocation;
				_btnStateDeactive.bgDimention = _bgDimention;
				
				_btnStateDeactive.activeBgRoll = _changeRollDeactive;
				_btnStateDeactive.activeIconRoll = _changeRollDeactive;
				_btnStateDeactive.activeTextRoll = _changeRollDeactive;
				
				_btnStateDeactive.touchableBg = _touchableBg;
				_btnStateDeactive.touchable = false;
				_btnStateDeactive.iconMiddle = _iconMiddle;
				_btnStateDeactive.textMiddle = _textMiddle;
				
				_btnStateDeactive.ease = _ease;
				
				this.addChild(_btnStateDeactive);
			}
			
			if (_stateType == ButtonConst.ONLY_DEACTIVE)
			{
				_btnStateDeactive.alpha = 1;
				_state = 3;
			}
			else if (_stateType == ButtonConst.ONE_STATE)
			{
				_btnStateOne.alpha = 1;
				_state = 1;
			}
			else if (_stateType == ButtonConst.ONE_STATE_AND_DEACTIVE)
			{
				_btnStateOne.alpha = 1;
				_btnStateDeactive.alpha = 0;
				_state = 1;
			}
			else if (_stateType == ButtonConst.TWO_STATE)
			{
				_btnStateOne.alpha = 1;
				_btnStateTwo.alpha = 0;
				_state = 1;
			}
			else if (_stateType == ButtonConst.TWO_STATE_AND_DEACTIVE)
			{
				_btnStateOne.alpha = 1;
				_btnStateTwo.alpha = 0;
				_btnStateDeactive.alpha = 0;
				_state = 1;
			}
		}
		
		private function initRectangle():void
		{
			_rectangle = new Rectangle(0, 0, _width, _height);
		}
		
//----------------------methods---------------------
		
		public function isTouch($point:Point):Boolean
		{
			var point:Point = globalToLocal($point);
			return _rectangle.contains(point.x, point.y);
		}
		
		public function goToStateOne():void
		{
			var oldState:int = _state;
			if (_state == 1)
			{
				
			}
			else if (_stateType == ButtonConst.ONE_STATE_AND_DEACTIVE)
			{
				_state = 1;
				TweenMax.to(_btnStateOne, _timeForAnimation, { alpha:1, ease:_ease } );
				TweenMax.to(_btnStateDeactive, _timeForAnimation, { alpha:0, ease:_ease } );
				_btnStateDeactive.rollOut();
			}
			else if (_stateType == ButtonConst.TWO_STATE)
			{
				_state = 1;
				TweenMax.to(_btnStateOne, _timeForAnimation, { alpha:1, ease:_ease } );
				TweenMax.to(_btnStateTwo, _timeForAnimation, { alpha:0, ease:_ease } );
				_btnStateTwo.rollOut();
			}
			else if (_stateType == ButtonConst.TWO_STATE_AND_DEACTIVE)
			{
				_state = 1;
				TweenMax.to(_btnStateOne, _timeForAnimation, { alpha:1, ease:_ease } );
				if (oldState == 2) 
				{
					TweenMax.to(_btnStateTwo, _timeForAnimation, { alpha:0, ease:_ease } );
					_btnStateTwo.rollOut();
				}
				if (oldState == 3) 
				{
					TweenMax.to(_btnStateDeactive, _timeForAnimation, { alpha:0, ease:_ease } );
					_btnStateDeactive.rollOut();
				}
			}
		}
		
		public function goToStateTwo():void
		{
			var oldState:int = _state;
			if (_state == 2)
			{
				
			}
			else if (_stateType == ButtonConst.TWO_STATE)
			{
				_state = 2;
				TweenMax.to(_btnStateOne, _timeForAnimation, { alpha:0, ease:_ease } );
				TweenMax.to(_btnStateTwo, _timeForAnimation, { alpha:1, ease:_ease } );
				_btnStateOne.rollOut();
			}
			else if (_stateType == ButtonConst.TWO_STATE_AND_DEACTIVE)
			{
				_state = 2;
				TweenMax.to(_btnStateTwo, _timeForAnimation, { alpha:1, ease:_ease } );
				if (oldState == 1) 
				{
					TweenMax.to(_btnStateOne, _timeForAnimation, { alpha:0, ease:_ease } );
					_btnStateOne.rollOut();
				}
				if (oldState == 3) 
				{
					TweenMax.to(_btnStateDeactive, _timeForAnimation, { alpha:0, ease:_ease } );
					_btnStateDeactive.rollOut();
				}
			}
		}
		
		public function goToStateDeactive():void
		{
			var oldState:int = _state;
			if (_state == 3)
			{
				
			}
			else if (_stateType == ButtonConst.ONE_STATE_AND_DEACTIVE)
			{
				_state = 3;
				TweenMax.to(_btnStateOne, _timeForAnimation, { alpha:0, ease:_ease } );
				TweenMax.to(_btnStateDeactive, _timeForAnimation, { alpha:1, ease:_ease } );
				_btnStateOne.rollOut();
			}
			else if (_stateType == ButtonConst.TWO_STATE_AND_DEACTIVE)
			{
				_state = 3;
				TweenMax.to(_btnStateDeactive, _timeForAnimation, { alpha:1, ease:_ease } );
				if (oldState == 1) 
				{
					TweenMax.to(_btnStateOne, _timeForAnimation, { alpha:0, ease:_ease } );
					_btnStateOne.rollOut();
				}
				if (oldState == 2) 
				{
					TweenMax.to(_btnStateTwo, _timeForAnimation, { alpha:0, ease:_ease } );
					_btnStateTwo.rollOut();
				}
			}
		}
		
		public function rollOver():void
		{
			if (_state == 1)
			{
				_btnStateOne.rollOver();
			}
			else if (_state == 2)
			{
				_btnStateTwo.rollOver();
			}
			else if (_state == 3)
			{
				_btnStateDeactive.rollOver();
			}
		}
		
		public function rollOut():void
		{
			if (_state == 1)
			{
				_btnStateOne.rollOut();
			}
			else if (_state == 2)
			{
				_btnStateTwo.rollOut();
			}
			else if (_state == 3)
			{
				_btnStateDeactive.rollOut();
			}
		}
		
		public function changeTextStateOne($text:String):void
		{
			if (_btnStateOne)
			{
				_btnStateOne.changeText($text);
				_textStateOne = $text;
			}
		}
		
		public function changeTextStateTwo($text:String):void
		{
			if (_btnStateTwo)
			{
				_btnStateTwo.changeText($text);
				_textStateTwo = $text;
			}
		}
		
		public function changeTextStateDeactive($text:String):void
		{
			if (_btnStateDeactive)
			{
				_btnStateDeactive.changeText($text);
				_textStateDeactive = $text;
			}
		}
		
//----------------------getter & setter--------------------------
		// set Textures
		
		public function set textureBG(a:Texture):void
		{
			_textureBG = a;
		}
		
		public function set iconTextureOne(a:Texture):void
		{
			_iconTextureOne = a;
		}
		
		public function set iconTextureTwo(a:Texture):void
		{
			_iconTextureTwo = a;
		}
		
		public function set iconTextureDeactive(a:Texture):void
		{
			_iconTextureDeactive = a;
		}
		
		// set colors
		
		public function set colorBgStateOneOut(a:uint):void
		{
			_colorBgStateOneOut = a;
		}
		
		public function set colorBgStateOneOver(a:uint):void
		{
			_colorBgStateOneOver = a;
		}
		
		public function set colorBgStateTwoOut(a:uint):void
		{
			_colorBgStateTwoOut = a;
		}
		
		public function set colorBgStateTwoOver(a:uint):void
		{
			_colorBgStateTwoOver = a;
		}
		
		public function set colorBgDeactiveOut(a:uint):void
		{
			_colorBgDeactiveOut = a;
		}
		
		public function set colorBgDeactiveOver(a:uint):void
		{
			_colorBgDeactiveOver = a;
		}
		
		public function set colorIconOneOut(a:uint):void
		{
			_colorIconOneOut = a;
		}
		
		public function set colorIconOneOver(a:uint):void
		{
			_colorIconOneOver = a;
		}
		
		public function set colorIconTwoOut(a:uint):void
		{
			_colorIconTwoOut = a;
		}
		
		public function set colorIconTwoOver(a:uint):void
		{
			_colorIconTwoOver = a;
		}
		
		public function set colorIconDeactiveOut(a:uint):void
		{
			_colorIconDeactiveOut = a;
		}
		
		public function set colorIconDeactiveOver(a:uint):void
		{
			_colorIconDeactiveOver = a;
		}
		
		public function set colorTextOut(a:String):void
		{
			_colorTextOut = a;
		}
		
		public function set colorTextOver(a:String):void
		{
			_colorTextOver = a;
		}
		
		public function set colorTextOutState2(a:String):void
		{
			_colorTextOutState2 = a;
		}
		
		public function set colorTextOverState2(a:String):void
		{
			_colorTextOverState2 = a;
		}
		
		public function set colorTextOutDeactive(a:String):void
		{
			_colorTextOutDeactive = a;
		}
		
		public function set colorTextOverDeactive(a:String):void
		{
			_colorTextOverDeactive = a;
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
		
		// set margin
		
		public function set marginDown(a:Number):void
		{
			_marginDown = a;
		}
		
		public function set marginLeft(a:Number):void
		{
			_marginLeft = a;
		}
		
		public function set marginRight(a:Number):void
		{
			_marginRight = a;
		}
		
		public function set marginUp(a:Number):void
		{
			_marginUp = a;
		}
		
		// set state type
		
		public function set stateType(a:String):void
		{
			_stateType = a;
		}
		
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
		
		public function set activeBgRoll(a:String):void
		{
			if (a == ButtonConst.ACTIVE_BG_ROLL)
			{
				_activeBgRoll = true;
			}
		}
		
		public function set activeIconRoll(a:String):void
		{
			if (a == ButtonConst.ACTIVE_ICON_ROLL)
			{
				_activeIconRoll = true;
			}
		}
		
		public function set activeTextRoll(a:String):void
		{
			if (a == ButtonConst.ACTIVE_TEXT_ROLL)
			{
				_activeTextRoll = true;
			}
		}
		
		// set font
		
		public function set fontType(a:String):void
		{
			_fontType = a;
		}
		
		public function set textStateOne(a:String):void
		{
			_textStateOne = a;
		}
		
		public function set textStateTwo(a:String):void
		{
			_textStateTwo = a;
		}
		
		public function set textStateDeactive(a:String):void
		{
			_textStateDeactive = a;
		}
		
		public function set ease(a:Function):void
		{
			_ease = a;
		}
		
		/*public function set embedFont(a:Boolean):void
		{
			_embedFont = a;
		}*/
		
		public function set touchableBg(a:Boolean):void
		{
			_touchableBg = a;
		}
		
		public function set changeRollDeactive(a:Boolean):void
		{
			_changeRollDeactive = a;
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
		
		public function get state():int
		{
			return _state;
		}
	}

}