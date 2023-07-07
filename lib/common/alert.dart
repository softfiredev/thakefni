import 'package:flutter/material.dart';

class AlertUtil {
  static void showAlert(BuildContext context, String title, String message,
      {String buttonText = "مريقل"}) {
    var alert = AlertDialog(
      title:Align(
        alignment: Alignment.center,
        child:  Text(title,style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
      ),

      content: Text(message, style:const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0
      ) ,),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(buttonText)),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Alertreward {
  static void showAlert(BuildContext context, String title, String message1,String message2,String message3,String message4,String message5,String message6,String message7,String message8,String message9,String message10,
      {String buttonText = "مريقل"}) {
    var alert = AlertDialog(
      scrollable: true,
      backgroundColor: Colors.white,
      title:Align(
        alignment: Alignment.center,
        child:  Text(title,style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
      ),

      content: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(message1, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),
              Text(message2, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),
              Text(message3, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),
              Text(message4, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),
              Text(message5, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),
              Text(message6, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),
              Text(message7, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),
              Text(message8, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),
              Text(message9, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),
              Text(message10, style:const TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.0
              ) ,),

            ],
          )
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(buttonText)),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


class Alert {
  static void showAlert(BuildContext context, String title, String message) {
    var alert = AlertDialog(
      title:Align(
        alignment: Alignment.center,
        child:  Text(title,style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
      ),

      content: Text(message, style:const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0
      ) ,),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
