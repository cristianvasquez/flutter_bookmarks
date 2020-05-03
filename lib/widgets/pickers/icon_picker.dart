import 'package:flutter_bookmarks/model/icons/all_icons.dart';
import 'package:flutter_bookmarks/model/icons/named_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconPicker extends StatefulWidget {
  final bool showText;
  final NamedIcon selectedIcon;

  const IconPicker({
    Key key,
    this.showText = false,
    this.selectedIcon,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new IconPickerState();
}

class IconPickerState extends State<IconPicker> {
  var _searchTerm = "";
  var _isSearching = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final filteredIcons = allIcons
        .where((icon) =>
            _searchTerm.isEmpty ||
            icon.name.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();
    final orientation = MediaQuery.of(context).orientation;

    return new Scaffold(
      appBar: _isSearching ? _searchBar(context) : _titleBar(),
      body: new GridView.builder(
          itemCount: filteredIcons.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 6 : 6,
          ),
          itemBuilder: (context, index) {
            final icon = filteredIcons[index];

            return new InkWell(
              onTap: () {
                print('Popping ${icon.name}');
                Navigator.of(context).pop(icon);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon.iconData,
                    color: (icon == widget.selectedIcon)
                        ? theme.accentColor
                        : theme.iconTheme.color,
                    size: (icon == widget.selectedIcon)
                        ? 50
                        : theme.iconTheme.size,
                  ),
                  if (widget.showText)
                    Container(
                      padding: new EdgeInsets.only(top: 16.0),
                      child: new Text(icon.name),
                    ),
                ],
              ),
            );
          }),
    );
  }

  AppBar _titleBar() {
    return new AppBar(
      title: new Text("Pick an icon"),
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
        style: new TextStyle(fontSize: 18.0),
        autofocus: true,
        decoration: new InputDecoration(border: InputBorder.none),
      ),
    );
  }
}
