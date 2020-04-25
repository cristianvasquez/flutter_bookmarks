import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark;
  ThemeData _themeData;

  ThemeProvider(this._themeData, this.isDark);

  getTheme() {
    return _themeData;
  }

  _setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  goDark() {
    isDark = true;
    _setTheme(defaultDarkTheme);
  }

  goLight() {
    isDark = false;
    _setTheme(defaultLightTheme);
  }
}

final ThemeData defaultLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Raleway',
);
final ThemeData defaultDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Raleway',
);
