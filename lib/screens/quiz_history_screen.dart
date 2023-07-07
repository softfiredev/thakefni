import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:thakefni/screens/quiz_screen.dart';
import '../common/theme.dart';
import '../models/quiz_history.dart';
import '../services/ads_class.dart';
import '../stores/store.dart';
import '../widgets/disco_button.dart';
import '../widgets/screen_header.dart';

class QuizHistoryScreen extends StatefulWidget {
  static const routeName = '/quizHistory';
  const QuizHistoryScreen({Key? key}) : super(key: key);

  @override
  _QuizHistoryScreenState createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  List<QuizHistory> quizHistoryList = [];
  late QuizStore store;
  late BannerAd _bannerAd;
  bool _isLoaded = false;
  InterstitialAd? interstitialAd;
  bool _isLoadedInt = false;

  @override
  void initState() {
    store = QuizStore();
    store.loadQuizHistoryAsync().then((value) {
      setState(() {
        quizHistoryList = value;
      });
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.center,
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: Column(
            children: [
              const ScreenHeader("الهيستوريك"),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List<QuizHistory>.from(quizHistoryList)
                        .map(
                          (e) => quizHistoryViewItem(e),
                    )
                        .toList(),
                  ),
                ),
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

  Widget quizHistoryViewItem(QuizHistory quiz) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        decoration: ThemeHelper.roundBoxDeco(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 10),
              child: SizedBox(
                height: 115,
                width: 10,
                child: Container(
                  decoration: ThemeHelper.roundBoxDeco(color: ThemeHelper.primaryColor, radius: 10),
                ),
              ),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  quiz.quizTitle.isEmpty ? "Question" : quiz.quizTitle,
                  style: const TextStyle(fontSize: 24),
                ),
                Text("${quiz.score} : السكور ",
                    style: TextStyle(color: ThemeHelper.accentColor, fontSize: 18)),
                Text("${quiz.timeTaken}: الوقت "),
                Text(
                    "${quiz.quizDate.year}-${quiz.quizDate.month}-${quiz.quizDate.day} ${quiz.quizDate.hour}:${quiz.quizDate.minute}:التاريخ "),
              ]),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                DiscoButton(
                  width: 100,
                  height: 50,
                  onPressed: () {
                    store.getQuizByIdAsync(quiz.quizId, quiz.categoryId).then((value) {
                      if (value != null) {
                        Navigator.pushReplacementNamed(context, QuizScreen.routeName,
                            arguments: value);
                        if(_isLoadedInt) {
                          interstitialAd!.show();
                        }
                      } else {}
                    });
                  },
                  child: const Text("عاود",style: TextStyle(
                    fontSize: 20,
                  ),),),
              ],
            )
          ],
        ));
  }
}
