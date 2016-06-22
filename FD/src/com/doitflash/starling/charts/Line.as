package com.doitflash.starling.charts
{
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	
	import starling.display.Shape;
	import starling.events.Event;
	
	import com.doitflash.starling.MyStarlingSprite;
	import com.doitflash.starling.TextArea;
	import com.adobe.serialization.json.JSON;
	
	public class Line extends MyStarlingSprite
	{
		public var bundleConfig:Array;
		public var embedFonts:Boolean = false;
		public var axis_x:Axis = new Axis(Type.LINE);
		public var axis_y:Axis = new Axis(Type.LINE);
		private var axis:MyStarlingSprite;
		
		private var _xPositions:Array;
		private var _yPositions:Array;
		private var _distanceDotsX:Number;
		private var _distanceDotsY:Number;
		
		private var _plate:Sprite // all plates will be kept inside this plate
		private var _plateRef:Array; // refrence to all the plates are kept inside this array
		
		public var infoWindow:*;
		
		public function Line():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_margin = 0;
		}
		
		private function stageRemoved(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
		}
		
		private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			if (_data is String)
			{
				_data = jsonDecode(String(_data));
			}
			
			_data.marginL = 65;
			_data.marginT = 10;
			_data.marginR = 10;
			_data.marginB = 20;
			//this.drawBg(1, 0xEEEEEE, 0);
			
			_xPositions = [];
			_yPositions = [];
			_plateRef = [];
			
			drawAxis();
			setPoints();
			connectPoints();
		}
		
