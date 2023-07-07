
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';



class AdsManager {
  static bool _testmode = true;


  static String get appId {
    if(Platform.isAndroid) {
      return "ca-app-pub-1646320331687220~5805212367";
    }else if(Platform.isIOS) {
      return "ca-app-pub-1646320331687220~5990142674";
    }else {
      throw UnsupportedError("Unsupported platform");
    }
  }




  static String get bannerAdUnitId {
    if(_testmode == true) {
      return BannerAd.testAdUnitId;
    }else if (Platform.isAndroid) {
      return "ca-app-pub-1646320331687220/3805734981";
    } else if(Platform.isIOS) {
      return "ca-app-pub-1646320331687220/6672668950";
    }else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (_testmode == true){
      return InterstitialAd.testAdUnitId;
    }else if (Platform.isAndroid) {
      return "ca-app-pub-1646320331687220/3116567324";
    } else if(Platform.isIOS) {
      return "ca-app-pub-1646320331687220/9236372671";
    }else {
      throw UnsupportedError("Unsupported platform");
    }
  }

}