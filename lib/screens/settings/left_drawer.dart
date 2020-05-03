import 'package:flutter_bookmarks/main.dart';
import 'package:flutter_bookmarks/widgets/pickers/icon_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'debug_window.dart';
import 'settings_window.dart';

class SettingsDrawer extends StatelessWidget {
  Widget buildListTile(String title, Function tapHandler) {
    return ListTile(
      title: Text(
        title,
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text("Debug"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              doPush(context, SettingsWindow());
            },
          ),
          ListTile(
            leading: Icon(Icons.perm_data_setting),
            title: Text('Current Data'),
            onTap: () {
              Navigator.of(context).pop();
              doPush(context, DebugWindow());
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.icons),
            title: Text('Icons'),
            onTap: () {
              Navigator.of(context).pop();
              doPush(context, IconPicker());
            },
          ),
        ],
      ),
    );
  }
}
