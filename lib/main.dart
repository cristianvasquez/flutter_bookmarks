import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bookmarks/app_tabs.dart';
import 'package:flutter_bookmarks/provider/theme_provider.dart';
import 'package:flutter_bookmarks/provider/user_repository.dart';
import 'package:flutter_bookmarks/services/streams.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as developer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(Main()));
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserRepository>(
      future: getUserRepository(),
      builder: (context, AsyncSnapshot<UserRepository> userRepository) {
        if (userRepository.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: userRepository.data,
              ),
              ChangeNotifierProvider.value(
                value: ThemeProvider(defaultDarkTheme, true),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter bookmarks',
              // Named Routes
              routes: {
                '/': (context) => MyTheme(
                      child: AppTabs(),
                    ),
              },
            ),
          );
        } else {
          developer.log('${userRepository.data}');
          return CircularProgressIndicator();
        }
      },
    );
  }
}

Future<T> doPushReplacement<T extends Object>(
    BuildContext context, Widget child) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => MyTheme(
              child: child,
            )),
  );
}

Future<T> doPush<T extends Object>(BuildContext context, Widget child) {
  return Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => MyTheme(
              child: child,
            )),
  );
}

class MyTheme extends StatelessWidget {
  final Widget child;

  const MyTheme({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _applicationState = Provider.of<ThemeProvider>(
      context,
      listen: true,
    );
    return AnimatedTheme(
      duration: Duration(milliseconds: 500),
      data: _applicationState.getTheme(),
      child: child,
    );
  }
}
