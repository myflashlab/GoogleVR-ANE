package com.doitflash.starling
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import flash.geom.Point;
	
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	
	/**
	 * ...
	 * 
	 * @author Hadi Tavakoli - 7/26/2012 4:51 PM
	 */
	public class MyStarlingSprite extends Sprite 
	{
		protected var _bg:MySprite;
		protected var _bgTexture:Texture;
		protected var _defBgTexture:Texture;
		protected var _bgImage:Image;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _margin:Number = 0;
		protected var _marginX:Number = 0;
		protected var _marginY:Number = 0;
		protected var _xml:XML;
		protected var _configXml:XML;
		protected var _data:Object = {};
		protected var _id:int;
		protected var _base:Object;
		protected var _holder:Object;
		protected var _nativeStage:Object;
		
		protected var _bgAlpha:Number = 1;
		protected var _bgColor:uint = 0x000000;
		protected var _bgStrokeAlpha:Number = 1;
		protected var _bgStrokeColor:uint = 0xFF0000;
		protected var _bgStrokeThickness:Number = 1;
		protected var _bgTopLeftRadius:Number = 0;
		protected var _bgTopRightRadius:Number = 0;
		protected var _bgBottomLeftRadius:Number = 0;
		protected var _bgBottomRightRadius:Number = 0;
		
		protected var _rectangle:Rectangle;
		protected var _touchHoldArea:int = 20 * DeviceInfo.dpiScaleMultiplier;
		protected var _touchStartPoint:Point;
		protected var _touchEndPoint:Point;
		protected var _isTouched:Boolean;
		protected var _isInArea:Boolean;
		
		protected var _isDragging:Boolean;
		protected var _touchDistanceFromZero:Point;
		protected var _limitToParent:Boolean;
		
		protected var _touchData:Object = { };
		private var _myTarget:*;
		private var _buttonsArr:Array = [];
		
		private var _autoDimention:Boolean;
		
		public function MyStarlingSprite($autoDimention:Boolean = false ):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			_autoDimention = $autoDimention;
		}
		
		private function onStageRemoved(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			_buttonsArr = [];
			_myTarget = null;
			
			if (_rectangle) _rectangle = null;
		}
		
		private function onStageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			if (_defBgTexture)
			{
				_bgImage = new Image(_defBgTexture);
				this.addChildAt(_bgImage, 0);
			}
			
			if (_bgTexture) 
			{
				_bgImage = new Image(_bgTexture);
				this.addChildAt(_bgImage, 0);
			}
			
			if (!_rectangle)
			{
				_rectangle = new Rectangle(0, 0, _width, _height);
			}
		}
		
		public function drawBg(	$bgAlpha:Number = 1, 
								$bgColor:uint = 0xFFFFFF, 
								$bgStrokeAlpha:Number = 1, 
								$bgStrokeColor:uint = 0x000000, 
								$bgStrokeThickness:Number = 1,
								$bgTopLeftRadius:Number = 0,
								$bgTopRightRadius:Number = 0,
								$bgBottomLeftRadius:Number = 0,
								$bgBottomRightRadius:Number = 0):void
		{
			_bg = new MySprite();
			if ($bgAlpha) _bg.bgAlpha = _bgAlpha = $bgAlpha;
			if ($bgColor) _bg.bgColor = _bgColor = $bgColor;
			if ($bgStrokeAlpha) _bg.bgStrokeAlpha = _bgStrokeAlpha = $bgStrokeAlpha;
			if ($bgStrokeColor) _bg.bgStrokeColor = _bgStrokeColor = $bgStrokeColor;
			if ($bgStrokeThickness) _bg.bgStrokeThickness = _bgStrokeThickness = $bgStrokeThickness;
			if ($bgTopLeftRadius) _bg.bgTopLeftRadius = _bgTopLeftRadius = $bgTopLeftRadius;
			if ($bgTopRightRadius) _bg.bgTopRightRadius = _bgTopRightRadius = $bgTopRightRadius;
			if ($bgBottomLeftRadius) _bg.bgBottomLeftRadius = _bgBottomLeftRadius = $bgBottomLeftRadius;
			if ($bgBottomRightRadius) _bg.bgBottomRightRadius = _bgBottomRightRadius = $bgBottomRightRadius;
			
			_bg.width = _width;
			_bg.height = _height;
			
			_bg.drawBg();
			_bgTexture = _bg.getTexture();
			
			if (stage && !_bgImage)
			{
				_bgImage = new Image(_bgTexture);
				this.addChildAt(_bgImage, 0);
			}
		}
		
		public function updateBg($image:Image=null, $texture:Texture=null):Boolean
		{
			if ($texture)
			{
				$image = new Image($texture);
			}
			
			if ($image) 
			{
				if (_bgImage)
				{
					_bgImage.dispose();
					this.removeChild(_bgImage);
				}
				
				_bgImage = $image;
				this.addChildAt(_bgImage, 0);
				
				return true;
			}
			
			if (!_bgImage) return false;
			
			_bgImage.dispose();
			this.removeChild(_bgImage);
			
			_bgTexture = _bg.getTexture();
			_bgImage = new Image(_bgTexture);
			this.addChildAt(_bgImage, 0);
			
			return true;
		}
		
		public function getBgImage():Image
		{
			if (_bgImage) return _bgImage;
			else return null;
		}
		
		protected function onResize(e:*=null):void 
		{
			if (_bg)
			{
				_bg.width = _width;
				_bg.height = _height;
			}
			
			if (_defBgTexture && _bgImage)
			{
				_bgImage.width = _width;
				_bgImage.height = _height;
			}
			
			if (_rectangle)
			{
				_rectangle.width = _width;
				_rectangle.height = _height;
			}
		}
		
		protected function toBoolean(a:String):Boolean
		{
			if (a == "true") return true;
			
			return false;
		}
		
		protected function onMyTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if (!touch) return;
			
			var touchPos:Point = touch.getLocation(stage);
			var localTouchPos:Point = globalToLocal(touchPos);
			
			var hitTarget:* = hitTest(localTouchPos);
			
			if (touch.phase == TouchPhase.BEGAN)
			{
				var lng:int = _buttonsArr.length;
				for (var i:int = 0; i < lng; i++) 
				{
					if (hitTarget.name == _buttonsArr[i].name)
					{
						_myTarget = hitTarget;
						try
						{
							_myTarget.data.rollOver.call(null, _myTarget);
						}
						catch (err:Error) { };
						
						break;
					}
				}
			}
			
			// if _myTarget is still null, then there's no reason to continue with this function!
			if (!_myTarget) return;
			
			if (touch.phase == TouchPhase.MOVED)
			{
				if (hitTarget != _myTarget)
				{
					try
					{
						_myTarget.data.rollOut.call(null, _myTarget);
					}
					catch (err:Error) { };
				}
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				if (_myTarget.currentFrame > 0)
				{
					try
					{
						_myTarget.data.click.call(null, _myTarget);
					}
					catch (err:Error) { };
				}
				
				_myTarget = null;
			}
		}
		
		protected function isTouchContain($point:Point):Boolean
		{
			var localPoint:Point = this.globalToLocal($point);
			return _rectangle.contains(localPoint.x, localPoint.y);
		}
		