// --------------------------------------------------------------------------------------------- private

		private function drawAxis():void
		{
			axis = new MyStarlingSprite();
			
			
			var point1X:Point = new Point(_data.marginL, _height - _data.marginB);
			var point2X:Point = new Point(_width - _data.marginR, _height - _data.marginB);
			var point3X:Point = new Point(_width - _data.marginR - 30, _height - _data.marginB);
			var distanceX:Number = Point.distance(point1X, point3X);
			
			var shapeX:Shape = new Shape();
			shapeX.graphics.lineStyle(2, 0x000000, 1);
			shapeX.graphics.moveTo(point1X.x, point1X.y);
			shapeX.graphics.lineTo(point2X.x, point2X.y);
			
			var i:int;
			
			// calculate number of dots on the axis
			var countX:int = Math.ceil((axis_x.end - axis_x.start) / axis_x.period);
			
			// calculate pixel distance between each dot on axis
			_distanceDotsX = distanceX / countX;
			
			var curX:Number;
			var curHintX:String;
			var labelNum:Number = 0;
			var labelNumEnd:Number = 0;
			
			for (i = 0; i < countX; i++) 
			{
				curX = (i * _distanceDotsX) + _data.marginL + _distanceDotsX / 2;
				shapeX.graphics.moveTo(curX, point1X.y);
				shapeX.graphics.lineTo(curX, point1X.y + 3);
				
				// save this x position
				_xPositions.push(curX - _data.marginL);
				
				labelNum = axis_x.start + axis_x.period * i;
				labelNumEnd = labelNum + axis_x.period;
				
				if (labelNumEnd <= axis_x.end)
				{
					switch (axis_x.period) 
					{
						case 1:
							curHintX = String("D " + (labelNum + 1));
						break;
						case 7:
							curHintX = String("W " + (labelNum / 7 + 1));
						break;
						case 30:
							curHintX = String("M " + (labelNum / 30 + 1));
						break;
						case 60:
							curHintX = String("M " + (labelNum / 30 + 1) + "-" + (labelNumEnd / 30));
						break;
						case 90:
							curHintX = String("S " + (labelNum / 90 + 1));
						break;
						case 180:
							curHintX = String("M " + (labelNum / 30 + 1) + "-" + (labelNumEnd / 30));
						break;
						case 365:
							curHintX = String("Y " + (labelNum / 365 + 1));
						break;
						default:
							curHintX = String("D " + (labelNum + 1) + "-" + (labelNumEnd));
					}
				}
				else if ((labelNum + 1) == axis_x.end)
				{
					switch (axis_x.period) 
					{
						case 7:
							curHintX = String("D 1");
						break;
						case 30:
							curHintX = String("D 1");
						break;
						case 60:
							curHintX = String("D 1");
						break;
						case 90:
							curHintX = String("D 1");
						break;
						case 180:
							curHintX = String("D 1");
						break;
						case 365:
							curHintX = String("D 1");
						break;
						default:
							curHintX = String("D " + (labelNum + 1));
					}
				}
				else
				{
					switch (axis_x.period) 
					{
						case 1:
							curHintX = String("D " + (labelNum + 1));
						break;
						case 7:
							curHintX = String("D 1" + "-" + (axis_x.end - labelNum));
						break;
						case 30:
							curHintX = String("D 1" + "-" + (axis_x.end - labelNum));
						break;
						case 60:
							curHintX = String("D 1" + "-" + (axis_x.end - labelNum));
						break;
						case 90:
							curHintX = String("D 1" + "-" + (axis_x.end - labelNum));
						break;
						case 180:
							curHintX = String("D 1" + "-" + (axis_x.end - labelNum));
						break;
						case 365:
							curHintX = String("D 1" + "-" + (axis_x.end - labelNum));
						break;
						default:
							curHintX = String("D " + (labelNum + 1) + "-" + (axis_x.end));
					}
				}
				
				
				
				//curHintX = String(axis_x.start + axis_x.period + axis_x.period * i);
				var hintX:TextArea = getText(axis_x.prefix + curHintX + axis_x.suffix);
				hintX.x = curX - hintX.txt.width / 2;
				hintX.y = point1X.y + 5;
				shapeX.addChild(hintX);
			}
			
			var nameX:TextArea = new TextArea();
			nameX.txt.autoSize = TextFieldAutoSize.LEFT;
			nameX.txt.antiAliasType = AntiAliasType.ADVANCED;
			nameX.txt.mouseEnabled = false;
			nameX.txt.embedFonts = embedFonts;
			nameX.txt.htmlText = axis_x.name;
			nameX.refresh();
			nameX.x = _width - nameX.width - _data.marginR;
			nameX.y = _height - nameX.height;
			shapeX.addChild(nameX);
			
			axis.addChild(shapeX);
			axis.width = shapeX.width + _data.marginL + _data.marginR;
			
			// -----------------------------------------------------------
			var point1Y:Point = new Point(_data.marginL, 2 * _data.marginT);
			var point2Y:Point = new Point(_data.marginL, _height - _data.marginB);
			var distanceY:Number = Point.distance(point1Y, point2Y);
			
			var shapeY:Shape = new Shape();
			shapeY.graphics.lineStyle(2, 0x000000, 1);
			shapeY.graphics.moveTo(point1Y.x, point1Y.y);
			shapeY.graphics.lineTo(point2Y.x, point2Y.y);
			
			// calculate number of dots on the axis
			var countY:int = (axis_y.max - axis_y.min) / axis_y.period;
			//var countY:int = (axis_y.end - axis_y.start) / axis_y.period;
			
			// calculate pixel distance between each dot on axis
			_distanceDotsY = distanceY / countY;
			
			var curY:Number;
			var curHintY:String;
			for (i = 0; i < countY; i++) 
			{
				curY = (i * _distanceDotsY) + 2 * _data.marginT;
				shapeY.graphics.moveTo(point1Y.x, curY);
				shapeY.graphics.lineTo(point1Y.x - 3, curY);
				
				// save this y position
				_yPositions.push(curY - _data.marginT);
				
				curHintY = String(axis_y.max - axis_y.period * i);
				//curHintY = String(axis_y.end - axis_y.period * i);
				var hintY:TextArea = getText(axis_y.prefix + curHintY + axis_y.suffix);
				hintY.x = point1Y.x - 5 - hintY.txt.width;
				hintY.y = curY - hintY.height / 2;
				shapeY.addChild(hintY);
			}
			
			var nameY:TextArea = new TextArea();
			nameY.txt.autoSize = TextFieldAutoSize.LEFT;
			nameY.txt.antiAliasType = AntiAliasType.ADVANCED;
			nameY.txt.mouseEnabled = false;
			nameY.txt.embedFonts = embedFonts;
			nameY.txt.htmlText = axis_y.name;
			nameY.refresh();
			nameY.rotation = deg2rad(270);
			nameY.x = _data.marginL;
			nameY.y = _data.marginT + nameY.width;
			shapeY.addChild(nameY);
			
			axis.addChild(shapeY);
			axis.height = shapeY.height + _data.marginT + _data.marginB;
			
			//axis.drawBg(0.3, 0x990000, 1, 0x000000, 10);
			this.addChild(axis);
		}

		private function setPoints():void
		{
			_plate = new Sprite();
			_plate.addEventListener(TouchEvent.TOUCH, onTouch);
			_plate.x = _data.marginL;
			_plate.y = _data.marginT;
			this.addChild(_plate);
			
			var bundle:Array;
			var node:Object;
			var i:int;
			for (i = 0; i < _data.data.length; i++) 
			{
				bundle = _data.data[i];
				
				// create required plates for the first time
				if (_plate.numChildren == 0)
				{
					for (var k:int = 0; k < bundle.length; k++) 
					{
						var plate:MyStarlingSprite = new MyStarlingSprite();
						plate.id = k;
						plate.width = axis.width - (_data.marginL + _data.marginR);
						plate.height = axis.height - (_data.marginT + _data.marginB);
						_plateRef.push(plate);
						_plate.addChild(plate);
						
						//plate.drawBg(0.3, 0x990000, 0, 0x000000, 1);
					}
				}
				
				for (var j:int = 0; j < bundle.length; j++) 
				{
					node = bundle[j];
					toMarkThePlate(MyStarlingSprite(_plate.getChildAt(j)), new Point(node.x, node.y), i, node.data, bundleConfig[j]);
				}
			}
			//trace(_data.data.length, _xPositions.length) // must be equal
		}
		
		private function toMarkThePlate($plate:MyStarlingSprite, $nodePoint:Point, $bundle:int, $nodeData:Object, $config:Object):void
		{
			var axisHeight:Number = axis_y.max - axis_y.min;
			//var axisHeight:Number = axis_y.end - axis_y.start;
			var curPercY:Number = $nodePoint.y / axisHeight;
			var currYposition:Number = $plate.height - ($plate.height * curPercY);// + _distanceDotsY / 2;
			currYposition = Math.min(currYposition, $plate.height);
			if (currYposition == $plate.height) currYposition++;
			
			if (!$plate.data.pixelMarkedPoints) $plate.data.pixelMarkedPoints = [];
			$plate.data.pixelMarkedPoints.push(new Point(_xPositions[$bundle], currYposition));
			
			if (!$plate.data.pointData) $plate.data.pointData = [];
			$plate.data.pointData.push($nodeData);
			
			if(!$plate.data.shapeFill) $plate.data.shapeFill = new Shape();
			if(!$plate.data.shapePoint) $plate.data.shapePoint = new Shape();
			$plate.data.shapePoint.graphics.beginFill($config.pointColor, $config.pointAlpha);
			$plate.data.shapePoint.graphics.drawCircle(_xPositions[$bundle], currYposition, $config.pointRadius);
			$plate.data.shapePoint.graphics.endFill();
			
			$plate.addChild($plate.data.shapeFill);
			$plate.addChild($plate.data.shapePoint);
		}
		
		private function connectPoints():void
		{
			var numPlates:int = _plate.numChildren;
			var currPlate:MyStarlingSprite;
			var pointsToJoinLength:int
			for (var i:int = 0; i < numPlates; i++) 
			{
				currPlate = MyStarlingSprite(_plate.getChildAt(i));
				pointsToJoinLength = currPlate.data.pixelMarkedPoints.length;
				
				var s:Shape = currPlate.data.shapeFill;
				s.graphics.beginFill(bundleConfig[i].fillColor, bundleConfig[i].fillAlpha);
				s.graphics.lineStyle(bundleConfig[i].lineThickness, bundleConfig[i].lineColor, bundleConfig[i].lineAlpha);
				s.graphics.moveTo(currPlate.data.pixelMarkedPoints[0].x, currPlate.height);
				
				for (var j:int = 0; j < pointsToJoinLength; j++) 
				{
					s.graphics.lineTo(currPlate.data.pixelMarkedPoints[j].x, currPlate.data.pixelMarkedPoints[j].y);
				}
				
				s.graphics.lineTo(currPlate.data.pixelMarkedPoints[pointsToJoinLength-1].x, currPlate.height);
				s.graphics.endFill();
			}
		}
		
