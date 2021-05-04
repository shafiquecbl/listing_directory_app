class Location {
  int id;
  int count;
  String description;
  String link;
  String name;

  Location({this.id, this.count, this.description, this.link, this.name});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count = json['count'];
    description = json['description'];
    link = json['link'];
    name = json['name'];
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