//----------------------------------------------------------------------------------------------------- Methods

		public function addButton(child:DisplayObject):void
		{
			_buttonsArr.push(child);
		}
		
		public function removeButton(child:DisplayObject):void
		{
			var lng:int = _buttonsArr.length;
			var i:int;
			for (i = 0; i < lng; i++) 
			{
				if (_buttonsArr[i] == child)
				{
					_buttonsArr.splice(i, 1);
					return;
				}
			}
		}
		
		public function removeAllButtons():void
		{
			_buttonsArr = [];
		}
		
		public function touchControl($touch:Touch):void
		{
			if (!stage || !touchable) return;
			
			// send the touch to all it's childern!
			var i:int;
			var child:*;
			for (i = 0; i < numChildren; i++)
			{
				try 
				{
					child = getChildAt(i);
					child.touchControl($touch);
				}
				catch (err:Error){}
			}
			
			if ($touch.phase == TouchPhase.BEGAN)
			{
				_touchStartPoint = $touch.getLocation(stage);
				
				// check if this touch is over this Sprite?
				if (isTouchContain(_touchStartPoint))
				{
					_isTouched = true;
					_isInArea = true;
					dispatchEventWith(MouseEvent.MOUSE_DOWN, false, {point:_touchStartPoint});
					dispatchEventWith(MouseEvent.MOUSE_OVER, false, {point:_touchStartPoint});
					//trace("MouseEvent.MOUSE_OVER >> " + _touchStartPoint)
				}
				
			}
			else if ($touch.phase == TouchPhase.MOVED)
			{
				if (!_touchStartPoint || !_isTouched) return;
				
				var pos:Point = $touch.getLocation(stage);
				if (Point.distance(pos, _touchStartPoint) <= _touchHoldArea)
				{
					if (!_isInArea)
					{
						dispatchEventWith(MouseEvent.MOUSE_OVER, false, {point:pos});
						//trace("MouseEvent.MOUSE_OVER >> " + pos)
					}
					
					_isInArea = true;
					dispatchEventWith(MouseEvent.MOUSE_MOVE, false, {point:pos, isInArea:_isInArea});
					//trace("MouseEvent.MOUSE_MOVE >> " + pos);
				}
				else
				{
					if (_isInArea)
					{
						dispatchEventWith(MouseEvent.MOUSE_OUT, false, {point:pos});
						//trace("MouseEvent.MOUSE_OUT >> " + pos);
					}
					
					_isInArea = false;
					dispatchEventWith(MouseEvent.MOUSE_MOVE, false, {point:pos, isInArea:_isInArea});
					//trace("MouseEvent.MOUSE_MOVE >> " + pos);
				}
			}
			else if ($touch.phase == TouchPhase.ENDED)
			{
				if (!_touchStartPoint || !_isTouched || !stage) return;
				
				_touchEndPoint = $touch.getLocation(stage);
				if (Point.distance(_touchEndPoint, _touchStartPoint) <= _touchHoldArea)
				{
					setTimeout(dispatchEventWith, 50, MouseEvent.CLICK, false, {point:_touchEndPoint});
				}
				
				setTimeout(dispatchEventWith, 51, MouseEvent.MOUSE_UP, false, {point:_touchEndPoint});
				
				_isTouched = false;
				_isInArea = false;
				_touchStartPoint = null;
			}
		}
		
		/**
		 * 
		 * @param	$limitToParent
		 */
		public function startDrag($limitToParent:Boolean=false):void
		{
			_limitToParent = $limitToParent;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		public function stopDrag():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onDown(e:Event):void
		{
			// get the distance between touch and 0, 0 of the target
			_touchDistanceFromZero = this.globalToLocal(e.data.point);
			_isDragging = true;
		}
			
		private function onUp(e:Event):void
		{
			_isDragging = false;
		}
			
		private function onMove(e:Event):void
		{
			if (_isDragging)
			{
				var localPoint:Point = this.parent.globalToLocal(e.data.point);
				this.x = localPoint.x - _touchDistanceFromZero.x;
				this.y = localPoint.y - _touchDistanceFromZero.y;
				
				if (_limitToParent)
				{
					if (this.x + this.width > this.parent.width) this.x = this.parent.width - this.width;
					if (this.y + this.height > this.parent.height) this.y = this.parent.height - this.height;
					
					if (this.x < 0) this.x = 0;
					if (this.y < 0) this.y = 0;
				}
				
				/*if (_dragRect)
				{		
					var globalToLocal_rect_begin:Point = stage.globalToLocal(new Point(_dragRect.x , _dragRect.y));
					var globalToLocal_rect_end:Point = stage.globalToLocal(new Point(_dragRect.width, _dragRect.height));
					
					if (this.x + this.width > globalToLocal_rect_begin.x + globalToLocal_rect_end.x) this.x = globalToLocal_rect_begin.x + globalToLocal_rect_end.x - this.width;
					if (this.y + this.height > globalToLocal_rect_begin.y + globalToLocal_rect_end.y) this.y = globalToLocal_rect_begin.y + globalToLocal_rect_end.y - this.height;
					
					if (this.x < globalToLocal_rect_begin.x) this.x = globalToLocal_rect_begin.x;
					if (this.y < globalToLocal_rect_begin.y) this.y = globalToLocal_rect_begin.y;
				}*/
			}
		}

//----------------------------------------------------------------------------------------------------- Getter - Setter
		
		public function get bgTexture():Texture
		{
			return _bgTexture;
		}
		
		public function get theBase():Object
		{
			return _base;
		}
		
		public function get myBase():Object
		{
			return _base;
		}
		
		public function set myBase(a:Object):void
		{
			_base = a;
		}
		
		public function set theBase(a:Object):void
		{
			_base = a;
		}
		
		public function get holder():Object
		{
			return _holder;
		}
		
		public function set holder(a:Object):void
		{
			_holder = a;
		}
		
		public function get nativeStage():Object
		{
			return _nativeStage;
		}
		
		public function set nativeStage(a:Object):void
		{
			_nativeStage = a;
		}
		
		override public function get width():Number
		{
			if (_autoDimention) 
			{
				return super.width;
			}
			
			return _width;
		}
		
		override public function set width(a:Number):void
		{
			if (_width != a)
			{
				_width = a;
				onResize();
			}
		}
		
		override public function get height():Number
		{
			if (_autoDimention) 
			{
				return super.height;
			}
			
			return _height;
		}
		
		override public function set height(a:Number):void
		{
			if (_height != a)
			{
				_height = a;
				onResize();
			}
		}
		
		public function get margin():Number
		{
			return _margin;
		}
		
		public function set margin(a:Number):void
		{
			_margin = a;
		}
		
		public function get marginX():Number
		{
			return _marginX;
		}
		
		public function set marginX(a:Number):void
		{
			_marginX = a;
		}
		
		public function get marginY():Number
		{
			return _marginY;
		}
		
		public function set marginY(a:Number):void
		{
			_marginY = a;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		public function set xml(a:XML):void
		{
			_xml = a;
		}
		
		public function get configXml():XML
		{
			return _configXml;
		}
		
		public function set configXml(a:XML):void
		{
			_configXml = a;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(a:Object):void
		{
			_data = a;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(a:int):void
		{
			_id = a;
		}
		
		public function set defBgTexture(a:Texture):void
		{
			_defBgTexture = a;
		}
		
		public function set touchHoldArea(a:int):void
		{
			_touchHoldArea = a;
		}
		
		public function get touchHoldArea():int
		{
			return _touchHoldArea;
		}
		
		public function get isTouched():Boolean
		{
			return _isTouched;
		}
	}
	
}