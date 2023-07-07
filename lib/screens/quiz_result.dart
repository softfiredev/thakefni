import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:thakefni/screens/quiz_history_screen.dart';


import '../common/alert.dart';

import '../models/dto/quiz_res.dart';
import '../services/ads_class.dart';
import '../widgets/disco_button.dart';

class QuizResultScreen extends StatefulWidget {
  static const routeName = '/quizResult';
  QuizResult result;
  QuizResultScreen(this.result, {Key? key}) : super(key: key);

  @override
  _QuizResultScreenState createState() => _QuizResultScreenState(this.result);
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  QuizResult result;
  int totalQuestions = 0;
  int totalCorrect = 0;
  int totalscore = 0;
  int totalscoreaff = 0;
  late BannerAd _bannerAd;
  bool _isLoaded = false;
  InterstitialAd? interstitialAd;
  bool _isLoadedInt = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _QuizResultScreenState(this.result);

  getscore() async {
    var score = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get();
    totalscore = score['score'];
    setState(() {
      totalscore += totalCorrect;
    });
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
        {
          "score": totalscore,
        });
    var scoreaff = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get();
    totalscoreaff = scoreaff['score'];
    AlertUtil.showAlert(context, "سكورك", " عدد النقاط متاعك وَلاَّ ${totalscoreaff}");
  }

  @override
  void initState() {
    getscore();
    setState(() {
      totalCorrect = result.totalCorrect;
      totalQuestions = result.quiz.questions.length;
    });
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              quizResultInfo(result),
              bottomButtons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isLoaded
          ?  Container(
        height:_bannerAd.size.height.toDouble(),
        width: _bannerAd.size.width.toDouble(),
        child: AdWidget(ad:_bannerAd),
      )
          : SizedBox(),
    );
  }

  Widget bottomButtons() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DiscoButton(
            onPressed: (){

              Navigator.pop(context);
              if(_isLoadedInt) {
                interstitialAd!.show();
              }


            },
            child: const Text(
              "أخرج",
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            width: 150,
            height: 50,
          ),
          DiscoButton(
            onPressed: () {

              Navigator.pushReplacementNamed(context, QuizHistoryScreen.routeName);
              if(_isLoadedInt) {
                interstitialAd!.show();
              }

            },
            child: const Text(
              "الهيستوريك",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            width: 150,
            height: 50,
            isActive: true,
          ),
        ],
      ),
    );
  }

  Widget quizResultInfo(QuizResult result) {
    return Column(
      children: [
        const Image(
          image: AssetImage("assets/images/badge.png"),
        ),
        Text(
          "! مبرووك",
          style: Theme.of(context).textTheme.headline3,
        ),
        const Text(
          "هاك كملت الأسئلة",
          style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),
        ),
        Text(
          ": سكورك",
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          "$totalCorrect/$totalQuestions",
          style: Theme.of(context).textTheme.headline2,
        ),
      ],
    );
  }
}
