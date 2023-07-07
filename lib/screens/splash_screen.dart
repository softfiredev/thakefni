import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thakefni/screens/signin.dart';



class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  const SplashScreen({Key? key, }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  Login()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 300,),
                Center(
                  child:  Image(
                    image: AssetImage('assets/images/logowithout.png',),
                    height: 280,
                    width: 280,
                  ),
                ),
                const SizedBox(height: 170,),
                const Text('from' , style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  color: Colors.grey
                ),
                ),
                Image(
                      image: AssetImage('assets/images/logorecdrer.png'),
                  height: 50,
                  width: 150,


                    ),


              ],
            ),


          ),
        )
    );


  }
}
