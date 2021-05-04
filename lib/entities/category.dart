import '../configs/app_constants.dart';
import '../tools/tools.dart';

class Category {
  int id;
  int count;
  String description;
  String link;
  String name;
  String banner;

  Category(
      {this.id,
      this.count,
      this.description,
      this.link,
      this.name,
      this.banner});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count = json['count'];
    description = Tools.parseHtmlString(json['description']);
    link = json['link'];
    name = Tools.parseHtmlString(json['name']);
    banner = json['lp_category_banner'] ?? kDefaultImage;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['count'] = count;
    data['description'] = description;
    data['link'] = link;
    data['name'] = name;
    data['lp_category_banner'] = banner;
    return data;
  }
}
