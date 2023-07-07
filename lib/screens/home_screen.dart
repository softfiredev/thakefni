
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:thakefni/screens/reward_screen.dart';
import '../common/alert.dart';
import '../common/theme.dart';
import '../services/ads_class.dart';
import '../widgets/disco_button.dart';
import 'quiz_category.dart';
import 'quiz_history_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);



  @override
  _HomeScreenState createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _audioPlayer = AssetsAudioPlayer();
  final now = DateTime.now();
  late BannerAd _bannerAd;
  bool _isLoaded = false;
  InterstitialAd? interstitialAd;
  bool _isLoadedInt = false;






  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId:AdsManager.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );

    _bannerAd.load();
    InterstitialAd.load(
      adUnitId: AdsManager.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad){
            setState(() {
              _isLoadedInt = true;
              interstitialAd= ad;
            });

          },
          onAdFailedToLoad: (error) {
          }
      ),
    );
    setupPlaylist();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _audioPlayer.dispose();

    //Ads

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.paused) {
      stopMusic();
    }else{
      playMusic();
    }

  }



  void setupPlaylist() async  {
    _audioPlayer.open(
      Playlist(
          audios: [
            Audio("assets/music/lella.mp3"),
            Audio("assets/music/entichamsi.mp3"),
            Audio("assets/music/kelmti.mp3"),
            Audio("assets/music/nawar.mp3"),
            Audio("assets/music/mansit.mp3"),
            Audio("assets/music/aman.mp3"),
            Audio("assets/music/ordh.mp3"),
            Audio("assets/music/nassaya.mp3"),
            Audio("assets/music/tesher.mp3"),
            Audio("assets/music/tounsi.mp3"),
          ]),
      autoStart:  true,
      loopMode: LoopMode.playlist,
      volume: 0.5,

    );


  }
  playMusic() async {
    await _audioPlayer.play();
  }

  stopMusic() async {
    await _audioPlayer.pause();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _key,
          drawer: navigationDrawer(),
          body: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              children: [
                drawerToggleButton(),
                Column(
                  children: [
                    const SizedBox(height: 40,),
                    headerText("Thakefni"),
                    const SizedBox(height: 50),
                    ...homeScreenButtons(context),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: _isLoaded
              ?  Container(
            height:_bannerAd.size.height.toDouble(),
            width: _bannerAd.size.width.toDouble(),
            child: AdWidget(ad:_bannerAd),
          )
              : const SizedBox()
      ),
    );
  }

  Drawer navigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Thakefni",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                SizedBox(width: 60),
                Text(
                  "by SoftFire",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('الرئيسية',style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),),
            onTap: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              if(_isLoadedInt) {
                interstitialAd!.show();
              }
            },
          ),
          ListTile(
            title: const Text('أبدأ اللعب',style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),),
            onTap: () {
              Navigator.pushNamed(context,QuizCategoryScreen.routeName );
              if(_isLoadedInt) {
                interstitialAd!.show();
              }

            },
          ),
          ListTile(
            title: const Text('الجوائز',style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),),
            onTap: () {
              Navigator.pushNamed(context, RewardScreen.routeName);
              if(_isLoadedInt) {
                interstitialAd!.show();
              }
            },
          ),
          ListTile(
            title: const Text('الهيستوريك',style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),),
            onTap: () {
              Navigator.pushNamed(context, QuizHistoryScreen.routeName);
              if(_isLoadedInt) {
                interstitialAd!.show();
              }
            },
          ),
          const Divider(
            thickness: 4,
            color: Colors.blue,
          ),
          ListTile(
            title: const Text('تواصل معنا', style: TextStyle(
                fontSize: 20
            ),),
            onTap: () {
              AlertUtil.showAlert(
                  context, "SoftFire", "softfiredev@gmail.com");
            },
          ),
          ListTile(
            title: const Text('أخرج',
              style: TextStyle(color: Colors.blue,
                  fontSize: 18),),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
          ),
        ],

      ),
    );
  }

  Widget drawerToggleButton() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20),
      alignment: Alignment.topLeft,
      child: GestureDetector(
        child: const Image(
          image: AssetImage("assets/icons/menu.png"),
          width: 36,
        ),
        onTap: () {
          _key.currentState!.openDrawer();

        },
      ),
    );
  }

  Text headerText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 72,
          color: ThemeHelper.accentColor,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
                color: ThemeHelper.shadowColor,
                offset: const Offset(-11, 11),
                blurRadius: 30)
          ]),
    );
  }

  List<Widget> homeScreenButtons(BuildContext context) {
    return [
      DiscoButton(
        onPressed: () {
          checkinternet();
          if(_isLoadedInt) {
            interstitialAd!.show();
          }
        },
        child: const Text(
          "أبدأ اللعب",
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        isActive: true,
      ),
      DiscoButton(
        onPressed: () {
          Navigator.pushNamed(context, RewardScreen.routeName);
          if(_isLoadedInt) {
            interstitialAd!.show();
          }
        },
        child: Text(
          "الجوائز",
          style: TextStyle(fontSize: 30, color: ThemeHelper.primaryColor),
        ),
      ),
      DiscoButton(
        onPressed: () {
          Navigator.pushNamed(context, QuizHistoryScreen.routeName);
          if(_isLoadedInt) {
            interstitialAd!.show();
          }
        },
        child: Text(
          "الهيستوريك",
          style: TextStyle(fontSize: 30, color: ThemeHelper.primaryColor),
        ),
      ),
    ];
  }
  checkinternet() async{
    var result = await InternetConnectionChecker().hasConnection;
    if(result==true) {
      Navigator.pushNamed(context, QuizCategoryScreen.routeName);
    }else{
      showAlertInternet();
    }
  }
  showAlertInternet() {
    AlertUtil.showAlert(
        context, "حل الكونكسيون", "باش تعيش تجربة تونسية مية بالمية و تربح معانا حل الكونكسيون");
  }
}
