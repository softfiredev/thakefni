import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


import '../common/alert.dart';
import '../common/theme.dart';
import '../models/category.dart';
import '../models/dto/quiz_res.dart';
import '../models/quiz.dart';
import '../models/quiz_history.dart';
import '../services/ads_class.dart';
import '../stores/store.dart';

class QuizCategoryDetailsScreen extends StatefulWidget {
  static const routeName = '/categoryDetails';
  late Category category;

  QuizCategoryDetailsScreen(this.category, {Key? key}) : super(key: key);

  @override
  _QuizCategoryDetailsScreenState createState() => _QuizCategoryDetailsScreenState(category);
}

class _QuizCategoryDetailsScreenState extends State<QuizCategoryDetailsScreen> {
  late Category category;
  late QuizHistory history;
  late QuizResult result;
  late BannerAd _bannerAd;
  bool _isLoaded = false;

  Category? cat;


  _QuizCategoryDetailsScreenState(this.category);

  late List<Quiz> quizList = [];
  @override
  void initState() {
    var quizStore = QuizStore();
    quizStore.loadQuizListByCategoryAsync(category.id).then((value) {
      setState(() {
        quizList = value;
      });
    });

  }
  //banner ads
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdsManager.bannerAdUnitId,
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
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.center,
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: Column(
            children: [
              screenHeader(category),
              Expanded(
                child: categoryDetailsView(quizList),
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

  screenHeader(Category category) {
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
            category.name,
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  categoryDetailsView(List<Quiz> quizList) {
    return SingleChildScrollView(
      child: Column(
        children: quizList
            .map((quiz) => GestureDetector(
          child: categoryDetailsItemView(quiz),
          onTap: () {
            checkinternet(quiz);
          },
        ))
            .toList(),
      ),
    );
  }

  categoryDetailsItemBadge(Quiz quiz) {
    return Container(
      alignment: Alignment.topRight,
      child: Container(
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ThemeHelper.primaryColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            )),
        child: Text(
          " أسئلة ${quiz.questions.length}",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  categoryDetailsItemView(Quiz quiz) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 20),
      decoration: ThemeHelper.roundBoxDeco(),
      child: Stack(
        children: [
          categoryDetailsItemBadge(quiz),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: ThemeHelper.roundBoxDeco(color: Color(0xffE1E9F6), radius: 10),
                  child: Image(
                    image: AssetImage(
                        quiz.imagePath.isEmpty == true ? category.imagePath : quiz.imagePath),
                    width: 130,
                  ),
                ),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.title,
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(quiz.description),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  checkinternet(Quiz quiz) async{
    var result = await InternetConnectionChecker().hasConnection;
    if(result==true) {
      Navigator.of(context).pushNamed("/quiz", arguments: quiz);    }else{
      showAlertInternet();
    }
  }
  showAlertInternet() {
    AlertUtil.showAlert(
        context, "حل الكونكسيون", "باش تعيش تجربة تونسية مية بالمية و تربح معانا حل الكونكسيون");
  }
}
