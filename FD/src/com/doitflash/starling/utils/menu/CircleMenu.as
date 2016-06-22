package com.doitflash.starling.utils.menu
{
	import com.doitflash.starling.MyStarlingSprite;
	
	import starling.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.display.Image;
	import com.doitflash.tools.sizeControl.Scaler;
	
	import com.doitflash.starling.TextArea;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import com.greensock.TweenMax;
	import com.greensock.events.TweenEvent;
	import com.greensock.easing.*;
	
	/**
	 * CircleMenu makes dreams come true for Adobe AIR app developers. This class enables you to make circular menus.
	 * With some simple methods you are able to make circlular menus and add or remove items in your AIR project on your android device.
	 * 
	 * <b>Copyright 2013, MyAppSnippet. All rights reserved.</b>
	 * More Extensions on <a href="http://myappsnippet.com/">http://www.myappsnippet.com/</a>
	 * 
	 * @see com.doitflash.starling.utils.menu.CircleMenuEvent
	 * 
	 * @author Majid Hejazi - 7/14/2013 3:28 PM
	 * @version 1.0
	 * 
	 * @example The following example shows you how to initialize the Class in your project and how to use it.
	 * 
	 * <listing version="3.0">
	 * import com.doitflash.starling.utils.menu.CircleMenu;
	 * import com.doitflash.starling.utils.menu.CircleMenuEvent;
	 * 
	 * // set Class var
	 * var _menu:CircleMenu;
	 * 
	 * // initialize the holder. _iconsHolder & _photosHolder will be addchilded in holder.
	 * // _holder must have a specific width and height.
	 * var _holder:MyStarlingSprite = new MyStarlingSprite();
	 * _holder.width = 380;
	 * _holder.height = 600;
	 * _holder.drawBg(1, 0xe8e8e8, 1, 0x000000, 2);
	 * this.addChild(_holder);
	 * 
	 * // initialize the iconsHolder. icons will be addChilded in iconsHolder.
	 * // NOTE: iconsHolder's width and height will be calculated and defined by CircleMenu Class.
	 * var _iconsHolder:ClippedSprite = new ClippedSprite();
	 * _holder.addChild(_iconsHolder);
	 * 
	 * // initialize the photosHolder. Photos will be addChilded in photoHolder.
	 * // NOTE: photosHolder's width and height are calculated and defined by CircleMenu Class.
	 * var _photosHolder:ClippedSprite = new ClippedSprite();
	 * _holder.addChild(_photosHolder);
	 * 
	 * // initialize the Class
	 * _menu = new CircleMenu();
	 * 
	 * // When an item is touched, you will be informed by this Listener.
	 * _menu.addEventListener(CircleMenuEvent.TOUCH_ITEM, onTouch);
	 * 
	 * // For the textField within the iconsHolder, a TextFormat should be initialized and set in CircleMenu Class.
	 * var textFormat:TextFormat = new TextFormat("Arimo");
	 * _menu.textFormat = textFormat;
	 * 
	 * // This property is for enlarging the icon according to the device dpi.
	 * _menu.multiplier = 1;
	 * 
	 * // You can make a space between iconsHolder & photosHolder by the property spaceBetweenHolders.
	 * _menu.spaceBetweenHolders = 10;
	 * 
	 * // You can make a space between photos in photosHolder by the property spaceBetweenPhotos.
	 * _menu.spaceBetweenPhotos = 10;
	 * 
	 * // You can define the pixels of side photos that can be seen in photosHolder by the property widthOtherPhotoShow.
	 * _menu.widthOtherPhotoShow = 10;
	 * 
	 * // You can make a space between photos and textFields within the photosHolder by the property spaceBetweenPhotoText.
	 * _menu.spaceBetweenPhotoText = 10;
	 * 
	 * // You can make a space between iconsHolder and the down side of the holder by the property spaceDown.
	 * _menu.spaceDown = 50;
	 * 
	 * // You can make a space between iconsHolder or photosHolder and the left side of the holder by the property spaceLeft.
	 * _menu.spaceLeft = 50;
	 * 
	 * // You can make a space between iconsHolder or photosHolder and the right side of the holder by the property spaceRight.
	 * _menu.spaceRight = 30;
	 * 
	 * // You can make a space between photosHolder and the up side of the holder by the property spaceUp.
	 * _menu.spaceUp = 50;
	 * 
	 * // You can define the animation time by the property animationTime.
	 * _menu.animationTime = 2;
	 * 
	 * // You can define the scale of enlarging the upper icon by the property changeScale.
	 * _menu.changeScale = 0.2;
	 * 
	 * // The property embedFont should be set to true if you have embeded fonts in your project.
	 * _menu.embedFont = false;
	 * 
	 * // You can define the minimum of movement at the time of touch in order to speed up the animation by the property minMove.
	 * _menu.minMove = 100;
	 * 
	 * // You can define the maximum of touch time in order to speed up the animation by the property maxTime.
	 * _menu.maxTime = 500;
	 * 
	 * // You can define the animation speed by the property speed.
	 * _menu.speed = 10;
	 * 
	 * // You can define the default height of the icon by the property iconHeightDefault.
	 * _menu.iconHeightDefault = 32;
	 * 
	 * // You can define the default width of the icon by the property iconWidthDefault.
	 * _menu.iconWidthDefault = 32;
	 * 
	 * // You can define ratio of height to width by the property ratioWHPhoto.
	 * _menu.ratioWHPhoto = 0.3;
	 * 
	 * _menu.holder = _holder;
	 * _menu.iconsHolder = _iconsHolder;
	 * _menu.photosHolder = _photosHolder;
	 * 
	 * for (var i:int = 0; i < _array.lenght; i++) 
	 * {
	 * 		// You can give an Object to add a new Item by the method addItem.
	 * 		_menu.addItem(_array[i]);
	 * }
	 * 
	 * // Call this method to remove item by name.
	 * _menu.removeItemByName("itemName");
	 * 
	 * // Call this method to remove item by ID.
	 * _menu.removeItemByID(1);
	 * 
	 * // Call this method to arrange Items.
	 * _menu.itemArrange();
	 * 
	 * private function onTouch(e:CircleMenuEvent):void
	 * {
	 * 		// You can receive the information of the Item on which it is touched in form of an Object.
	 * 		var obj:Object = e.param; 
	 * 		for (var name:String in obj) 
	 * 		{
	 * 			trace(name, " = ", obj[name]);
	 * 		}
	 * }
	 * 
	 * </listing>
	 */
	
	public class CircleMenu extends EventDispatcher
	{
		private var _multiplier:Number = 1; // This property is for enlarging the icon according to the device dpi.
		
		private var _spaceUp:int = 5; // indicates the  upper space of the photosHolder.
		private var _spaceDown:int = 5; // indicates the bottom space of the iconsHolder.
		private var _spaceLeft:int = 5;
		private var _spaceRight:int = 5;
		private var _spaceBetweenHolders:int = 5;
		private var _spaceBetweenPhotoText:int = 5;
		private var _spaceBetweenPhotos:int = 5;
		private var _widthOtherPhotoShow:int = 10;
		private var _aroundBgShow:int = 0;
		
		private var _speed:int = 3;
		
		private var _minMove:int = 50;
		
		private var _maxTime:int = 500;
		
		private var _iconWidth:int; // This is calculated according to _iconWidthDefault & _multiplier.
		private var _iconHeight:int; // This is calculated according to _iconHeightDefault & _multiplier.
		
		private var _iconWidthDefault:int = 64;
		private var _iconHeightDefault:int = 64;
		
		private var _photoWidth:int;
		private var _photoHeight:int;
		
		private var _oldTime:int;
		private var _newTime:int;
		
		private var _minDistance:int = 10;
		
		private var _iconUp:int = 0;
		
		private var _changeScale:Number = 0.2;
		
		private var _ratioWHPhoto:Number = 0.7; // Ratio of height to width for the photo
		
		private var _animationTime:Number = 2;
		
		private var _rotationIcons:Boolean = false;
		private var _movePhotos:Boolean = false;
		private var _shouldDispatch:Boolean = false;
		private var _embedFont:Boolean = false;
		
		private var _teta:Number = 0;
		private var _r:Number = 0;
		private var _R:Number = 0;
		private var _a:Number = 0;
		private var _h:Number = 0;
		
		private var _myTween:TweenMax;
		
		private var _itemArray:Array = [];
		
		private var globalPointIcon:Point;
		private var globalPointPhoto:Point;
		
		private var startPoint:Point;
		private var movePoint1:Point;
		private var movePoint2:Point;
		
		private var _changeTeta:Number;
		
		private var _textName:TextArea;
		private var _textFormat:TextFormat;
		
		private var _stage:*;
		private var _iconsHolder:*;
		private var _photosHolder:*;
		
		private var _dpiScaleMultiplier:Number = 1;
		
		private var _iconIsUp:String = "";
		
		/**
		 * initialize the <code>CircleMenu</code> class 
		 */
		public function CircleMenu():void
		{
			
		}
		
// ------------------------------------------------------------------------ Private

		/**
		 * @private
		 */
		private function rotationIcons($changeTeta:Number):void
		{
			_changeTeta = $changeTeta;
			
			var lng:int = _itemArray.length;
			var i:int = 0;
			
			for (i = 0; i < lng; i++) 
			{
				_itemArray[i].teta = _itemArray[i].teta + _changeTeta;
				
				if (_itemArray[i].teta < 0) _itemArray[i].teta += Math.PI * 2;
				if (_itemArray[i].teta >= (Math.PI * 2)) _itemArray[i].teta -= Math.PI * 2;
				
				_itemArray[i].spriteIcon.x = _R + _r * Math.sin(_itemArray[i].teta);
				_itemArray[i].spriteIcon.y = _R - _r * Math.cos(_itemArray[i].teta);
				
				if (lng < 4)
				{
					if (_itemArray[i].teta >= (Math.PI * 2 - _teta - 0.1)) _itemArray[i].spritePhoto.x = (((_itemArray[i].teta - Math.PI * 2) / _teta) + 1) * (_photoWidth + _spaceBetweenPhotos) + _photoWidth * 0.5;
					else _itemArray[i].spritePhoto.x = ((_itemArray[i].teta / _teta) + 1) * (_photoWidth + _spaceBetweenPhotos) + _photoWidth * 0.5;
				}
				else
				{
					if (_itemArray[i].teta >= (Math.PI * 2 - 2 * _teta)) _itemArray[i].spritePhoto.x = (((_itemArray[i].teta - Math.PI * 2) / _teta) + 2) * (_photoWidth + _spaceBetweenPhotos) + _photoWidth * 0.5;
					else _itemArray[i].spritePhoto.x = ((_itemArray[i].teta / _teta) + 2) * (_photoWidth + _spaceBetweenPhotos) + _photoWidth * 0.5;
				}
				
				if (_itemArray[i].teta < _teta && _itemArray[i].teta >= 0)
				{
					_itemArray[i].spriteIcon.scaleX = 1 + ((_teta - _itemArray[i].teta) / _teta) * _changeScale;
					_itemArray[i].spriteIcon.scaleY = _itemArray[i].spriteIcon.scaleX;
				}
				else if (_itemArray[i].teta <= (Math.PI * 2) && _itemArray[i].teta > ((Math.PI * 2) - _teta))
				{
					_itemArray[i].spriteIcon.scaleX = 1 + ((_teta + (_itemArray[i].teta - (Math.PI * 2))) / _teta) * _changeScale;
					_itemArray[i].spriteIcon.scaleY = _itemArray[i].spriteIcon.scaleX;
				}
				else
				{
					_itemArray[i].spriteIcon.scaleX = 1;
					_itemArray[i].spriteIcon.scaleY = 1;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_stage);
			
			if (!touch)
			{
				return;
			}
			
			var image:Image;
			
			if (touch.phase == TouchPhase.BEGAN)
			{
				var pos:Point = touch.getLocation(_stage);
				_newTime = getTimer();
				
				if (_myTween)
				{
					_myTween.kill();
					refreshLocation();
				}
				
				if (pos.y > _iconsHolder.y )
				{
					_rotationIcons = true;
					startPoint = touch.getLocation(_stage);
					movePoint2 = startPoint;
					
					if (e.target is Image)
					{
						image = e.target as Image;
						var iconSprite:Sprite;
						
						if (image.parent is Sprite)
						{
							iconSprite = image.parent as Sprite;
							if (iconSprite.name) changeShowIcon(iconSprite.name);
						}
						else if (image.parent.parent is Sprite)
						{
							iconSprite = image.parent.parent as Sprite;
							if (iconSprite.name) changeShowIcon(iconSprite.name);
						}
						else if (image.parent.parent.parent is Sprite)
						{
							iconSprite = image.parent.parent.parent as Sprite;
							if (iconSprite.name) changeShowIcon(iconSprite.name);
						}
						else if (image.parent.parent.parent.parent is Sprite)
						{
							iconSprite = image.parent.parent.parent.parent as Sprite;
							if (iconSprite.name) changeShowIcon(iconSprite.name);
						}
						else if (image.parent.parent.parent.parent.parent is Sprite)
						{
							iconSprite = image.parent.parent.parent.parent.parent as Sprite;
							if (iconSprite.name) changeShowIcon(iconSprite.name);
						}
						else
						{
							changeShowIcon();
						}
					}
				}
				else if (pos.y < _photosHolder.height)
				{
					_movePhotos = true;
					startPoint = touch.getLocation(_stage);
					movePoint2 = startPoint;
					
					_newTime = getTimer();
					
					if (e.target is Image)
					{
						image = e.target as Image;
						var photoSprite:Sprite;
						
						if (image.parent is Sprite || image.parent.parent is Sprite || image.parent.parent.parent is Sprite || image.parent.parent.parent.parent is Sprite || image.parent.parent.parent.parent.parent is Sprite)
						{
							_shouldDispatch = true;
						}
					}
				}
			}
			else if (touch.phase == TouchPhase.MOVED)
			{
				movePoint1 = movePoint2;
				movePoint2 = touch.getLocation(_stage);
				
				if ((Math.pow(Math.pow((movePoint2.x - startPoint.x), 2) + Math.pow((movePoint2.y - startPoint.y), 2), 0.5)) > _minDistance)
				{
					if (_rotationIcons)
					{
						if (!_shouldDispatch) changeAlphaNameText();
						_oldTime = _newTime;
						
						var changeX:Number = movePoint2.x - movePoint1.x;
						var changeTeta:Number = changeX / _r;
						
						rotationIcons(changeTeta);
					}
					
					if (_movePhotos)
					{
						if (!_shouldDispatch) changeAlphaNameText();
						_oldTime = _newTime;
						
						var changeX1:Number = movePoint2.x - movePoint1.x;
						var changeTeta1:Number = changeX1 / (_photoWidth + _spaceBetweenPhotos) * _teta;
						
						rotationIcons(changeTeta1);
					}
					
					if (_shouldDispatch)
					{
						_shouldDispatch = false;
						changeShowIcon();
					}
				}
				
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				movePoint1 = movePoint2;
				movePoint2 = touch.getLocation(_stage);
				
				if (_rotationIcons)
				{
					_newTime = getTimer();
					
					movePoint2 = touch.getLocation(_stage);
					
					var sp:Number = 0;
					if ((_newTime - _oldTime) < _maxTime && (Math.abs(startPoint.x - movePoint2.x)) > _minMove) sp = _speed;
					
					var difTeta:Number;
					var rotateTeta:Number;
					
					if (movePoint2.x > movePoint1.x) 
					{
						difTeta = _teta - (_itemArray[0].teta % _teta);
						if (difTeta > (_teta / 2)) 
						{
							difTeta = _teta - difTeta;
							rotateTeta = - (sp * _teta) + difTeta;
						}
						else
						{
							rotateTeta = - (sp * _teta) - difTeta;
						}
					}
					else 
					{
						difTeta = _itemArray[0].teta % _teta;
						if (difTeta > (_teta / 2)) 
						{
							difTeta = _teta - difTeta;
							rotateTeta = sp * _teta - difTeta;
						}
						else
						{
							rotateTeta = sp * _teta + difTeta;
						}
					}
					
					var obj:Object = { };
					obj.rotateTeta = rotateTeta;
					obj.oldTeta = rotateTeta;
					
					_myTween = new TweenMax(obj, _animationTime, { rotateTeta:0 , ease:Elastic.easeOut } );
					_myTween.addEventListener(TweenEvent.UPDATE, updateFunction);
					
					function updateFunction(e:TweenEvent):void
					{
						rotationIcons((obj.rotateTeta - obj.oldTeta));
						obj.oldTeta = obj.rotateTeta;
						if (obj.rotateTeta < (_teta / 3) && obj.rotateTeta > (- _teta / 3))
						{
							compeleteRotation((_animationTime * 0.5));
						}
					}
					
					_rotationIcons = false;
					changeShowIcon();
				}
				
				if (_movePhotos)
				{
					_newTime = getTimer();
					
					movePoint2 = touch.getLocation(_stage);
					
					var difTeta1:Number;
					var rotateTeta1:Number;
					
					if (movePoint2.x > movePoint1.x) 
					{
						difTeta1 = _teta - (_itemArray[0].teta % _teta);
						if (difTeta1 > (_teta / 2)) 
						{
							difTeta1 = _teta - difTeta1;
							rotateTeta1 = difTeta1;
						}
						else
						{
							rotateTeta1 = - difTeta1;
						}
					}
					else 
					{
						difTeta1 = _itemArray[0].teta % _teta;
						if (difTeta1 > (_teta / 2)) 
						{
							difTeta1 = _teta - difTeta1;
							rotateTeta1 = - difTeta1;
						}
						else
						{
							rotateTeta1 = difTeta1;
						}
					}
					
					var obj1:Object = { };
					obj1.rotateTeta = rotateTeta1;
					obj1.oldTeta = rotateTeta1;
					
					_myTween = new TweenMax(obj1, _animationTime, { rotateTeta:0 , ease:Elastic.easeOut } );
					_myTween.addEventListener(TweenEvent.UPDATE, updateFunction1);
					
					function updateFunction1(e:TweenEvent):void
					{
						rotationIcons((obj1.rotateTeta - obj1.oldTeta));
						obj1.oldTeta = obj1.rotateTeta;
						if (obj1.rotateTeta < (_teta / 3) && obj1.rotateTeta > (- _teta / 3))
						{
							compeleteRotation((_animationTime * 0.5));
						}
					}
					
					_movePhotos = false;
					changeShowIcon();
					
				}
				
				if (_shouldDispatch)
				{
					if (e.target is Image)
					{
						image = e.target as Image;
						var iconSprite2:Sprite;
						
						if (image.parent is Sprite)
						{
							iconSprite2 = image.parent as Sprite;
							if (iconSprite2.name) dispatchItem(iconSprite2.name);
						}
						else if (image.parent.parent is Sprite)
						{
							iconSprite2 = image.parent.parent as Sprite;
							if (iconSprite2.name) dispatchItem(iconSprite2.name);
						}
						else if (image.parent.parent.parent is Sprite)
						{
							iconSprite2 = image.parent.parent.parent as Sprite;
							if (iconSprite2.name) dispatchItem(iconSprite2.name);
						}
						else if (image.parent.parent.parent.parent is Sprite)
						{
							iconSprite2 = image.parent.parent.parent.parent as Sprite;
							if (iconSprite2.name) dispatchItem(iconSprite2.name);
						}
						else if (image.parent.parent.parent.parent.parent is Sprite)
						{
							iconSprite2 = image.parent.parent.parent.parent.parent as Sprite;
							if (iconSprite2.name) dispatchItem(iconSprite2.name);
						}
					}
				}
				
			}
		}
		
		/**
		 * @private
		 */
		private function changeAlphaNameText():void
		{
			TweenMax.to(_textName, (_animationTime / 2), { alpha:0 , ease:Expo.easeOut } );
		}
		
		/**
		 * @private
		 */
		private function dispatchItem($name:String):void
		{
			_shouldDispatch = false;
			var i:int = 0;
			var lng:int = _itemArray.length;
			
			if ($name)
			{
				for (i = 0; i < lng; i++) 
				{
					if (_itemArray[i].spriteIcon.name == $name)
					{
						changeAlphaNameText();
						var obj:Object = { };
						obj.name = _itemArray[i].name;
						obj.id = _itemArray[i].id;
						obj.info = _itemArray[i].info;
						obj.index = _itemArray[i].index;
						obj.imageOut = _itemArray[i].imageOut;
						obj.imageOver = _itemArray[i].imageOver;
						obj.imagePhoto = _itemArray[i].imagePhoto;
						dispatchEvent(new CircleMenuEvent(CircleMenuEvent.TOUCH_ICON, obj));
						
						if ((_itemArray[i].teta < (Math.PI / 20) && _itemArray[i].teta > (-Math.PI / 20)) || ((_itemArray[i].teta - Math.PI * 2) < (Math.PI / 20) && (_itemArray[i].teta - Math.PI * 2) > (-Math.PI / 20)))
						{
							dispatchEvent(new CircleMenuEvent(CircleMenuEvent.TOUCH_ICON_IS_UP, obj));
						}
						
						var difTeta:Number = _itemArray[i].teta;
						if (difTeta > Math.PI) difTeta = - (Math.PI * 2 - difTeta);
						var obj1:Object = { };
						obj1.rotateTeta = difTeta;
						obj1.oldTeta = difTeta;
						
						_myTween = new TweenMax(obj1, _animationTime, { rotateTeta:0 , ease:Elastic.easeOut } );
						_myTween.addEventListener(TweenEvent.UPDATE, updateFunction);
						
						function updateFunction(e:TweenEvent):void
						{
							rotationIcons((obj1.rotateTeta - obj1.oldTeta));
							obj1.oldTeta = obj1.rotateTeta;
							if (obj1.rotateTeta < (_teta / 3) && obj1.rotateTeta > (- _teta / 3))
							{
								compeleteRotation((_animationTime * 0.5));
							}
						}
						
						break;
					}
					else if (_itemArray[i].spritePhoto.name == $name)
					{
						changeAlphaNameText();
						var obj2:Object = { };
						obj2.name = _itemArray[i].name;
						obj2.id = _itemArray[i].id;
						obj2.info = _itemArray[i].info;
						obj2.index = _itemArray[i].index;
						obj2.imageOut = _itemArray[i].imageOut;
						obj2.imageOver = _itemArray[i].imageOver;
						obj2.imagePhoto = _itemArray[i].imagePhoto;
						dispatchEvent(new CircleMenuEvent(CircleMenuEvent.TOUCH_PHOTO, obj2));
						
						var difTeta2:Number = _itemArray[i].teta;
						if (difTeta2 > Math.PI) difTeta2 = - (Math.PI * 2 - difTeta2);
						var obj3:Object = { };
						obj3.rotateTeta = difTeta2;
						obj3.oldTeta = difTeta2;
						
						_myTween = new TweenMax(obj3, _animationTime, { rotateTeta:0 , ease:Elastic.easeOut } );
						_myTween.addEventListener(TweenEvent.UPDATE, updateFunction2);
						
						function updateFunction2(e:TweenEvent):void
						{
							rotationIcons((obj3.rotateTeta - obj3.oldTeta));
							obj3.oldTeta = obj3.rotateTeta;
							if (obj3.rotateTeta < (_teta / 3) && obj3.rotateTeta > (- _teta / 3))
							{
								compeleteRotation((_animationTime * 0.5));
							}
						}
						
						break;
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function compeleteRotation($time:Number = 0.2):void
		{
			var i:int = 0;
			var lng:int = _itemArray.length;
			var obj:Object = isIconUp;
			
			if (obj.name != _iconIsUp && obj.teta < 0.01)
			{
				_iconIsUp = obj.name;
				_textName.img.texture.dispose();
				_textName.img.dispose();
				_textName.txt.text = _iconIsUp;
				_textName.refresh();
				_textName.x = _R - _textName.width * 0.5;
			}
			
			if (_textName.alpha == 0)
			{
				TweenMax.to(_textName, $time, { alpha:1 , ease:Expo.easeOut } );
			}
		}
		
		/**
		 * @private
		 */
		private function refreshLocation():void
		{
			var difTeta:Number = _itemArray[0].teta % _teta;
			var rotateTeta:Number;
			if (difTeta > (_teta / 2)) 
			{
				difTeta = _teta - difTeta;
				rotateTeta = difTeta;
			}
			else
			{
				rotateTeta = - difTeta;
			}
			
			rotationIcons(rotateTeta);
		}
		
		/**
		 * @private
		 */
		private function changeShowIcon($name:String = null):void
		{
			var i:int = 0;
			var lng:int = _itemArray.length;
			
			if ($name)
			{
				for (i = 0; i < lng; i++) 
				{
					if (_itemArray[i].spriteIcon.name == $name)
					{
						_shouldDispatch = true;
						TweenMax.to(_itemArray[i].imageOver, (_animationTime / 2), { alpha:1, ease:Expo.easeOut } );
						TweenMax.to(_itemArray[i].imageOut, (_animationTime / 2), { alpha:0, ease:Expo.easeOut } );
					}
					else
					{
						TweenMax.to(_itemArray[i].imageOver, (_animationTime / 2), { alpha:0, ease:Expo.easeOut } );
						TweenMax.to(_itemArray[i].imageOut, (_animationTime / 2), { alpha:1, ease:Expo.easeOut } );
					}
				}
			}
			else
			{
				for (i = 0; i < lng; i++) 
				{
					TweenMax.to(_itemArray[i].imageOver, (_animationTime / 2), { alpha:0, ease:Expo.easeOut } );
					TweenMax.to(_itemArray[i].imageOut, (_animationTime / 2), { alpha:1, ease:Expo.easeOut } );
				}
			}
			
		}

// ------------------------------------------------------------------------ Methods

		/**
		 * When you're done with this class, call this method to clean up the memory.
		 */
		public function dispose():void
		{
			removeAllItem();
			_itemArray = null;
		}
		
		/**
		 * Call this method to add item.
		 * NOTE: $itemData is an object. This object contains the following six parameters:
		 * 1- id:int
		 * 2- name:String
		 * 3- info:htmlText
		 * 4- photo:Image
		 * 5- icon_out:Image
		 * 6- icon_over:Image
		 * NOTE: After adding all Items the method itemArrange() should be called.
		 * 
		 * @param	$itemData
		 */
		public function addItem($itemData:Object, $bg:Texture = null):void
		{
			_iconWidth = _iconWidthDefault * _multiplier;
			_iconHeight = _iconHeightDefault * _multiplier;
			
			_photoWidth = _stage.width - _spaceLeft - _spaceRight - 2 * _widthOtherPhotoShow - 2 * _spaceBetweenPhotos;
			_photoHeight = _photoWidth * _ratioWHPhoto;
			
			var obj:Object = { };
			obj = $itemData;
			obj.index = _itemArray.length;
			obj.teta = 0;
			
			var spriteIcon:Sprite = new Sprite();
			spriteIcon.name = obj.name + String(obj.index);
			obj.imageOut.width = _iconWidth;
			obj.imageOut.height = _iconHeight;
			obj.imageOut.smoothing = TextureSmoothing.BILINEAR;
			obj.imageOut.alpha = 1;
			spriteIcon.addChild(obj.imageOut);
			
			obj.imageOver.width = _iconWidth;
			obj.imageOver.height = _iconHeight;
			obj.imageOver.smoothing = TextureSmoothing.BILINEAR;
			obj.imageOver.alpha = 0;
			spriteIcon.addChild(obj.imageOver);
			
			spriteIcon.pivotX = spriteIcon.width >> 1;
			spriteIcon.pivotY = spriteIcon.height >> 1;
			
			obj.spriteIcon = spriteIcon;
			
			var _resizedArray:Array = [];
			if ($bg) _resizedArray = Scaler.resize([obj.imagePhoto.width, obj.imagePhoto.height], [_photoWidth - 2 * _aroundBgShow, _photoHeight - 2 * _aroundBgShow], true, true);
			else _resizedArray = Scaler.resize([obj.imagePhoto.width, obj.imagePhoto.height], [_photoWidth, _photoHeight], true, true);
			
			var spritePhoto:Sprite = new Sprite();
			spritePhoto.name = obj.name + "Photo";
			obj.imagePhoto.width = _resizedArray[0];
			obj.imagePhoto.height = _resizedArray[1];
			obj.imagePhoto.smoothing = TextureSmoothing.BILINEAR;
			obj.imagePhoto.alpha = 1;
			if ($bg) 
			{
				obj.imagePhoto.x = ((_photoWidth - _resizedArray[0]) >> 1) + _aroundBgShow;
				obj.imagePhoto.y = _aroundBgShow;
			}
			else
			{
				obj.imagePhoto.x = (_photoWidth - _resizedArray[0]) >> 1;
				obj.imagePhoto.y = 0;
			}
			
			var textArea:TextArea = new TextArea();
			textArea.txt.autoSize = TextFieldAutoSize.LEFT;
			textArea.txt.antiAliasType = AntiAliasType.ADVANCED;
			textArea.txt.mouseEnabled = false;
			textArea.txt.embedFonts = _embedFont;
			textArea.txt.width = _photoWidth - 10;
			textArea.txt.multiline = true;
			textArea.txt.wordWrap = true;
			textArea.txt.htmlText = obj.info;
			textArea.refresh();
			textArea.x = (_photoWidth - textArea.width) >> 1;
			if ($bg) textArea.y = obj.imagePhoto.height + _spaceBetweenPhotoText + 2 * _aroundBgShow;
			else textArea.y = obj.imagePhoto.height + _spaceBetweenPhotoText;
			spritePhoto.addChild(textArea);
			
			obj.textArea = textArea;
			
			if ($bg)
			{
				var bgImage:Image = new Image($bg);
				bgImage.width = _resizedArray[0] + 2 * _aroundBgShow;
				bgImage.height = _resizedArray[1] + 2 * _aroundBgShow;
				bgImage.x = (_photoWidth - _resizedArray[0]) >> 1;
				
				spritePhoto.addChild(bgImage);
				$bg.dispose();
				$bg = null;
			}
			
			spritePhoto.addChild(obj.imagePhoto);
			
			spritePhoto.pivotX = spritePhoto.width >> 1;
			
			obj.spritePhoto = spritePhoto;
			
			_itemArray.push(obj);
		}
		
		/**
		 * Call this method to remove item by ID
		 * This method receives one parameter.
		 * NOTE: After using this method, the method itemArrange() should be called.
		 * 
		 * @param	$id
		 */
		public function removeItemByID($id:int):void
		{
			if (_stage.hasEventListener(TouchEvent.TOUCH)) _stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			if (_myTween)
			{
				_myTween.kill();
				refreshLocation();
			}
			
			if (_iconsHolder.getChildIndex(_textName)) 
			{
				_textName.img.texture.dispose();
				_textName.img.dispose();
				_iconsHolder.removeChild(_textName, true);
				_textName = null;
			}
			
			var i:int = 0;
			var lng:int = _itemArray.length;
			
			for (i = 0; i < lng; i++) 
			{
				if (_itemArray[i].id == $id)
				{
					var j:int;
					var lng2:int;
					var item:*;
					
					if (_iconsHolder.getChildIndex(_itemArray[i].spriteIcon))
					{
						lng2 = _itemArray[i].spriteIcon.numChildren;
						
						for (j = lng2-1; j >= 0; j--) 
						{
							item = _itemArray[i].spriteIcon.getChildAt(j);
							if (item is Image)
							{
								item.texture.dispose();
								item.removeFromParent(true);
								item = null;
							}
						}
						_iconsHolder.removeChild(_itemArray[i].spriteIcon, true);
					}
					if (_photosHolder.getChildIndex(_itemArray[i].spritePhoto)) 
					{
						lng2 = _itemArray[i].spritePhoto.numChildren;
						
						for (j = lng2-1; j >= 0; j--) 
						{
							item = _itemArray[i].spritePhoto.getChildAt(j);
							if (item is Image)
							{
								item.texture.dispose();
								item.removeFromParent(true);
								item = null;
							}
							else if (item is TextArea)
							{
								item.img.texture.dispose();
								item.img.dispose();
								item.removeFromParent(true);
								item = null;
							}
						}
						_photosHolder.removeChild(_itemArray[i].spritePhoto, true);
					}
					
					_itemArray.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * Call this method to remove item by name
		 * This method receives one parameter.
		 * NOTE: After using this method, the method itemArrange() should be called.
		 * 
		 * @param	$name
		 */
		public function removeItemByName($name:String):void
		{
			if (_stage.hasEventListener(TouchEvent.TOUCH)) _stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			if (_myTween)
			{
				_myTween.kill();
				refreshLocation();
			}
			
			if (_iconsHolder.getChildIndex(_textName)) 
			{
				_textName.img.texture.dispose();
				_textName.img.dispose();
				_iconsHolder.removeChild(_textName, true);
				_textName = null;
			}
			
			var i:int = 0;
			var lng:int = _itemArray.length;
			
			for (i = 0; i < lng; i++) 
			{
				if (_itemArray[i].name == $name)
				{
					var j:int;
					var lng2:int;
					var item:*;
					
					if (_iconsHolder.getChildIndex(_itemArray[i].spriteIcon)) 
					{
						lng2 = _itemArray[i].spriteIcon.numChildren;
						
						for (j = lng2-1; j >= 0; j--) 
						{
							item = _itemArray[i].spriteIcon.getChildAt(j);
							if (item is Image)
							{
								item.texture.dispose();
								item.removeFromParent(true);
								item = null;
							}
						}
						_iconsHolder.removeChild(_itemArray[i].spriteIcon, true);
					}
					if (_photosHolder.getChildIndex(_itemArray[i].spritePhoto)) 
					{
						lng2 = _itemArray[i].spritePhoto.numChildren;
						
						for (j = lng2-1; j >= 0; j--) 
						{
							item = _itemArray[i].spritePhoto.getChildAt(j);
							if (item is Image)
							{
								item.texture.dispose();
								item.removeFromParent(true);
								item = null;
							}
							else if (item is TextArea)
							{
								item.img.texture.dispose();
								item.img.dispose();
								item.removeFromParent(true);
								item = null;
							}
						}
						_photosHolder.removeChild(_itemArray[i].spritePhoto, true);
					}
					
					_itemArray.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * Call this method to remove all Items
		 * 
		 */
		public function removeAllItem():void
		{
			if (_stage.hasEventListener(TouchEvent.TOUCH)) _stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			if (_myTween)
			{
				_myTween.kill();
				refreshLocation();
			}
			
			if (_iconsHolder.getChildIndex(_textName)) 
			{
				_textName.img.texture.dispose();
				_textName.img.dispose();
				_iconsHolder.removeChild(_textName, true);
				_textName = null;
			}
			
			var i:int = 0;
			var lng:int = _itemArray.length;
			var j:int;
			var lng2:int;
			var item:*;
			
			for (i = lng - 1; i >= 0; i--) 
			{
				if (_iconsHolder.getChildIndex(_itemArray[i].spriteIcon)) 
				{
					lng2 = _itemArray[i].spriteIcon.numChildren;
					
					for (j = lng2-1; j >= 0; j--) 
					{
						item = _itemArray[i].spriteIcon.getChildAt(j);
						if (item is Image)
						{
							item.texture.dispose();
							item.removeFromParent(true);
							item = null;
						}
					}
					_iconsHolder.removeChild(_itemArray[i].spriteIcon, true);
				}
				
				if (_photosHolder.getChildIndex(_itemArray[i].spritePhoto)) 
				{
					lng2 = _itemArray[i].spritePhoto.numChildren;
					
					for (j = lng2-1; j >= 0; j--) 
					{
						item = _itemArray[i].spritePhoto.getChildAt(j);
						if (item is Image)
						{
							item.texture.dispose();
							item.removeFromParent(true);
							item = null;
						}
						else if (item is TextArea)
						{
							item.img.texture.dispose();
							item.img.dispose();
							item.removeFromParent(true);
							item = null;
						}
					}
					_photosHolder.removeChild(_itemArray[i].spritePhoto, true);
				}
			}
			
			_itemArray.splice(0);
		}
		
		/**
		 * Call this method to arrange Items.
		 * NOTE: After adding or removing Items, this method should be called. 
		 */
		public function itemArrange():void
		{
			var lng:int = _itemArray.length;
			var i:int = 0;
			
			if (lng > 2)
			{
				_teta = Math.PI * 2 / lng;
				_a = Math.pow((Math.pow(_iconWidth * 0.5, 2) + Math.pow(_iconHeight * 0.5, 2)), 0.5);
				
				if (lng == 3) _h = 5 / 14 * _iconWidth;
				else if (lng == 4) _h = 5.5 / 14 * _iconWidth;
				else if (lng == 5) _h = 6 / 14 * _iconWidth;
				else if (lng == 6) _h = 7 / 9 * _iconWidth;
				else if (lng == 7) _h = 1.1 * _iconWidth;
				else if (lng == 8) _h = 10 / 7 * _iconWidth;
				else if (lng == 9) _h = 10 / 6 * _iconWidth;
				else if (lng == 10) _h = 10 / 5.2 * _iconWidth;
				else if (lng == 11) _h = 11 / 4.7 * _iconWidth;
				else if (lng == 12) _h = 12 / 4.4 * _iconWidth;
				else if (lng == 13) _h = 13 / 4.2 * _iconWidth;
				else if (lng == 14) _h = 14 / 4.1 * _iconWidth;
				else if (lng == 15) _h = 15 / 4 * _iconWidth;
				else _h = lng / 4 * _iconWidth;
				
				if (_teta >= (Math.PI / 2)) _r = 3 * _h;
				else _r = Math.pow((_h * _h / (2 * (1 - Math.sin(_teta)))), 0.5)
				_R = _r + _a;
				
				if (_R < (_stage.width * 0.5))
				{
					_R = _stage.width * 0.5;
					_r = _R - _a;
				}
				
				_textName = new TextArea();
				_textName.txt.defaultTextFormat = _textFormat;
				_textName.txt.embedFonts = _embedFont;
				_textName.txt.autoSize = TextFieldAutoSize.LEFT;
				
				for (i = 0; i < lng; i++) 
				{
					_itemArray[i].spriteIcon.x = _R + _r * Math.sin(i * _teta);
					_itemArray[i].spriteIcon.y = _R - _r * Math.cos(i * _teta);
					_itemArray[i].teta = i * _teta;
					
					if (Math.abs(_itemArray[i].spriteIcon.x - _R) < (_r * Math.sin(_teta)) && _itemArray[i].spriteIcon.y < (_R - (_r * Math.cos(_teta))))
					{
						_textName.txt.text = _itemArray[i].name;
						_itemArray[i].spriteIcon.scaleX = 1 + _changeScale;
						_itemArray[i].spriteIcon.scaleY = _itemArray[i].spriteIcon.scaleX;
					}
					
					_iconsHolder.addChild(_itemArray[i].spriteIcon);
				}
				
				_iconsHolder.x = ((_stage.width - _spaceLeft - _spaceRight - (2 * _R)) >> 1) + _spaceLeft;
				
				if (lng < 4)
				{
					_iconsHolder.y = _stage.height - (_R / 2/* - _r * Math.cos(0.9 * _teta)*/) - _spaceDown;
				}
				else if (lng < 5)
				{
					_iconsHolder.y = _stage.height - (_R * 2 / 3/* - _r * Math.cos(1.4 * _teta)*/) - _spaceDown;
				}
				else if (lng < 9)
				{
					_iconsHolder.y = _stage.height - (_R - _r * Math.cos(1.5 * _teta)) - _spaceDown;
				}
				else
				{
					_iconsHolder.y = _stage.height - (_R - _r * Math.cos(2.5 * _teta)) - _spaceDown;
				}
				
				_textName.refresh();
				_textName.x = _R - _textName.width * 0.5;
				if (lng == 3) _textName.y = _R - 20;
				else _textName.y = _stage.height - _iconsHolder.y - _textName.height - 10 - _spaceDown;
				
				
				_iconsHolder.addChild(_textName);
				
				for (i = 0; i < lng; i++) 
				{
					if (lng < 4)
					{
						if (_itemArray[i].teta >= (Math.PI * 2 - _teta - 0.1)) _itemArray[i].spritePhoto.x = (((_itemArray[i].teta - Math.PI * 2) / _teta) + 1) * (_photoWidth + _spaceBetweenPhotos) + _photoWidth * 0.5;
						else _itemArray[i].spritePhoto.x = ((_itemArray[i].teta / _teta) + 1) * (_photoWidth + _spaceBetweenPhotos) + _photoWidth * 0.5;
					}
					else
					{
						if (_itemArray[i].teta >= (Math.PI * 2 - 2 * _teta)) _itemArray[i].spritePhoto.x = (((_itemArray[i].teta - Math.PI * 2) / _teta) + 2) * (_photoWidth + _spaceBetweenPhotos) + _photoWidth * 0.5;
						else _itemArray[i].spritePhoto.x = ((_itemArray[i].teta / _teta) + 2) * (_photoWidth + _spaceBetweenPhotos) + _photoWidth * 0.5;
					}
					
					_photosHolder.addChild(_itemArray[i].spritePhoto);
				}
				
				if (lng < 4)
				{
					_photosHolder.x = _widthOtherPhotoShow - _photoWidth + _spaceLeft - _aroundBgShow;
				}
				else
				{
					_photosHolder.x = _widthOtherPhotoShow - (2 * _photoWidth + _spaceBetweenPhotos) + _spaceLeft - _aroundBgShow;
				}
				
				_photosHolder.y = _spaceUp;
				
				globalPointIcon = _stage.localToGlobal(new Point(_spaceLeft, _iconsHolder.y));
				_iconsHolder.clipRect = new Rectangle(globalPointIcon.x, globalPointIcon.y, (_stage.width - _spaceLeft - _spaceRight) * _dpiScaleMultiplier, (_stage.height - _iconsHolder.y - _spaceDown) * _dpiScaleMultiplier);
				
				globalPointPhoto = _stage.localToGlobal(new Point(_spaceLeft, _spaceUp));
				_photosHolder.clipRect = new Rectangle(globalPointPhoto.x, globalPointPhoto.y, (_stage.width - _spaceLeft - _spaceRight) * _dpiScaleMultiplier, (_iconsHolder.y - _spaceBetweenHolders) * _dpiScaleMultiplier);
				
				for (i = 0; i < lng; i++) 
				{
					if (_itemArray[i].id == _iconUp)
					{
						rotationIcons(Math.PI * 2 - _itemArray[i].teta);
						compeleteRotation(0);
					}
				}
				
				_stage.addEventListener(TouchEvent.TOUCH, onTouch);
			}
		}

// ------------------------------------------------------------------------ Getter - Setter
	
		/**
		 * This property is for enlarging icons according to the device dpi.
		 * @default 1
		 */
		public function set multiplier(a:Number):void
		{
			_multiplier = a;
		}
		/**
		 * @private
		 */
		public function get multiplier():Number
		{
			return _multiplier;
		}
		
		/**
		 * indicates the upper space of the photosHolder.
		 * @default 5
		 */
		public function get spaceUp():int
		{
			return _spaceUp;
		}
		/**
		 * @private
		 */
		public function set spaceUp(a:int):void
		{
			_spaceUp = a;
		}
		
		/**
		 * indicates the bottom space of the iconsHolder.
		 * @default 5
		 */
		public function get spaceDown():int
		{
			return _spaceDown;
		}
		/**
		 * @private
		 */
		public function set spaceDown(a:int):void
		{
			_spaceDown = a;
		}
		
		/**
		 * indicates the left space of the iconsHolder & photosHolder.
		 * @default 5
		 */
		public function get spaceLeft():int
		{
			return _spaceLeft;
		}
		/**
		 * @private
		 */
		public function set spaceLeft(a:int):void
		{
			_spaceLeft = a;
		}
		
		/**
		 * indicates the right space of the iconsHolder & photosHolder.
		 * @default 5
		 */
		public function get spaceRight():int
		{
			return _spaceRight;
		}
		/**
		 * @private
		 */
		public function set spaceRight(a:int):void
		{
			_spaceRight = a;
		}
		
		/**
		 * indicates the space between the photosHolder & iconsHolder.
		 * @default 5
		 */
		public function get spaceBetweenHolders():int
		{
			return _spaceBetweenHolders;
		}
		/**
		 * @private
		 */
		public function set spaceBetweenHolders(a:int):void
		{
			_spaceBetweenHolders = a;
		}
		
		/**
		 * indicates the space between the photo & textField in photosHolder.
		 * @default 5
		 */
		public function get spaceBetweenPhotoText():int
		{
			return _spaceBetweenPhotoText;
		}
		/**
		 * @private
		 */
		public function set spaceBetweenPhotoText(a:int):void
		{
			_spaceBetweenPhotoText = a;
		}
		
		/**
		 * indicates the space between the photos in photosHolder.
		 * @default 5
		 */
		public function get spaceBetweenPhotos():int
		{
			return _spaceBetweenPhotos;
		}
		/**
		 * @private
		 */
		public function set spaceBetweenPhotos(a:int):void
		{
			_spaceBetweenPhotos = a;
		}
		
		/**
		 * This property defines the scale of enlarging the upper icon.
		 * @default 0.2
		 */
		public function get changeScale():Number
		{
			return _changeScale;
		}
		/**
		 * @private
		 */
		public function set changeScale(a:Number):void
		{
			_changeScale = a;
		}
		
		/**
		 * This property defines some parts of side photos that are going to be shown.
		 * @default 10
		 */
		public function get widthOtherPhotoShow():int
		{
			return _widthOtherPhotoShow;
		}
		/**
		 * @private
		 */
		public function set widthOtherPhotoShow(a:int):void
		{
			_widthOtherPhotoShow = a;
		}
		
		/**
		 * 
		 * @default 0
		 */
		public function get aroundBgShow():int
		{
			return _aroundBgShow;
		}
		/**
		 * @private
		 */
		public function set aroundBgShow(a:int):void
		{
			_aroundBgShow = a;
		}
		
		/**
		 * This property defines the animation speed.
		 * @default 3
		 */
		public function get speed():int
		{
			return _speed;
		}
		/**
		 * @private
		 */
		public function set speed(a:int):void
		{
			_speed = a;
		}
		
		/**
		 * This property defines the minimum movement of pixels to show the animation.
		 * @default 50
		 */
		public function get minMove():int
		{
			return _minMove;
		}
		/**
		 * @private
		 */
		public function set minMove(a:int):void
		{
			_minMove = a;
		}
		
		/**
		 * This property defines the maximum time between touch moves to show the animation.
		 * Based on milliseconds
		 * @default 500
		 */
		public function get maxTime():int
		{
			return _maxTime;
		}
		/**
		 * @private
		 */
		public function set maxTime(a:int):void
		{
			_maxTime = a;
		}
		
		/**
		 * This property defines the icon width.
		 * @default 500
		 */
		public function get iconWidthDefault():int
		{
			return _iconWidthDefault;
		}
		/**
		 * @private
		 */
		public function set iconWidthDefault(a:int):void
		{
			_iconWidthDefault = a;
		}
		
		/**
		 * This property defines the icon height.
		 * @default 500
		 */
		public function get iconHeightDefault():int
		{
			return _iconHeightDefault;
		}
		/**
		 * @private
		 */
		public function set iconHeightDefault(a:int):void
		{
			_iconHeightDefault = a;
		}
		
		/**
		 * This property defines the animation time based on seconds.
		 * @default 2
		 */
		public function get animationTime():Number
		{
			return _animationTime;
		}
		/**
		 * @private
		 */
		public function set animationTime(a:Number):void
		{
			_animationTime = a;
		}
		
		/**
		 * This property defines ratio of height to width.
		 * @default 2
		 */
		public function get ratioWHPhoto():Number
		{
			return _ratioWHPhoto;
		}
		/**
		 * @private
		 */
		public function set ratioWHPhoto(a:Number):void
		{
			_ratioWHPhoto = a;
		}
		
		/**
		 * This property defines the format of the textField in iconsHolder.
		 */
		public function get textFormat():TextFormat
		{
			return _textFormat;
		}
		/**
		 * @private
		 */
		public function set textFormat(a:TextFormat):void
		{
			_textFormat = a;
		}
		
		/**
		 * If any fonts are embeded in the app, this should be set to true.
		 * @default false
		 */
		public function get embedFont():Boolean
		{
			return _embedFont;
		}
		/**
		 * @private
		 */
		public function set embedFont(a:Boolean):void
		{
			_embedFont = a;
		}
		
		/**
		 * This property defines the icons' holder.
		 */
		public function get iconsHolder():*
		{
			return _iconsHolder;
		}
		/**
		 * @private
		 */
		public function set iconsHolder(a:*):void
		{
			if(a != _iconsHolder)
			{
				_iconsHolder = a;
			}
		}
		
		/**
		 * This property defines the iconsHolder & photosHolder's holder.
		 */
		public function get holder():*
		{
			return _stage;
		}
		/**
		 * @private
		 */
		public function set holder(a:*):void
		{
			if(a != _stage)
			{
				_stage = a;
			}
		}
		
		/**
		 * This property defines the photos' holder.
		 */
		public function get photosHolder():*
		{
			return _photosHolder;
		}
		/**
		 * @private
		 */
		public function set photosHolder(a:*):void
		{
			if(a != _photosHolder)
			{
				_photosHolder = a;
			}
		}
		
		public function set dpiScaleMultiplier(a:Number):void
		{
			_dpiScaleMultiplier = a;
		}
		
		/**
		 * This property defines kodam icon bala gharar darad.
		 */
		public function get isIconUp():Object
		{
			var i:int = 0;
			var lng:int = _itemArray.length;
			var _tetaMin:Number = 1000;
			var _up:int = 0;
			
			for (i = 0; i < lng; i++) 
			{
				if (_itemArray[i].teta >= 0 && _itemArray[i].teta < (Math.PI * 2) && _itemArray[i].teta < _tetaMin)
				{
					_up = i;
					_tetaMin = _itemArray[i].teta;
				}
				else if (_itemArray[i].teta < 0 && Math.abs(_itemArray[i].teta) < _tetaMin)
				{
					_up = i;
					_tetaMin = Math.abs(_itemArray[i].teta);
				}
				else if (_itemArray[i].teta > (Math.PI * 2) && (_itemArray[i].teta - Math.PI * 2) < _tetaMin)
				{
					_up = i;
					_tetaMin = _itemArray[i].teta - Math.PI * 2;
				}
			}
			
			var obj:Object = { };
			obj.name = _itemArray[_up].name;
			obj.id = _itemArray[_up].id;
			obj.info = _itemArray[_up].info;
			obj.index = _itemArray[_up].index;
			obj.imageOut = _itemArray[_up].imageOut;
			obj.imageOver = _itemArray[_up].imageOver;
			obj.imagePhoto = _itemArray[_up].imagePhoto;
			
			return obj;
		}
		
		/**
		 * This property defines kodam icon bala gharar begirad.
		 */
		public function set iconUpID(a:int):void
		{
			_iconUp = a;
		}
		
		public function get radius():Number
		{
			return _r;
		}
		
		public function get R():Number
		{
			return _R;
		}
	}
}