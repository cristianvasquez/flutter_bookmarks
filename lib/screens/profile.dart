import 'package:CardFLows/services/auth.dart';
import 'package:CardFLows/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    print("Profile");
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(user.displayName ?? 'Guest'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (user.photoUrl != null)
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(user.photoUrl),
                    ),
                  ),
                ),
              Text(user.email ?? '',
                  style: Theme.of(context).textTheme.headline),
              Spacer(),
              Text(user.displayName ?? 'Guest',
                  style: Theme.of(context).textTheme.subhead),
              Spacer(),
              FlatButton(
                  child: Text('logout'),
                  onPressed: () async {
                    await auth.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }),
              Spacer(),
            ],
          ),
        ),
      );
    } else {
      return LoadingScreen();
    }
  }
}
