import 'package:flutter_bookmarks/widgets/random_splash_photo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashImagePicker extends StatefulWidget {
  const SplashImagePicker({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new SplashImagePickerState();
}

class SplashImagePickerState extends State<SplashImagePicker> {
  var _searchTerm = "";
  var _isSearching = false;
  Map<String, Uri> visitedUrls = {};

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return new Scaffold(
      appBar: _isSearching ? _searchBar(context) : _titleBar(),
      body: new GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 3 : 6,
          ),
          itemBuilder: (context, index) {
            var photo = RandomSplashPhoto(
              index: index,
              visitedUrls: visitedUrls,
              queryString: _searchTerm,
            );

            return new InkWell(
              onTap: () {
                if (photo.splashImage != null) {
                  Navigator.of(context).pop(photo.splashImage);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  photo,
                ],
              ),
            );
          }),
    );
  }

  AppBar _titleBar() {
    return new AppBar(
      title: new Text("Pick an image"),
      actions: [
        new IconButton(
            icon: new Icon(FontAwesomeIcons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            })
      ],
    );
  }

  AppBar _searchBar(BuildContext context) {
    return new AppBar(
      leading: new IconButton(
        icon: new Icon(FontAwesomeIcons.arrowLeft),
        onPressed: () {
          setState(
            () {
              Navigator.pop(context);
              _isSearching = false;
              _searchTerm = "";
            },
          );
        },
      ),
      title: new TextField(
        onChanged: (text) => setState(() => _searchTerm = text),
        autofocus: true,
        style: new TextStyle(fontSize: 18.0),
        decoration: new InputDecoration(border: InputBorder.none),
      ),
    );
  }
}
