package com.doitflash.starling.charts
{
	import com.doitflash.starling.MyStarlingSprite;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class ChartBundles extends MyStarlingSprite
	{
		private var _chart:Line; 
		private var _body:Sprite;
		private var _itemArray:Array = [];
		
		public function ChartBundles():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
		}
		
		private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			
			//this.drawBg(1, 0xEEEEEE, 0);
			
			_body = new Sprite();
			
			this.addChild(_body);
			
			initItems();
			
			_body.x = _margin;
			_body.y = _height - _body.height >> 1;
			
			if(_data.length > 1) this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
// --------------------------------------------------------------------------------------------- private

		private function initItems():void
		{
			for (var i:int = 0; i < _data.length; i++) 
			{
				var item:ItemBundle = new ItemBundle();
				item.id = i;
				item.data = _data[i];
				item.width = _width - _margin * 2;
				item.height = 35;
				item.y = i * (item.height + 2);
				_itemArray.push(item);
				_body.addChild(item);
			}
		}
	
// --------------------------------------------------------------------------------------------- helpful

		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			var item:* = e.target["parent"]["parent"];
			
			try 
			{
				if (item is ItemBundle)
				{
					if (touch.phase == TouchPhase.ENDED)
					{
						item.checkbox.pick(!item.checkbox.isSelected);
						_chart.showPlate(item.id, item.checkbox.isSelected);
					}
				}
			}
			catch (err:Error) { };
		}

// --------------------------------------------------------------------------------------------- Methods

		

// --------------------------------------------------------------------------------------------- getter - setter

		public function set chart(a:Line):void
		{
			_chart = a;
		}
		
		public function get itemArray():Array
		{
			return _itemArray;
		}
	}
}

	import com.doitflash.starling.MyStarlingSprite; 
	import com.doitflash.starling.TextArea;
	
	import starling.events.Event;
	
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	internal class ItemBundle extends MyStarlingSprite
	{
		private var _txt:TextArea;
		
		private var _checkBox:CheckBox;
		
		public function ItemBundle():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
		}
		
		private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//this.drawBg(0.05, 0x555555, 0);
			
			initCheckBox();
			initTxt();
		}
		
		private function initCheckBox():void
		{
			_checkBox = new CheckBox(true);
			_checkBox.color = _data.color;
			_checkBox.width = _checkBox.height = _height;
			this.addChild(_checkBox);
		}
		
		private function initTxt():void
		{
			_txt = new TextArea();
			_txt.txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.txt.mouseEnabled = false;
			_txt.txt.embedFonts = false;
			//_txt.txt.border = true;
			_txt.txt.multiline = true;
			_txt.txt.wordWrap = true;
			_txt.txt.htmlText = _data.name;
			_txt.x = _checkBox.x + _checkBox.width + 10;
			_txt.txt.width = _width - _txt.x;
			_txt.y = _height - _txt.txt.height >> 1;
			_txt.refresh();
			this.addChild(_txt);
		}
		
		public function get checkbox():CheckBox
		{
			return _checkBox;
		}
	}
	
	import com.doitflash.starling.MyStarlingSprite;
	import com.doitflash.starling.MySprite;
	import starling.display.Image;
	import starling.events.Event;
	
	internal class CheckBox extends MyStarlingSprite
	{
		public var color:uint;
		private var _isSelected:Boolean;
		
		private var _selectedImage:Image;
		private var _notSelectedImage:Image;
		
		public function CheckBox($defaultValue:Boolean):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			_isSelected = $defaultValue;
		}
		
		private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			createImages();
			
			pick(_isSelected);
			
		}
		
		private function createImages():void
		{
			var sp:MySprite = new MySprite();
			sp.width = _width;
			sp.height = _height;
			sp.bgAlpha = 0.7;
			sp.bgColor = color;
			sp.bgStrokeAlpha = 1;
			sp.bgStrokeColor = color;
			sp.bgStrokeThickness = 5;
			sp.drawBg();
			_selectedImage = new Image(sp.getTexture());
			
			var sp2:MySprite = new MySprite();
			sp2.width = _width;
			sp2.height = _height;
			sp2.bgAlpha = 0;
			sp2.bgColor = color;
			sp2.bgStrokeAlpha = 1;
			sp2.bgStrokeColor = color;
			sp2.bgStrokeThickness = 5;
			sp2.drawBg();
			_notSelectedImage = new Image(sp2.getTexture());
		}
		
		public function pick($status:Boolean):void
		{
			_isSelected = $status;
			
			_selectedImage.removeFromParent();
			_notSelectedImage.removeFromParent();
			
			if (_isSelected) this.addChild(_selectedImage);
			else this.addChild(_notSelectedImage);
		}
		
		public function set isSelected(a:Boolean):void
		{
			_isSelected = a;
		}
		
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
	}