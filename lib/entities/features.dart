import '../tools/tools.dart';

class Feature {
  int id;
  int count;
  String description;
  String link;
  String name;

  Feature({this.id, this.count, this.description, this.link, this.name});

  Feature.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count = json['count'];
    description = json['description'];
    link = json['link'];
    name = Tools.parseHtmlString(json['name']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['count'] = count;
    data['description'] = description;
    data['link'] = link;
    data['name'] = name;
    return data;
  }
}
