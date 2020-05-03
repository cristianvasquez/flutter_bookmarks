import 'dart:convert';

import 'package:flutter_bookmarks/provider/user_repository.dart';
import 'package:flutter_bookmarks/widgets/buttons.dart';
import 'package:flutter_bookmarks/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:provider/provider.dart';

class DebugWindow extends StatefulWidget {
  @override
  _DebugWindowState createState() => _DebugWindowState();
}

class _DebugWindowState extends State<DebugWindow> {
  @override
  Widget build(BuildContext context) {
    UserRepository services = Provider.of<UserRepository>(context);

    getPrettyPrint(Map<String, dynamic> json) {
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    }

    getFancyJson(json) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: SyntaxView(
              code: getPrettyPrint(json),
              syntax: Syntax.JAVASCRIPT,
              withLinesCount: false,
              syntaxTheme: SyntaxTheme.standard(),
            ),
          ),
        ],
      );
    }

    buildWorkspaceContents() {
      return (services.workspace == null)
          ? Center(
              child: Text("No workspace found"),
            )
          : getFancyJson(services.workspace.toJsonMap());
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.library_books)),
              Tab(icon: Icon(Icons.warning)),
            ],
          ),
          title: Text('Debug'),
        ),
        body: TabBarView(
          children: [
            buildWorkspaceContents(),
            Center(child: _ResetToDefaultButton())
          ],
        ),
      ),
    );
  }
}

class _ResetToDefaultButton extends StatefulWidget {
  @override
  __ResetToDefaultButtonState createState() => __ResetToDefaultButtonState();
}

class __ResetToDefaultButtonState extends State<_ResetToDefaultButton> {
  @override
  Widget build(BuildContext context) {
    UserRepository services = Provider.of<UserRepository>(context);

    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        "Reset to defaults",
      ),
      onPressed: () async {
        bool showSnack = await showDialog(
          context: context,
          builder: (context) => RoundedAlertDialog(
            title: 'Do you really want to reset to default values?',
            actions: <Widget>[
              FlatRoundButton(
                  text: 'Yes',
                  onTap: () async {
                    await services.setDefaults();
                    setState(() {
                      Navigator.pop(context, true);
                    });
                  }),
              FlatRoundButton(
                text: 'No',
                onTap: () => Navigator.pop(context, false),
              ),
            ],
          ),
        );
        if (showSnack) {
          final snackBar = SnackBar(
            content: Text('Reset to defaults applied'),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    );
    ;
  }
}
