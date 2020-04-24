class WidgetSetup {
  final int id;
  final type;
  String value;

  WidgetSetup(this.id, this.type, {this.value});

  factory WidgetSetup.fromJson(Map<String, dynamic> json) {
    return WidgetSetup(
      json['id'],
      json['type'],
      value: "${json['value']}",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
