import 'package:flutter/widgets.dart';

import 'all_icons.dart';

class NamedIcon implements Comparable {
  final IconData iconData;
  final String name;

  const NamedIcon(this.iconData, this.name);

  @override
  String toString() => 'IconDefinition{iconData: $iconData, name: $name}';

  factory NamedIcon.fromMap(Map data) {
    return allIcons[int.parse(data['iconId'])];
  }

  Map<String, dynamic> toJsonMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iconId'] = '${allIcons.indexOf(this)}';
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NamedIcon &&
          runtimeType == other.runtimeType &&
          iconData == other.iconData &&
          name == other.name;

  @override
  int get hashCode => iconData.hashCode ^ name.hashCode;

  @override
  int compareTo(other) => name.compareTo(other.pane);
}
