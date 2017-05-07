# Google VR ANE V2.2.0 for Android+iOS
Google Virtual Reality SDK works on Android and iOS so why shouldn't it work on Air? This cool ANE will let you use 360 images and videos in your own AIR application.

*Notice: Supporting Virtual 3D world is not in our to-do list at the moment because rendering the 3D world in Virtual Reality is happening in OpenGL inside Java/Objectice-C environment and ANEs cannot provide this feature to AS3* 

**Main Features:**
* 360 image preview based on device orientation
* 360 video preview based on device orientation
* supporting Google VR Mode for [cardboard](https://vr.google.com/cardboard/index.html)
* 100% identical AS3 API for Android and iOS

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/index.html?com/myflashlab/air/extensions/googleVR/package-detail.html&com/myflashlab/air/extensions/googleVR/class-list.html)  

**NOTICE 1**: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.
[Download the ANE](https://github.com/myflashlab/GoogleVR-ANE/tree/master/FD/lib)

**NOTICE 2**: On older Android devices you may see your AIR content all black when you return from the 360 video view. This is an old bug in AIR and we hope Adobe would find the reason and hopefully fix it someday. In the meanwhile, [read this to fix the problem](http://forum.starling-framework.org/topic/ane-fix-for-blackblank-screen-bug-when-returning-to-air-android-apps)

# AIR Usage General listeners
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/GoogleVR-ANE/blob/master/FD/src/Demo.as).

```actionscript
import com.myflashlab.air.extensions.googleVR.*;

VR.init();

// add general VR listeners
VR.api.addEventListener(VREvents.VR_CLOSED, onVRClosed);
VR.api.addEventListener(VREvents.DID_TAP, onVRTapped);
VR.api.addEventListener(VREvents.DISPLAY_MODE_CHANGED, onVRModeChanged);

function onVRClosed(e:VREvents):void
{
	trace("vr window closed!");
}

function onVRTapped(e:VREvents):void
{
	trace("vr window tapped!");
	
	// get the current head position of the VR view
	trace(VR.api.headRotation);
	
	// you can change display mode from AS3 also.
	//VR.api.displayMode = DisplayMode.FULLSCREEN_STEREO;
	
	// when playing 360 videos, you may toggle pause/resume when the VR screen is tapped
	if (VR.api.videoView.isPaused)
	{
		VR.api.videoView.resume();
	}
	else
	{
		VR.api.videoView.pause();
	}
}

function onVRModeChanged(e:VREvents):void
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
```

# AIR Usage 360 Image
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/GoogleVR-ANE/blob/master/FD/src/Demo.as).

```actionscript
// configure the 360 image object you want to launch
var vrSetting:VRConfigImg = new VRConfigImg();
vrSetting.btnExit = File.applicationDirectory.resolvePath("exit.png");
vrSetting.image360 = File.applicationDirectory.resolvePath("360Img.jpg");
vrSetting.imageType = VRConfig.TYPE_STEREO_OVER_UNDER;
vrSetting.stereoModeButtonEnabled = true;
vrSetting.infoButtonEnabled = false;
vrSetting.touchTrackingEnabled = true;

// and finally attach the Image Config instance to the VR ANE
VR.api.imageView.addEventListener(VREvents.LOAD_FAILED, onLoadFailed);
VR.api.imageView.addEventListener(VREvents.LOAD_SUCCESS, onLoadSuccess);
VR.api.imageView.attach(vrSetting);

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
```

# AIR Usage 360 Video
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/GoogleVR-ANE/blob/master/FD/src/Demo.as).

```actionscript
// configure the 360 video object you want to launch
var vrSetting:VRConfigVid = new VRConfigVid();
vrSetting.btnExit = File.applicationDirectory.resolvePath("exit.png");
vrSetting.video360 = File.applicationDirectory.resolvePath("360Vid.mp4");
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
```

# AIR .xml manifest
```xml
<!--
FOR ANDROID:
-->
<manifest android:installLocation="auto">
	
	<!--Android SDK 19 or higher can run Google VR only-->
	<uses-sdk android:minSdkVersion="19" />
	
	<!--The new Permission thing on Android works ONLY if you are targetting Android SDK 23 or higher-->
	<uses-sdk android:targetSdkVersion="23"/>
	
	<!-- 
		For Google VR to work properly, it is adviced to set largeHeap to true. learn
		about this attribute here:
		https://developer.android.com/guide/topics/manifest/application-element.html 
	-->
	<application android:largeHeap="true">
		
		<!-- This activity is your main AIR application If you don't add it, AIR SDK will do that for you! -->
		<activity>
			<intent-filter>
				<action android:name="android.intent.action.MAIN" />
				<category android:name="android.intent.category.LAUNCHER" />
			</intent-filter>
			<intent-filter>
				<action android:name="android.intent.action.VIEW" />
				<category android:name="android.intent.category.BROWSABLE" />
				<category android:name="android.intent.category.DEFAULT" />
			</intent-filter>
		</activity>
		
		<!-- Required for the Google VR -->
		<activity android:name="com.myflashlab.gvr.MyVrImageView" android:launchMode="singleTask" android:theme="@style/Theme.FullScreen" />
		<activity android:name="com.myflashlab.gvr.MyVrVideoView" android:launchMode="singleTask" android:theme="@style/Theme.FullScreen" />
		
	</application>
</manifest>





<!--
FOR iOS:
-->
	<InfoAdditions>
	
		<!--iOS 8.0 or higher can support this ANE-->
		<key>MinimumOSVersion</key>
		<string>8.0</string>
		
		<!-- Bypass iOS security when debugging your app and you need to load resources from a local server like http://192.168.x.x -->
		<key>NSAppTransportSecurity</key>
		<dict>
			<key>NSAllowsArbitraryLoads</key>
			<true/>
		</dict>
		
		<!-- Required when user wants to scan barcodes while using the card -->
		<key>NSCameraUsageDescription</key>
		<string>Camera usage description</string>
		
	</InfoAdditions>
	
	
	
	
	
<!--
Embedding the ANE:
-->
  <extensions>
	
	<!-- 
		below are the common dependencies that Google VR relies on:
		download them from https://github.com/myflashlab/common-dependencies-ANE 
	-->
	<extensionID>com.myflashlab.air.extensions.dependency.gvr.common</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.gvr.commonwidget</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.gvr.panowidget</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.gvr.videowidget</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
	
	<!-- And finally embed the main GVR ANE -->
    <extensionID>com.myflashlab.air.extensions.googleVR</extensionID>
	
	<!-- Required if you are targeting AIR 24+ and have to take care of Permissions mannually -->
	<extensionID>com.myflashlab.air.extensions.permissionCheck</extensionID>
	
  </extensions>
-->
```

