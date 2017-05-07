package 
{
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.text.modules.MySprite;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import com.myflashlab.air.extensions.googleVR.*;
	import com.myflashlab.air.extensions.nativePermissions.PermissionCheck;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/22/2016 9:22 AM
	 */
	public class Demo extends Sprite 
	{
		private var _exPermissions:PermissionCheck = new PermissionCheck();
		
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		public function Demo():void 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 20;
			C.width = 250;
			C.height = 150;
			C.strongRef = true;
			C.visible = true;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Google VR ANE V"+VR.VERSION+"</font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			checkPermissions();
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleDeactivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				e.preventDefault();
				NativeApplication.nativeApplication.exit();
            }
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
		}
		
		private function checkPermissions():void
		{
			// first you need to make sure you have access to the Strorage if you are on Android?
			// use the PermissionCheck ANE for this reason: 
			// http://www.myflashlabs.com/product/native-access-permission-check-settings-menu-air-native-extension/
			var permissionState:int = _exPermissions.check(PermissionCheck.SOURCE_STORAGE);
			
			if (permissionState == PermissionCheck.PERMISSION_UNKNOWN || permissionState == PermissionCheck.PERMISSION_DENIED)
			{
				_exPermissions.request(PermissionCheck.SOURCE_STORAGE, onRequestResult);
			}
			else
			{
				init();
			}
			
			function onRequestResult($state:int):void
			{
				if ($state != PermissionCheck.PERMISSION_GRANTED)
				{
					C.log("You did not allow the app the required permissions!");
				}
				else
				{
					init();
				}
			}
		}
		
		private function init():void
		{
			VR.init();
			
			// add general VR listeners
			VR.api.addEventListener(VREvents.VR_CLOSED, onVRClosed);
			VR.api.addEventListener(VREvents.DID_TAP, onVRTapped);
			VR.api.addEventListener(VREvents.DISPLAY_MODE_CHANGED, onVRModeChanged);
			
			//----------------------------------------------------------------------
			var btn0:MySprite = createBtn("start image 360");
			btn0.addEventListener(MouseEvent.CLICK, startImg360);
			_list.add(btn0);
			
			function startImg360(e:MouseEvent):void
			{
				C.log("launching a 360 image view...");
				
				var srcImg360:File = File.applicationDirectory.resolvePath("360Img.jpg");
				//var dis:File = File.applicationStorageDirectory.resolvePath(srcImg360.name);
				//var dis:File = File.documentsDirectory.resolvePath(srcImg360.name);
				//if (dis.exists) dis.deleteFile();
				//srcImg360.copyTo(dis, true);
				
				var srcExitBtn:File = File.applicationDirectory.resolvePath("exit.png");
				//var dis:File = File.applicationStorageDirectory.resolvePath(srcExitBtn.name);
				//var dis:File = File.documentsDirectory.resolvePath(srcExitBtn.name);
				//if (dis.exists) dis.deleteFile();
				//srcExitBtn.copyTo(dis, true);
				
				var vrSetting:VRConfigImg = new VRConfigImg();
				vrSetting.btnExit = srcExitBtn;
				vrSetting.image360 = srcImg360;
				vrSetting.imageType = VRConfig.TYPE_STEREO_OVER_UNDER;
				vrSetting.stereoModeButtonEnabled = true;
				vrSetting.infoButtonEnabled = false;
				vrSetting.touchTrackingEnabled = true;
				
				VR.api.imageView.addEventListener(VREvents.LOAD_FAILED, onLoadFailed);
				VR.api.imageView.addEventListener(VREvents.LOAD_SUCCESS, onLoadSuccess);
				VR.api.imageView.attach(vrSetting);
			}
			
			function onLoadFailed(e:VREvents):void
			{
				VR.api.imageView.removeEventListener(VREvents.LOAD_FAILED, onLoadFailed);
				VR.api.imageView.removeEventListener(VREvents.LOAD_SUCCESS, onLoadSuccess);
				
				trace("onLoadFailed: " + e.msg);
			}
			
			function onLoadSuccess(e:VREvents):void
			{
				VR.api.imageView.removeEventListener(VREvents.LOAD_FAILED, onLoadFailed);
				VR.api.imageView.removeEventListener(VREvents.LOAD_SUCCESS, onLoadSuccess);
				
				trace("onLoadSuccess");
			}
			//----------------------------------------------------------------------
			
			var btn1:MySprite = createBtn("start video 360");
			btn1.addEventListener(MouseEvent.CLICK, startVid360);
			_list.add(btn1);
			
			function startVid360(e:MouseEvent):void
			{
				VR.api.videoView.removeEventListener(VREvents.LOAD_FAILED, 	onVideoLoadFailed);
				VR.api.videoView.removeEventListener(VREvents.LOAD_SUCCESS, onVideoLoadSuccess);
				
				VR.api.videoView.removeEventListener(VREvents.PAUSED, 		onVideoPaused);
				VR.api.videoView.removeEventListener(VREvents.REACHED_END, 	onVideoReachedEnd);
				VR.api.videoView.removeEventListener(VREvents.RESUMED, 		onVideoResumed);
				VR.api.videoView.removeEventListener(VREvents.STOPPED, 		onVideoStopped);
				VR.api.videoView.removeEventListener(VREvents.POS_UPDATED, 	onVideoPositionUpdated);
				
				C.log("launching a 360 Video view...");
				trace("On older Android devices you may see your AIR content all black when you return from the 360 video view");
				trace("This is an old bug in AIR and we hope Adobe would find the reason and hopefully fix it someday.");
				trace("In the meanwhile, read this to fix the problem: http://forum.starling-framework.org/topic/ane-fix-for-blackblank-screen-bug-when-returning-to-air-android-apps");
				
				var srcVid360:File = File.applicationDirectory.resolvePath("360Vid.mp4");
				var srcExitBtn:File = File.applicationDirectory.resolvePath("exit.png");
				
				var vrSetting:VRConfigVid = new VRConfigVid();
				vrSetting.btnExit = srcExitBtn;
				vrSetting.video360 = srcVid360;
				//vrSetting.video360URL = "http://192.168.0.11/project/products/MyFlashLab_ANEs/googleVR/Vx.x.x/FD/bin/360Vid.mp4";
				vrSetting.videoType = VRConfig.TYPE_STEREO_OVER_UNDER;
				vrSetting.stereoModeButtonEnabled = true;
				vrSetting.infoButtonEnabled = false;
				vrSetting.touchTrackingEnabled = true;
				vrSetting.fullscreenButtonEnabled = true;
				
				VR.api.videoView.addEventListener(VREvents.LOAD_FAILED, 	onVideoLoadFailed);
				VR.api.videoView.addEventListener(VREvents.LOAD_SUCCESS, 	onVideoLoadSuccess);
				
				VR.api.videoView.addEventListener(VREvents.PAUSED, 			onVideoPaused);
				VR.api.videoView.addEventListener(VREvents.REACHED_END, 	onVideoReachedEnd);
				VR.api.videoView.addEventListener(VREvents.RESUMED, 		onVideoResumed);
				VR.api.videoView.addEventListener(VREvents.STOPPED, 		onVideoStopped);
				VR.api.videoView.addEventListener(VREvents.POS_UPDATED, 	onVideoPositionUpdated);
				
				VR.api.videoView.attach(vrSetting);
			}
			
			function onVideoLoadFailed(e:VREvents):void
			{
				VR.api.videoView.removeEventListener(VREvents.LOAD_FAILED, onVideoLoadFailed);
				VR.api.videoView.removeEventListener(VREvents.LOAD_SUCCESS, onVideoLoadSuccess);
				
				trace("onVideoLoadFailed: " + e.msg);
			}
			
			function onVideoLoadSuccess(e:VREvents):void
			{
				VR.api.videoView.removeEventListener(VREvents.LOAD_FAILED, onVideoLoadFailed);
				VR.api.videoView.removeEventListener(VREvents.LOAD_SUCCESS, onVideoLoadSuccess);
				
				trace("onVideoLoadSuccess, video duration = " + e.duration);
			}
			
			function onVideoPaused(e:VREvents):void
			{
				trace("onVideoPaused");
			}
			
			function onVideoResumed(e:VREvents):void
			{
				trace("onVideoResumed");
			}
			
			function onVideoStopped(e:VREvents):void
			{
				trace("onVideoStopped");
			}
			
			function onVideoReachedEnd(e:VREvents):void
			{
				VR.api.videoView.seekTo(0);
				VR.api.videoView.resume();
				
				trace("onVideoReachedEnd");
			}
			
			function onVideoPositionUpdated(e:VREvents):void
			{
				trace("position updated... " + e.position + " / " + e.duration);
			}
			
			onResize();
		}
		
		private function onVRClosed(e:VREvents):void
		{
			trace("vr window closed!");
		}
		
		private function onVRTapped(e:VREvents):void
		{
			trace("vr window tapped!");
			
			trace(VR.api.headRotation);
			trace("volume = " + VR.api.videoView.volume);
			//VR.api.displayMode = DisplayMode.FULLSCREEN_STEREO;
			
			if (VR.api.videoView.isPaused)
			{
				VR.api.videoView.resume();
			}
			else
			{
				VR.api.videoView.pause();
			}
		}
		
		private function onVRModeChanged(e:VREvents):void
		{
			switch (e.displaymode) 
			{
				case DisplayMode.EMBEDDED:
					trace("vr mode changed: EMBEDDED");
				break;
				
				case DisplayMode.FULLSCREEN_MONO:
					trace("vr mode changed: FULLSCREEN_MONO");
				break;
				
				case DisplayMode.FULLSCREEN_STEREO:
					trace("vr mode changed: FULLSCREEN_STEREO");
				break;
				
				default:
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = 0xDFE4FF;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xFFDB48;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xDFE4FF;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			return sp;
		}
	}
	
}