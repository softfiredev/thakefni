import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionOption extends StatelessWidget {
  bool isSelected;
  String text;
  String optionText;
  int index;

  QuestionOption(this.index, this.optionText, this.text,
      {Key? key, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 4),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.white),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    optionText,
                    style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