# Requirements 
1. Android API 19 or higher
2. iOS SDK 8.0 or higher
3. AIR SDK 24 or higher
4. This ANE is dependent on **androidSupport.ane**, **overrideAir.ane**, **gvr_common.ane**, **gvr_commonwidget.ane**, **gvr_panowidget.ane** and **gvr_videowidget.ane** You need to add these ANEs to your project too. [Download them from here:](https://github.com/myflashlab/common-dependencies-ANE)
5. Even if you are building for iOS only, you'd still need **overrideAir.ane**.
6. On the iOS side, you need to make sure you have included the resources at the top of you package. *next to the main .swf of your project*. [Check here for the resources](https://github.com/myflashlab/GoogleVR-ANE/tree/master/FD/bin) **CardboardSDK.bundle**, **GoogleKitCore.bundle**, **GoogleKitDialogs.bundle**, **GoogleKitHUD.bundle** and **MaterialRobotoFontLoader.bundle**
7. Moreover, on the iOS side, you will need **GoogleToolboxForMac.framework** and **GTMSessionFetcher.framework** available in your *AIR_SDK/lib/aot/stub* folder. Download them from [this package](https://dl.google.com/firebase/sdk/ios/3_13_0/Firebase-3.13.0.zip).

# Permissions
If you are targeting AIR 24 or higher, you need to [take care of the permissions mannually](http://www.myflashlabs.com/adobe-air-app-permissions-android-ios/). Below are the list of Permissions this ANE might require. (Note: *Necessary Permissions* are those that the ANE will NOT work without them and *Optional Permissions* are those which are needed only if you are using some specific features in the ANE.)

Check out the demo project available at this repository to see how we have used our [PermissionCheck ANE](http://www.myflashlabs.com/product/native-access-permission-check-settings-menu-air-native-extension/) to ask for the permissions.

**Necessary Permissions:**  
none

**Optional Permissions:**  
2. PermissionCheck.SOURCE_STORAGE

# Commercial Version
http://www.myflashlabs.com/product/virtual-reality-air-native-extension/

![Google VR ANE](http://www.myflashlabs.com/wp-content/uploads/2016/06/product_adobe-air-ane-virtual-reality-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
*May 07, 2017 - V2.2.0*
* Updated the SDK to V1.40.0 for both Android and iOS. To update your current project do the following:
  * update your Android [dependencies](https://github.com/myflashlab/common-dependencies-ANE): 
    * gvr_common.ane
	* gvr_commonwidget.ane
	* gvr_panowidget.ane
	* gvr_videowidget.ane
	* androidSupport.ane
	* overrideAir.ane
  * overrideAir.ane is also needed on the iOS side
  * Download [this package](https://dl.google.com/firebase/sdk/ios/3_13_0/Firebase-3.13.0.zip) and look for the following two frameworks and copy them to your AIR SDK folder at: **AIR_SDK/lib/aot/stub**
    * **GoogleToolboxForMac.framework**
	* **GTMSessionFetcher.framework**
  * Finally, remove old iOS resources from your app bin folder and copy the new ones [found here](https://github.com/myflashlab/GoogleVR-ANE/tree/master/FD/bin).
    * CardboardSDK.bundle
	* GoogleKitCore.bundle
	* GoogleKitDialogs.bundle
	* GoogleKitHUD.bundle
	* MaterialRobotoFontLoader.bundle
* Added Volume property
* Supporting ```infoButtonEnabled``` on the iOS side also
* On the iOS side, the following usage description is needed:
  ```xml
  <!-- Required when user wants to scan barcodes while using the card -->
  <key>NSCameraUsageDescription</key>
  <string>Camera usage description</string>
  ```
* Fixed the white screen problem on AIR 24+

*Jan 10, 2017 - V2.1.1*
* Repackaged the ANE with AIR 24 to fix the ```ane is not a valid native extension file``` error started with some ANEs in AIR SDK 24
* Requires AIR SDK 24+ to compile the ANE

*Nov 09, 2016 - V2.1.0*
* Optimized for Android manual permissions if you are targeting AIR SDK 24+
* The following dependencies are now also required by the ANE androidSupport.ane and overrideAir.ane

*Oct 22, 2016 - V2.0.1*
* Fixed iOS conflicts with the [GPS ANE](http://www.myflashlabs.com/product/gps-ane-adobe-air-native-extension/).

*Sep 20, 2016 - V2.0.0*
* Updated to Google VR V0.9.1 and Wrote everything from scratch because a LOT has changed since the VR SDK is not yet stable and new versions are changing dratstically.
* Added 360 video support

*Jun 22, 2016 - V1.0.0*
* beginning of the journey!
