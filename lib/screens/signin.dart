
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:thakefni/screens/resetpassw_screen.dart';
import 'package:thakefni/screens/signup.dart';


import '../common/alert.dart';
import '../widgets/disco_button.dart';
import 'home_screen.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver{
  InterstitialAd? interstitialAd;
  bool _isvisible = false;
  bool isLoading = false;
  var email, password;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  signin() async{
    var formdata = formstate.currentState;
    if(formdata!.validate()) {
      formdata.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AlertUtil.showAlert(
              context, "مشكلة في الكونط","الإيميل هذا ماهوش موجود عندنا من فضلك أعمل كونط");
          setState(() {
            isLoading = false;
          });
        } else if (e.code == 'wrong-password') {
          AlertUtil.showAlert(
              context, "مشكلة في المودباس","المودباس هذا غالط الرجاء التثبت");
          setState(() {
            isLoading = false;
          });
        }
      }
    }else {
      setState(() {
        isLoading = false;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: isLoading?
        Center(
          child: Container(
            height: size.height / 15,
            width: size.width / 15,
            child: CircularProgressIndicator(),
          ),
        )
            :SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height-20,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget> [
                    Text("دخول", style:
                    TextStyle(fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                    ),),
                    SizedBox(height: 10,),
                    Text("سجل الدخول و ألعب باش تربح", style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                    ),)
                  ],
                ),
                Form(
                    key: formstate,
                    child:Column(
                      children: <Widget> [
                        TextFormField(
                          onSaved: (eal) {
                            email = eal?.trim();
                          },
                          validator: (String? eal) {
                            if (eal!.isEmpty) {
                              return "أكتب إيميل صحيح";
                            }
                            return null;
                          },
                          obscureText: false,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey)
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade400)
                              ),
                              hintText:  "الإيميل",
                              hintStyle: TextStyle(
                                  color: Colors.blue
                              )
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          onSaved: (pass) {
                            password = pass?.trim();
                          },
                          validator: (String? pass) {
                            if(pass!.length < 8 ) {
                              return "المودباس لازمو ما أقلش من 8 حروف";
                            }
                            if(RegExp("r'[0-9]").hasMatch(pass)){
                              return "المودباس لازمو أقل حاجة فيه رقم";
                            }
                            return null;
                          },
                          obscureText: !_isvisible,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState((){
                                    _isvisible = !_isvisible;
                                  });
                                },
                                icon: _isvisible ? Icon(Icons.visibility_off,color: Colors.blue,) : Icon(Icons.visibility),
                              ) ,
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey)
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade400)
                              ),
                              hintText:  "المودباس",
                              hintStyle: TextStyle(
                                  color: Colors.blue
                              )
                          ),
                        ),
                      ],
                    )),
                Column(
                  children: <Widget> [
                    InkWell(onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Resetpassword() ));
                    },
                      child: Text("نسيت المودباس؟", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.blue.shade500
                      ),),
                    ),
                  ],
                ),
                Column(
                  children: <Widget> [
                    Container(
                      padding: EdgeInsets.only(top: 3,left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.white),
                            top: BorderSide(color: Colors.white),
                            left: BorderSide(color: Colors.white),
                            right: BorderSide(color: Colors.white),
                          )
                      ),
                      child: DiscoButton(
                        onPressed: () async{
                          var result = await InternetConnectionChecker().hasConnection;
                          if (result == true) {
                            setState(() {
                              isLoading = true;
                            });
                            UserCredential? response = await signin();
                            if(response != null){
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pushReplacementNamed(context,HomeScreen.routeName);
                              await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
                                  {
                                    "password": password,
                                  });
                            }
                          }else{
                            AlertUtil.showAlert(
                                context, "مشكلة في الكونكسيون", "باش تنجم تدخل للكونط لازم تحل الكونكسيون");
                          }
                        },
                        child: Text(
                          "دخول",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        isActive: true,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        InkWell(onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp() ));
                        },
                          child: Text("أعمل كونط", style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.blue.shade500
                          ),),
                        ),
                        SizedBox(width: 10,),
                        Text("كان ما عندكش كونط؟",style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey
                        ),),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}

Widget inputfield ({label , obscureText = false})  {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget> [
      Text(label , style:
      TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade500
      ),),
      SizedBox(height: 5,),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)
            )
        ),
      ),
      SizedBox(height: 30,),
    ],
  );
}










