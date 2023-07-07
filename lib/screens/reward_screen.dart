import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/alert.dart';
import '../common/theme.dart';
import '../models/reward.dart';
import '../services/ads_class.dart';
import '../stores/store.dart';

class RewardScreen extends StatefulWidget {
  static const routeName = '/rewardscreen';
  const RewardScreen({Key? key}) : super(key: key);

  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  late List<Reward> rewardList = [];
  late BannerAd _bannerAd;
  bool _isLoaded = false;
  InterstitialAd? interstitialAd;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoadedInt = false;
  int score = 0;
  int newscore = 0;
  List _tiketnum = [];
  List _listrem = [];



  getscore() async {
    var scored = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get();
    score = scored['score'];
  }

  CollectionReference userref = FirebaseFirestore.instance.collection('tikets');
  gettiketnum() async{
    var response = await userref.get();
    response.docs.forEach((element) {
      setState ((){
        _tiketnum.add(element.data());
      });

    });


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
  void initState() {
    getscore();
    gettiketnum();
    var quizStore = QuizStore();
    quizStore. loadRewardsAsync().then((value) {
      setState(() {
        rewardList = value;
      });
    });
    super.initState();

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
              Text(" نقاط : $score",style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.red
              ),),
              SizedBox(height: 20,),
              Expanded(
                child: categoryListView(rewardList),
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
            },
          ),
          Text(
            "الجوائز",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );

  }

  Widget categoryListView(List<Reward> rewardList) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 20,
        runSpacing: 30,
        direction: Axis.horizontal,
        children: rewardList
            .map((reward) => GestureDetector(
          child: categoryListViewItem(reward),
          onTap: () async{

            if(reward.name == "1D orange" && score >= 900){
              newscore = score - 900;
              await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
                  {
                    "score": newscore,
                  });
              Navigator.pop(context);

              Alert.showAlert(context, "1D Orange", "${_tiketnum[2]['code'][0]}");
              _listrem.add(_tiketnum[2]['code'][0]);


              await FirebaseFirestore.instance.collection('tikets').doc('orange').update({
                "code": FieldValue.arrayRemove(_listrem)
              });


            }
            else if (reward.name == "1D ooredoo" && score >= 900){
              newscore = score - 900;
              await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
                  {
                    "score": newscore,
                  });
              Navigator.pop(context);
              Alert.showAlert(context, "1D ooredoo", "${_tiketnum[0]['codeo'][0]}");
              _listrem.add(_tiketnum[0]['codeo'][0]);
              await FirebaseFirestore.instance.collection('tikets').doc('ooredoo').update({
                "codeo": FieldValue.arrayRemove(_listrem)
              });
            }
            else if (reward.name == "1D Telecom" && score >= 900) {
              newscore = score - 900;
              await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
                  {
                    "score": newscore,
                  });
              Navigator.pop(context);
              Alert.showAlert(context, "1D Telecom", "${_tiketnum[4]['codet'][0]}");
              _listrem.add(_tiketnum[4]['codet'][0]);
              await FirebaseFirestore.instance.collection('tikets').doc('telecom').update({
                "codet": FieldValue.arrayRemove(_listrem)
              });
            }
            else if (reward.name == "5D orange" && score >= 2050) {
              newscore = score - 2050;
              await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
                  {
                    "score": newscore,
                  });
              Navigator.pop(context);
              Alert.showAlert(context, "5D orange", "${_tiketnum[3]['cartaoran'][0]}");
              _listrem.add(_tiketnum[3]['cartaoran'][0]);
              await FirebaseFirestore.instance.collection('tikets').doc('orange5').update({
                "cartaoran": FieldValue.arrayRemove(_listrem)
              });
            }
            else if(reward.name == "5D ooredoo" && score >= 2050) {
              newscore = score - 2050;
              await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
                  {
                    "score": newscore,
                  });
              Navigator.pop(context);
              Alert.showAlert(context, "5D ooredoo", "${_tiketnum[1]['cartao'][0]}");
              _listrem.add(_tiketnum[1]['cartao'][0]);
              await FirebaseFirestore.instance.collection('tikets').doc('ooreedoo5').update({
                "cartao": FieldValue.arrayRemove(_listrem)
              });
            }
            else if(reward.name == "5D Telecom" && score >= 2050) {
              newscore = score - 2050;
              await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
                  {
                    "score": newscore,
                  });
              Navigator.pop(context);
              Alert.showAlert(context, "5D Telecom", "${_tiketnum[5]['cartat'][0]}");
              _listrem.add(_tiketnum[5]['cartat'][0]);
              await FirebaseFirestore.instance.collection('tikets').doc('telecom5').update({
                "cartat": FieldValue.arrayRemove(_listrem)
              });
            }
            else{
              AlertUtil.showAlert(context, "نقاط غير كافية", ""
                  "ما تنجمش تربح معانا خاتر ما عندكش نقاط كافية"
                  "");
            }
            if(_isLoadedInt) {
              interstitialAd!.show();
            }
          },
        ))
            .toList(),
      ),
    );
  }

  Widget categoryListViewItem(Reward reward) {
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
            image: AssetImage(reward.imagePath),
            width: 130,
          ),
          Text(reward.name),
        ],
      ),
    );
  }
}
