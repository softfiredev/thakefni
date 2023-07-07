import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:thakefni/common/extensions.dart';
import 'package:thakefni/screens/quiz_result.dart';

import '../common/theme.dart';
import '../models/dto/option_sele.dart';
import '../models/dto/quiz_res.dart';
import '../models/option.dart';
import '../models/question.dart';
import '../models/quiz.dart';
import '../models/quiz_history.dart';
import '../services/ads_class.dart';
import '../services/engine.dart';
import '../stores/store.dart';
import '../widgets/disco_button.dart';
import '../widgets/question_option.dart';
import '../widgets/time_indicat.dart';

class QuizScreen extends StatefulWidget {
  static const routeName = '/quiz';
  late Quiz quiz;
  QuizScreen(this.quiz, {Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState(quiz);
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
  late QuizEngine engine;
  late QuizStore store;
  late Quiz quiz;
  Question? question;
  Timer? progressTimer;
  AppLifecycleState? state;
  late QuizHistory? history;
  late BannerAd _bannerAd;
  InterstitialAd? interstitialAd;
  bool _isLoadedInt = false;
  bool _isLoaded = false;

  int _remainingTime = 0;
  Map<int, OptionSelection> _optionSerial = {};

  _QuizScreenState(this.quiz) {
    store = QuizStore();
    engine = QuizEngine(quiz, onNextQuestion, onQuizComplete, onStop);
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
    engine.start();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    this.state = state;
  }

  @override
  void dispose() {
    if (progressTimer != null && progressTimer!.isActive) {
      progressTimer!.cancel();
    }
    engine.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20,),
                screenHeader(),
                const SizedBox(height: 20,),
                quizQuestion(),
                questionOptions(),
                const SizedBox(height: 20,),
                quizProgress(),
                const SizedBox(height: 20,),
                footerButton(),

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
      ),
    );
  }

  Widget screenHeader() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        quiz.title,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget quizQuestion() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: ThemeHelper.roundBoxDeco(),
      child: question?.text == "null" ? Image(image: AssetImage(question?.image?? ""),height: 100,) : Text(
        question?.text ?? "",
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }


  Widget questionOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: ThemeHelper.roundBoxDeco(),
      child: Column(
        textDirection: TextDirection.rtl,
        children: List<Option>.from(question?.options ?? []).map((e) {
          int optionIndex = question!.options.indexOf(e);
          var optWidget = GestureDetector(
            onTap: () {
              setState(() {
                engine.updateAnswer(
                    quiz.questions.indexOf(question!), optionIndex);
                for (int i = 0; i < _optionSerial.length; i++) {
                  _optionSerial[i]!.isSelected = false;
                }
                _optionSerial.update(optionIndex, (value) {
                  value.isSelected = true;
                  return value;
                });
              });
            },
            child: QuestionOption(
              optionIndex,
              _optionSerial[optionIndex]!.optionText,
              e.text,
              isSelected: _optionSerial[optionIndex]!.isSelected,
            ),
          );
          return optWidget;
        }).toList(),
      ),
    );
  }

  Widget quizProgress() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TimeIndicator(
              question?.duration ?? 1,
              _remainingTime,
                  () {},
            ),
          ),
          Text(
            "  ثانية   $_remainingTime",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget footerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DiscoButton(
          onPressed: () {
            if(_isLoadedInt) {
              interstitialAd!.show();
            }
            setState(() {
              engine.stop();
              if (progressTimer != null && progressTimer!.isActive) {
                progressTimer!.cancel();
              }
            });
            Navigator.pop(context);
          },
          child: const Text(
            "أخرج",
            style: TextStyle(fontSize: 20),
          ),
          width: 130,
          height: 50,
        ),
        DiscoButton(
          onPressed: () {
            engine.next();
          },
          child: const Text(
            "لي بعدو",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          isActive: true,
          width: 130,
          height: 50,
        ),


      ],
    );

  }

  void onNextQuestion(Question question) {
    setState(() {
      if (progressTimer != null && progressTimer!.isActive) {
        _remainingTime = 0;
        progressTimer!.cancel();
      }

      this.question = question;
      _remainingTime = question.duration;
      _optionSerial = {};
      for (var i = 0; i < question.options.length; i++) {
        _optionSerial[i] = OptionSelection(String.fromCharCode(49 + i), false);
      }
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime >= 0) {
        try {
          if (mounted) {
            setState(() {
              progressTimer = timer;
              _remainingTime--;
            });
          }
        } catch (ex) {
          timer.cancel();
        }
      }
    });
  }

  void onQuizComplete(Quiz quiz, int total, Duration takenTime) {
    if (mounted) {
      setState(() {
        _remainingTime = 0;
      });
    }
    progressTimer!.cancel();
    store.getCategoryAsync(quiz.categoryId).then((category) {
      store
          .saveQuizHistory(QuizHistory(
        quiz.id,
        quiz.title,
        category.id,
        "$total/${quiz.questions.length}",
        takenTime.format(),
        DateTime.now(),
        "Complete",
      ))
          .then((value) {
        Navigator.pushReplacementNamed(context, QuizResultScreen.routeName,
            arguments: QuizResult(quiz, total));
      });
    });
  }

  void onStop(Quiz quiz) {
    _remainingTime = 0;
    progressTimer!.cancel();
  }
}
