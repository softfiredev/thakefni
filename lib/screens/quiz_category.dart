import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:thakefni/screens/quiz_category_details.dart';
import '../common/alert.dart';
import '../common/theme.dart';
import '../models/category.dart';
import '../services/ads_class.dart';
import '../stores/store.dart';

class QuizCategoryScreen extends StatefulWidget {
  static const routeName = '/quizCategory';
  const QuizCategoryScreen({Key? key}) : super(key: key);

  @override
  _QuizCategoryScreenState createState() => _QuizCategoryScreenState();
}

class _QuizCategoryScreenState extends State<QuizCategoryScreen> {
  late List<Category> categoryList = [];
  late BannerAd _bannerAd;
  bool _isLoaded = false;
  InterstitialAd? interstitialAd;
  bool _isLoadedInt = false;



  // banner Ads
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      request: AdRequest(),
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
  }
  @override
  void initState() {


    var quizStore = QuizStore();
    quizStore.loadCategoriesAsync().then((value) {
      setState(() {
        categoryList = value;
      });
    });
    super.initState();

  }
  reward() {
    print("reward");
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.center,
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: Column(
            children: [
              screenHeader(),
              Expanded(
                child: categoryListView(categoryList),
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
            : SizedBox(),
      ),
    );
  }

  Widget screenHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            child: const Image(
              image: AssetImage("assets/icons/back.png"),
              width: 40,
            ),
            onTap: () {
              Navigator.pop(context);
              if(_isLoadedInt) {
                interstitialAd!.show();
              }

            },
          ),
          Text(
            "إختار الموضوع",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  Widget categoryListView(List<Category> categoryList) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 20,
        runSpacing: 30,
        direction: Axis.horizontal,
        children: categoryList
            .map((x) => GestureDetector(
          child: categoryListViewItem(x),
          onTap: () {
            checkinternet(x);

            if(_isLoadedInt) {
              interstitialAd!.show();
            }


          },
        ))
            .toList(),
      ),
    );
  }

  Widget categoryListViewItem(Category category) {
    return Container(
      width: 160,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(category.imagePath),
            width: 130,
          ),
          Text(category.name),
        ],
      ),
    );
  }
  checkinternet(Category x) async{
    var result = await InternetConnectionChecker().hasConnection;
    if(result==true) {
      Navigator.pushNamed(context,QuizCategoryDetailsScreen.routeName,arguments: x );
    }else{
      showAlertInternet();
    }
  }
  showAlertInternet() {
    AlertUtil.showAlert(
        context, "حل الكونكسيون", "باش تعيش تجربة تونسية مية بالمية و تربح معانا حل الكونكسيون");
  }


}
