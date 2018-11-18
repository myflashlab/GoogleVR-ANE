Google VR Adobe Air Native Extension

*Nov 18, 2018 - V3.1.1*
* Works with OverrideAir ANE V5.6.1 or higher
* Works with ANELAB V1.1.26 or higher

*Sep 22, 2018 - V3.1.0*
* Removed androidSupport dependency
* Synced iOS frameworks with Firebase ANEs. Update "GoogleToolboxForMac.framework" and "GTMSessionFetcher.framework" to [V5.4.1](https://dl.google.com/firebase/sdk/ios/5_4_1/Firebase-5.4.1.zip)

*Nov 30, 2017 - V3.0.0*
* Optimized for the [ANE-LAB Software](https://github.com/myflashlab/ANE-LAB/)
* Updated Android SDK to V1.70.0 and iOS SDK to V1.100.0. To update your current project do the following:
  * update your Android [dependencies](https://github.com/myflashlab/common-dependencies-ANE): 
  * gvr_common.ane, gvr_commonwidget.ane, gvr_panowidget.ane, gvr_videowidget.ane
	* androidSupport.ane V26.0.2+
  * overrideAir.ane V5.0.0+
  * Update the framework files, **GoogleToolboxForMac.framework** and **GTMSessionFetcher.framework** from [Firebase SDK V4.6.0](https://dl.google.com/firebase/sdk/ios/4_6_0/Firebase-4.6.0.zip)
  * Update the iOS resource bundles from https://github.com/myflashlab/GoogleVR-ANE/blob/master/gvr_iOS_res_V3.0.0.zip

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