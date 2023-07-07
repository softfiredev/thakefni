import 'package:flutter/material.dart';

class ThemeHelper {
  static Color primaryColor = Color(0xff29b6f6);
  static Color accentColor = Color(0xff20aebe);
  static Color shadowColor = Color(0xffa2a6af);

  static ThemeData getThemeData() {
    return ThemeData(
      fontFamily: 'Baloo',
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.light(primary: Colors.blue, secondary: Colors.teal),
      textTheme: TextTheme(
          headline3: TextStyle(
            color: accentColor,
            fontFamily: 'Baloo',
          ),
          headline4: TextStyle(
            color: accentColor,
            fontFamily: 'Baloo',
          )),
    );
  }

  static BoxDecoration fullScreenBgBoxDecoration(
      {String backgroundAssetImage = "assets/images/Common.bg.png"}) {
    return BoxDecoration(
      image: DecorationImage(image: AssetImage(backgroundAssetImage), fit: BoxFit.cover),
    );
  }

  static roundBoxDeco({Color color = Colors.white, double radius = 15}) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(radius)));
  }
}
