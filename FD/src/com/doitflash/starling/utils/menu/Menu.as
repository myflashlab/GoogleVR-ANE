package com.doitflash.starling.utils.menu
{
	import flash.events.EventDispatcher
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import com.greensock.plugins.*;
	import com.greensock.*; 
	import com.greensock.events.*;
	import com.greensock.easing.*;
	//import com.greensock.easing.EaseLookup;
	
	
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.starling.utils.scroller.Scroller;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Easing;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.events.ListEvent;
	
	import flash.geom.Point;
	
	/**
	 * Menu is an abstract class that lets you to simply have a drop-down menu specially in 3D environment and Starling projects.
	 * 
	 * <b>Copyright 2012-2013, MyAppSnippet. All rights reserved.</b>
	 * For seeing the menu preview and sample files visit <a href="http://myappsnippet.com/">http://www.myappsnippet.com/</a>
	 * 
	 * @see com.doitflash.events.MenuEvent
	 * @see com.doitflash.consts.Orientation
	 * 
	 * @author Ali Tavakoli - 6/3/2013 12:39 PM
	 * modified - 6/3/2013 12:39 PM
	 * @version 1.0
	 * 
	 * @example The following example shows you how to create a simple Drop-down menu and make it work on your project.
	 * 
	 * <listing version="3.0">
	 * 
	 * 
	 * 
	 * </listing>
	 */
	public class Menu extends EventDispatcher
	{
// ----------------------------------------------------------------------------------------------------------------------- vars
		
		/**
		 * @private
		 * set the object to save the setters value inside it self
		 */
		protected var _propSaver:Object = new Object();
		
		// input vars
		private var _btn:*;
		private var _head:*;
		private var _body:*;
		private var _stage:*;
		private var _objType:Class = Sprite;
		private var _ctrlActive:Boolean = false;
		private var _maxSelected:int = 0;
		private var _selectType:String;
		
		// needed vars
		private var _scroller:Scroller;
		private var _list:List;
		private var _itemHolder:Sprite;
		private var _rectBody:Rectangle;
		private var _mask:Sprite;
		
		private var _selectedItems:Array = [];
		
		private var _selected:Boolean = false;
		private var _ctrlDown:Boolean = false;
		
		
		// consts
		public static const MONO_SELECT:String = "monoSelect";
		public static const MULTI_SELECT:String = "multiSelect";
		
// ----------------------------------------------------------------------------------------------------------------------- constructor func
		
		public function Menu():void
		{
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		
		
// ----------------------------------------------------------------------------------------------------------------------- Methods
		
		/**
		 * when you're done with the class, call this method to distroy everything and free up the memory
		 */
		public function dispose():void
		{
			_selectedItems.splice(0);
			_selectedItems = null;
		}
		
		
		public function open():void
		{
			// if body is ok, then it will be visible (because user may not want to show body when open is called, like to show something else by using the open dispatch)
			// in body we list the items
			dispatchEvent(new MenuEvent(MenuEvent.OPEN));
			
			if (!_body) return;
			
			if (!_list) initList();
			else _list.holder = _body;
			
			if (!_scroller) initScroller();
			
			if (_ctrlActive && _stage) _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			_body.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_body.visible = true;
			
			//btn switches body visible and invisble
			//if (_btn)
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.ctrlKey)
			{
				_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				_ctrlDown = true;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (!e.ctrlKey)
			{
				_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				_ctrlDown = false;
			}
		}
		
		public function close():void
		{
			// if body is ok, then it will be invisible
			dispatchEvent(new MenuEvent(MenuEvent.CLOSE, _selectedItems));
			
			if (!_body) return;
			
			if (_ctrlActive && _stage) _stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			_body.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_body.visible = false;
		}
		
		private function initList():void
		{
			_itemHolder = new _objType();
			_list = new List();
			if (_body) _list.holder = _body; // if body is ok,(because user may not want to show body)
			_list.itemsHolder = _itemHolder;
			_list.itemsHolder.addEventListener(MouseEvent.CLICK, onClickList);
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.orientation = Orientation.VERTICAL; // HORIZONTAL, VERTICAL
			_list.row = 1;
			
			_list.space = 5;
			_list.spaceX = 0;
			_list.spaceY = 0;
			_list.reverseAddChild = false;
			_list.compactArrange = true;
		}
		
		private function onClickList(e:MouseEvent):void
		{
			if (!_scroller.isHoldAreaDone)
			{
				var i:int = 0;
				
				switch (_selectType) 
				{
					case MONO_SELECT:
						
						var lng6:int = _selectedItems.length;
						if (lng6 > 0)
						{
							for (i = 0; i < lng6; i++) 
							{
								dispatchEvent(new MenuEvent(MenuEvent.ITEM_UNSELECTED, _selectedItems[i]));
							}
							
							_selectedItems.splice(0);
						}
						
						_selectedItems.push(e.target);
						dispatchEvent(new MenuEvent(MenuEvent.ITEM_SELECTED, e.target));
						
					break;
					case MULTI_SELECT:
						
						if (_ctrlActive)
						{
							if (_ctrlDown)
							{
								_selected = false;
								
								var lng1:int = _selectedItems.length;
								
								for (i = 0; i < lng1; i++) // let's check the arr to see if the item is already selected
								{
									if (e.target == _selectedItems[i])
									{
										_selected = true;
										_selectedItems.splice(i, 1);
									}
								}
								
								if (_selected)
								{
									dispatchEvent(new MenuEvent(MenuEvent.ITEM_UNSELECTED, e.target));
								}
								else
								{
									_selectedItems.push(e.target);
									dispatchEvent(new MenuEvent(MenuEvent.ITEM_SELECTED, e.target));
								}
								
								if (_maxSelected > 0)
								{
									var lng4:int = _selectedItems.length;
									
									if (lng4 > _maxSelected)
									{
										for (i = 0; i < (lng4 - _maxSelected); i++) 
										{
											dispatchEvent(new MenuEvent(MenuEvent.ITEM_UNSELECTED, _selectedItems[0]));
											_selectedItems.splice(0, 1);
										}
										
									}
								}
							}
							else
							{
								var lng2:int = _selectedItems.length;
								
								for (i = 0; i < lng2; i++) 
								{
									dispatchEvent(new MenuEvent(MenuEvent.ITEM_UNSELECTED, _selectedItems[i]));
								}
								
								_selectedItems.splice(0);
								_selectedItems.push(e.target);
								dispatchEvent(new MenuEvent(MenuEvent.ITEM_SELECTED, e.target));
							}
						}
						else
						{
							_selected = false;
							
							var lng3:int = _selectedItems.length;
							
							for (i = 0; i < lng3; i++) 
							{
								if (e.target == _selectedItems[i])
								{
									_selected = true;
									_selectedItems.splice(i, 1);
								}
							}
							
							if (_selected)
							{
								dispatchEvent(new MenuEvent(MenuEvent.ITEM_UNSELECTED, e.target));
							}
							else
							{
								_selectedItems.push(e.target);
								dispatchEvent(new MenuEvent(MenuEvent.ITEM_SELECTED, e.target));
							}
							
							if (_maxSelected > 0)
							{
								var lng5:int = _selectedItems.length;
								
								if (lng5 > _maxSelected)
								{
									for (i = 0; i < (lng5 - _maxSelected); i++) 
									{
										dispatchEvent(new MenuEvent(MenuEvent.ITEM_UNSELECTED, _selectedItems[0]));
										_selectedItems.splice(0, 1);
									}
									
								}
							}
						}
						
					break;
					default:
				}
			}
		}
		
		private function initScroller():void
		{
			_scroller = new Scroller();
			
			_scroller.boundWidth = _body.width;
			_scroller.boundHeight = _body.height;
			_scroller.content = _itemHolder;
			_scroller.orientation = Orientation.VERTICAL;
			_scroller.easeType = Easing.Expo_easeOut;
			_scroller.duration = .5;
			_scroller.holdArea = 10;
			_scroller.isStickTouch = false;
		}
		
		private function workOnBody():void
		{
			_rectBody = new Rectangle(_body.x, _body.y, _body.width, _body.height);
			
			_mask = new _objType();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, (_body.width + 1), (_body.height + 1));
			_mask.graphics.endFill();
			_mask.x = _body.x;
			_mask.y = _body.y;
			
			_body.mask = _mask;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_body.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			var posGlobal:Point = new Point(e.stageX, e.stageY);
			var containBoolean:Boolean = _rectBody.contains(posGlobal.x, posGlobal.y); // to see if the user has touched the body area or not
			
			if (_scroller && containBoolean)
			{
				_scroller.startScroll(posGlobal); // on touch begin
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var posGlobal:Point = new Point(e.stageX, e.stageY);
			
			if (_scroller)
			{
				_scroller.startScroll(posGlobal); // on touch move
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_body.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			var posGlobal:Point = new Point(e.stageX, e.stageY);
			
			if (_scroller)
			{
				_scroller.fling(); // on touch ended
			}
		}
		
		public function add($item:*, $index:Number = NaN):void
		{
			// when we add, items will be added in the list
			if (!_list) initList();
			_list.add($item, $index);
			dispatchEvent(new MenuEvent(MenuEvent.ITEM_ADDED, $item));
			_list.itemArrange();
			
			// then we add a listener to holder to get which item is active and selected and dispach it
			// by holding Ctrl key, user can select multiple items
			
			// selected items will be added to the _slecetedItems array
			
			// list will be inside the Scroller
		}
		
		public function remove($item:*):void
		{
			if (!_list) return
			_list.remove($item);
			dispatchEvent(new MenuEvent(MenuEvent.ITEM_REMOVED, $item));
			_list.itemArrange();
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Properties
		
		
		public function get list():List
		{
			return _list;
		}
		
		public function get scroller():Scroller
		{
			return _scroller;
		}
		
		public function get selectedItems():Array
		{
			return _selectedItems;
		}
		
		public function set selectedItems(a:Array):void
		{
			_selectedItems = a;
		}
		
		public function set body(a:*):void
		{
			_body = a;
			workOnBody();
		}
		
		public function get body():*
		{
			return _body;
		}
		
		public function set btn(a:*):void
		{
			_btn = a;
		}
		
		public function get btn():*
		{
			return _btn;
		}
		
		public function set head(a:*):void
		{
			_head = a;
		}
		
		public function get head():*
		{
			return _head;
		}
		
		public function set stage(a:*):void
		{
			_stage = a;
		}
		
		public function get stage():*
		{
			return _stage;
		}
		
		public function set ctrlActive(a:Boolean):void
		{
			_ctrlActive = a;
		}
		
		public function get ctrlActive():Boolean
		{
			return _ctrlActive;
		}
		
		public function set selectType(a:String):void
		{
			_selectType = a;
		}
		
		public function get selectType():String
		{
			return _selectType;
		}
		
		public function set maxSelected(a:int):void
		{
			_maxSelected = a;
		}
		
		public function get maxSelected():int
		{
			return _maxSelected;
		}
		
		public function set objType(a:Class):void
		{
			_objType = a;
		}
		
		public function get objType():Class
		{
			return _objType;
		}
		
		
		/**
		 * export the class and send the Object that holds all of the setters values.
		 */
		public function get exportProp():Object
		{
			return _propSaver;
		}
		/**
		 * import the class and get the Object that holds all of the setters values.
		 */
		public function set importProp(a:Object):void
		{
			for (var prop:* in a)
			{
				this[prop] = a[prop];
			}
		}
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}