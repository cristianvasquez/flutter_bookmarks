import 'package:CardFLows/screens/board_screen.dart';
import 'package:CardFLows/screens/home_screen.dart';
import 'package:CardFLows/screens/profile.dart';
import 'package:CardFLows/screens/settings/left_drawer.dart';
import 'package:CardFLows/screens/timeline_screen.dart';
import 'package:CardFLows/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

const int INITIAL_TAB = 1;

class AppTabs extends StatefulWidget {
  const AppTabs({
    Key key,
  }) : super(key: key);

  @override
  _AppTabsState createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {
  final pageController = PageController(initialPage: INITIAL_TAB);

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    print("Building tabs");

    return DefaultTabController(
        initialIndex: INITIAL_TAB,
        length: 3,
        child: Scaffold(
          drawer: SettingsDrawer(),
          appBar: AppBar(
            title: Text("CardFlows"),
            bottom: TabBar(
              tabs: const [
                // Alternative material icons:
                // Icon(Icons.dashboard))
                // Icon(Icons.view_agenda))
                // @TODO look at the Icon's semantic annotations
                const Tab(icon: const Icon(FontAwesomeIcons.layerGroup)),
                const Tab(icon: const Icon(FontAwesomeIcons.gripHorizontal)),
                const Tab(icon: const Icon(FontAwesomeIcons.stream)),
              ],
            ),
            actions: <Widget>[
              AvatarButton(),
            ],
          ),
          body: TabBarView(
            children: [
              BoardsScreen(),
              HomeScreen(),
              TimelineScreen(),
            ],
          ),
        ));
  }
}

class AvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showProfile() {
      showModalBottomSheet(
          context: context,
          builder: (context) => Container(
                child: ProfileScreen(),
              ));
    }

    var user = Provider.of<FirebaseUser>(context);
    if (user == null) {
      return NOTHING;
    }
    if (user.photoUrl != null) {
      return InkWell(
        onTap: showProfile,
        child: CircleAvatar(
          maxRadius: 30,
          minRadius: 20,
          backgroundImage: NetworkImage(user.photoUrl),
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: showProfile,
      );
    }
  }
}
