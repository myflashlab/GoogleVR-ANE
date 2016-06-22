# Google VR ANE V1.0.0 (beta) for Android+iOS
Google Virtual Reality SDK works on Android and iOS so why shouldn't it work on Air? The current release of this cool ANE will let you use 360 degree images in your own application. we are working on adding 360 video playback also but we decided to release the ANE sooner because we were receiving many requests for supporting 360 image VR experience. So, here it is.

*Notice: To support Virtual 3D world is not in our to-do list at the moment because rendering the 3D world in Virtual Reality is happening in OpenGL inside Java/Objectice-C environment and ANEs cannot provide this feature to AS3* 

**Main Features:**
* 360 image preview based on device orientation
* supporting Google VR Mode for [cardboard](https://vr.google.com/cardboard/index.html)
* 100% identical AS3 API for Android and iOS

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/index.html?com/myflashlab/air/extensions/googleVR/package-detail.html&com/myflashlab/air/extensions/googleVR/class-list.html)  
[How to get started? **read here**](https://github.com/myflashlab/GoogleVR-ANE/wiki)

**NOTICE**: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.
[Download the ANE](https://github.com/myflashlab/GoogleVR-ANE/tree/master/FD/lib)

# Air Usage
```actionscript
import com.myflashlab.air.extensions.googleVR.VR;
import com.myflashlab.air.extensions.googleVR.events.ImgViewEvents;
import com.myflashlab.air.extensions.googleVR.events.VREvents;
import com.myflashlab.air.extensions.googleVR.imgView.VRImageConfig;

VR.init();

// add listeners
VR.api.addEventListener(VREvents.NATIVE_WINDOW_CLOSED, onVRClosed);
VR.api.imageView.addEventListener(ImgViewEvents.LOAD_FAILED, onLoadFailed);
VR.api.imageView.addEventListener(ImgViewEvents.LOAD_SUCCESS, onLoadSuccess);

// configure the 360 image object you want to launch
var vrSetting:VRImageConfig = new VRImageConfig();
vrSetting.btnExit = File.applicationDirectory.resolvePath("exit.png");
vrSetting.image360 = File.applicationDirectory.resolvePath("360Img.jpg");
vrSetting.imageType = VRImageConfig.TYPE_STEREO_OVER_UNDER;
vrSetting.vrModeButtonEnabled = true;

// and finally attach the Image Config instance to the VR ANE
VR.api.imageView.attach(vrSetting);

private function onVRClosed(e:VREvents):void
{
	trace("vr window closed!");
}

private function onLoadFailed(e:ImgViewEvents):void
{
	trace("onLoadFailed: " + e.msg);
}

private function onLoadSuccess(e:ImgViewEvents):void
{
	trace("onLoadSuccess");
}
```

# Air .xml manifest
```xml
<!--
FOR ANDROID:
-->
<manifest android:installLocation="auto">
	
	<!--Android SDK 19 or higher can run Google VR only-->
	<uses-sdk android:minSdkVersion="19" />
	
	<!-- 
		For Google VR to work properly, it is adviced to set largeHeap to true. learn
		about this attribute here:
		https://developer.android.com/guide/topics/manifest/application-element.html 
	-->
	<application android:largeHeap="true">
		
		<!-- This activity is your main Air application If you don't add it, Air SDK will do that for you! -->
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
		
		<!-- Required for the Google VR imageView -->
		<activity android:name="com.myflashlab.gvr.MyVrImageView" android:launchMode="singleTask" android:theme="@style/Theme.FullScreen" />
		
	</application>
</manifest>





<!--
FOR iOS:
-->
	<InfoAdditions>
	
		<!--iOS 8.0 or higher can support this ANE-->
		<key>MinimumOSVersion</key>
		<string>8.0</string>
		
	</InfoAdditions>
	
	
	
	
	
<!--
Embedding the ANE:
-->
  <extensions>
	
	<!-- 
		below are the common dependencies that Google VR relies on.
		download them from https://github.com/myflashlab/common-dependencies-ANE 
	-->
	<extensionID>com.myflashlab.air.extensions.dependency.gvr.common</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.gvr.commonwidget</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.gvr.panowidget</extensionID>
	
	<!-- And finally embed the main GVR ANE -->
    <extensionID>com.myflashlab.air.extensions.googleVR</extensionID>
	
  </extensions>
-->
```

# Requirements 
1. Android API 19 or higher
2. iOS SDK 8.0 or higher
3. Air SDK 22 or higher
4. This ANE is dependent on **gvr_common.ane**, **gvr_commonwidget.ane**, and **gvr_panowidget.ane** You need to add these ANEs to your project too. [Download them from here:](https://github.com/myflashlab/common-dependencies-ANE)
5. On the iOS side, you need to make sure you have included the resources at the top of you package. *next to the main .swf of your project*. [Check here for the resources](https://github.com/myflashlab/GoogleVR-ANE/tree/master/FD/bin) **CardboardSDK.bundle**, **GoogleKitCore.bundle**, **GoogleKitDialogs.bundle**, **GoogleKitHUD.bundle** and **MaterialRobotoFontLoader.bundle**

# Commercial Version
http://www.myflashlabs.com/product/google-virtual-reality-air-native-extension/

![Google VR ANE](http://www.myflashlabs.com/wp-content/uploads/2016/04/product_adobe-air-ane-extension-google-vr-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
[How to get started with Games Services?](https://github.com/myflashlab/GoogleVR-ANE/wiki)

# Changelog
*Jun 22, 2016 - V1.0.0*
* beginning of the journey!
