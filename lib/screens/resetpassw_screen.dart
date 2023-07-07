

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:thakefni/screens/signin.dart';

import '../common/alert.dart';
import '../widgets/disco_button.dart';

class Resetpassword extends StatefulWidget {
  static const routeName = '/resetpass';
  const Resetpassword({Key? key}) : super(key: key);

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> with WidgetsBindingObserver {
  InterstitialAd? interstitialAd;
  var email;
  bool isLoading = false;
  GlobalKey<FormState> formsate = new GlobalKey<FormState>();



  reset() async{
    var formdata = formsate.currentState;
    if(formdata!.validate()){
      formdata.save();

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          },
            icon:  Icon(Icons.arrow_back_ios , size: 25, color: Colors.blue,) ,),
        ),
        body: isLoading ?
        Center(
          child: Container(
            height: size.height / 15,
            width: size.width / 15,
            child: CircularProgressIndicator(),
          ),
        )
            : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                SizedBox(height: 150,),
                Text("نسيت المودباس",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                  ),),
                SizedBox(height: 20,),
                Text("أكتب الإيميل متاعك باش ترجع المودباس",style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20
                ),),
                SizedBox(height: 20,),
                Form(
                  key: formsate,
                  child: TextFormField(
                    onSaved: (val) {
                      email = val?.trim();
                    },
                    validator: (String? val) {
                      if (val!.isEmpty) {
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
                ),
                SizedBox(height: 50,),
                DiscoButton(
                  onPressed: () async{
                    setState(() {
                      isLoading = true;
                    });
                    await reset();
                    setState(() {
                      isLoading = false;
                    });
                    AlertUtil.showAlert(
                        context, "تفقد الإيميل","بعثنالك إيميل باش تبدل منو المودباس");
                    Timer(const Duration(seconds: 4),() {
                      Navigator.pushNamed(context, Login.routeName);
                    });
                  },
                  child: Text(
                    "أبعث",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  isActive: true,
                ),
              ],

            ),
          ),
        )
    );
  }
}
