import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';

class SettingsWindow extends StatefulWidget {
  @override
  _SettingsWindowState createState() => _SettingsWindowState();
}

class _SettingsWindowState extends State<SettingsWindow> {
  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.invert_colors),
              title: Text('Dark theme'),
              trailing: Switch.adaptive(
                value: _themeProvider.isDark,
                onChanged: (value) {
                  setState(() {
                    _themeProvider.isDark = value;
                    _themeProvider.goDark();
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.fingerprint),
              title: Text('Fingerprint'),
              trailing: Switch.adaptive(
                value: false,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),

//      Column(
//        children: [
//          Icon(Icons.invert_colors),
//          FlatButton(
//            child: Text('Dark theme'),
//            onPressed: () {
//              _themeChanger.goDark();
//              Navigator.of(context).pop();
//            },
//          ),
//          FlatButton(
//            child: Text('Light theme'),
//            onPressed: () {
//              _themeChanger.goLight();
//              Navigator.of(context).pop();
//            },
//          ),
//        ],
//      ),
    );
  }
}