// --------------------------------------------------------------------------------------------- helpful

		private function getText($str:String):TextArea
		{
			var txt:TextArea = new TextArea();
			txt.txt.autoSize = TextFieldAutoSize.LEFT;
			txt.txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.txt.mouseEnabled = false;
			txt.txt.embedFonts = embedFonts;
			//txt.txt.border = true;
			txt.txt.htmlText = $str;
			txt.refresh();
			//txt.rotation = deg2rad(270);
			
			return txt;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			var touchPos:Point;
			var plate:MyStarlingSprite = e.target["parent"]["parent"] as MyStarlingSprite;
			var points:Array;
			
			var pointA:Point;
			var pointB:Point;
			var pointTarget:Point;
			var targetData:Object;
			
			var distanceA:Number;
			var distanceB:Number;
			
			if (infoWindow)
			{
				infoWindow.removeFromParent();
			}
			
			if (plate && touch.phase == TouchPhase.ENDED)
			{
				var i:int;
				touchPos = touch.getLocation(plate);
				points = plate.data.pixelMarkedPoints;
				for (i = 0; i < points.length; i++) 
				{
					if (points[i].x >= touchPos.x)
					{
						pointA = points[i];
						
						if (i > 0) pointB = points[i - 1];
						else pointB = pointA;
						
						break;
					}
				}
				
				// check distance between the touch point and pointA & pointB
				distanceA = Point.distance(touchPos, pointA);
				distanceB = Point.distance(touchPos, pointB);
				
				if (distanceA < distanceB) pointTarget = pointA;
				else if (distanceA > distanceB) pointTarget = pointB;
				else pointTarget = pointA;
				
				// find the target in the found point
				for (i = 0; i < points.length; i++) 
				{
					if (points[i].x == pointTarget.x)
					{
						targetData = plate.data.pointData[i];
					}
				}
				
				
				
				if (infoWindow)
				{
					infoWindow.x = _data.marginL + pointTarget.x - infoWindow.width;
					infoWindow.y = _data.marginT + pointTarget.y - infoWindow.height;
					if (infoWindow.x < 0) infoWindow.x = 0;
					if (infoWindow.y < 0) infoWindow.y = 0;
					
					infoWindow.update(targetData);
					addChild(infoWindow);
				}
			}
		}

// --------------------------------------------------------------------------------------------- Methods

		public function jsonDecode($json:String):*
		{
			return com.adobe.serialization.json.JSON.decode($json);
		}
		
		public function jsonEncode($obj:Object):String
		{
			return com.adobe.serialization.json.JSON.encode($obj);
		}
		
		public function showPlate($plateId:int, $status:Boolean):void
		{
			var currPlate:MyStarlingSprite;
			for (var i:int = 0; i < _plate.numChildren; i++) 
			{
				currPlate = _plate.getChildAt(i) as MyStarlingSprite;
				if (currPlate.id == $plateId)
				{
					currPlate.visible = $status;
					_plate.setChildIndex(currPlate, _plate.numChildren);
					return;
				}
			}
		}

// --------------------------------------------------------------------------------------------- getter - setter
	}
}