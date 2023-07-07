

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:thakefni/screens/signin.dart';

import '../common/alert.dart';
import '../common/theme.dart';
import '../widgets/disco_button.dart';



class SignUp extends StatefulWidget {
  static const routeName = '/signup';
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with WidgetsBindingObserver{

  bool _isvisible = false;
  bool _isvisiblet = false;
  bool isLoading = false;
  var username , email, password, repass;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  signUp() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        return userCredential;

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AlertUtil.showAlert(
              context, "مشكلة في المودباس","مودباس ضعيف أكتب مودباس أقوى");

        } else if (e.code == 'email-already-in-use') {
          AlertUtil.showAlert(
              context, "مشكلة في الإيميل", " الإيميل هذا ديجا موجود عندنا");
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print(e);
      }
    }else{
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
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          },
            icon:  Icon(Icons.arrow_back_ios , size: 25, color: Colors.blue,) ,),
        ),
        body:isLoading ?
        Center(
          child: Container(
            height: size.height / 15,
            width: size.width / 15,
            child: CircularProgressIndicator(),
          ),
        )
            : SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  Column(
                    children: <Widget> [
                      Text("أعمل كونط", style:
                      TextStyle(fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue
                      ),),
                      SizedBox(height: 20,),
                      Text("أعمل كونط و ألعب باش تربح", style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueGrey,
                      ),)
                    ],
                  ),
                  Container(
                    child: Form(
                      key: formstate,
                      child: Column(
                        children: <Widget> [
                          TextFormField(
                            onSaved: (val) {
                              username = val?.trim();
                            },
                            validator: (String? val) {
                              if (val!.length > 30) {
                                return "لازم الإسم ما يفوتش 15 حروف" ;
                              }
                              if (val.length < 3) {
                                return "لازم الإسم ما أقلش من 3 حروف" ;
                              }
                              if (val.isEmpty) {
                                return "ما يلزمش تكون فارغة" ;
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
                                hintText:  "الإسم",
                                hintStyle: TextStyle(
                                    color: Colors.blue
                                )
                            ),
                          ),
                          SizedBox(height: 40,),
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
                          SizedBox(height: 40,),
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
                              repass = pass;
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
                          SizedBox(height: 40,),
                          TextFormField(
                            validator: (String? repassw) {
                              if(repassw != repass){
                                return "المودباس موش نفسو";
                              }
                              return null;
                            },
                            obscureText: !_isvisiblet,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState((){
                                      _isvisiblet = !_isvisiblet;
                                    });
                                  },
                                  icon: _isvisiblet ? Icon(Icons.visibility_off,color: Colors.blue,) : Icon(Icons.visibility),
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
                      ),
                    ),
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
                            if (result == true){
                              setState(() {
                                isLoading = true;
                              });
                              UserCredential response =   await signUp();
                              if(response != null) {
                                setState(() {
                                  isLoading = false;
                                });
                                AlertUtil.showAlert(
                                    context, "!! مبروك",
                                    "توا عندك كونط تنجم تدخل للتطبيق ");
                                await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
                                  "name": username,
                                  "email": email,
                                  "password": password,
                                  "score": 0,
                                });
                                Timer(const Duration(seconds: 2),() {
                                  Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  Login()));
                                });

                              }else{
                                setState(() {
                                  isLoading = false;
                                });
                              }

                            }else{
                              AlertUtil.showAlert(
                                  context, "مشكلة في الكونكسيون", "باش تنجم تعمل كونط لازم تحل الكونكسيون");
                            }


                          },
                          child: Text(
                            "حساب جديد",
                            style: TextStyle(fontSize: 30, color: ThemeHelper.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  )


                ]),
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

