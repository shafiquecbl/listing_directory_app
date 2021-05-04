import '../tools/tools.dart';
import 'export.dart';

class SuggestedSearch {
  String tagID;
  Suggestions suggestions;

  SuggestedSearch({this.tagID, this.suggestions});

  SuggestedSearch.fromJson(Map<String, dynamic> json) {
    tagID = json['tagID'];
    suggestions = json['suggestions'] != null
        ? Suggestions.fromJson(json['suggestions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tagID'] = tagID;
    if (suggestions != null) {
      data['suggestions'] = suggestions.toJson();
    }
    return data;
  }
}

class Suggestions {
  List<Tag> tags;
  List<Tag> cats;
  List<TagsNCats> tagsNCats;
  List<Titles> titles;
  String more;
  int matches;

  Suggestions(
      {this.tags,
      this.cats,
      this.tagsNCats,
      this.titles,
      this.more,
      this.matches});

  Suggestions.fromJson(Map<String, dynamic> json) {
    if (json['tag'] != null) {
      tags = <Tag>[];
      json['tag'].forEach((v) {
        tags.add(Tag.fromJson(v));
      });
    }
    if (json['cats'] != null) {
      cats = <Tag>[];
      json['cats'].forEach((v) {
        cats.add(Tag.fromJson(v));
      });
    }
    if (json['tagsncats'] != null) {
      tagsNCats = <TagsNCats>[];
      json['tagsncats'].forEach((v) {
        tagsNCats.add(TagsNCats.fromJson(v));
      });
    }
    if (json['titles'] != null) {
      titles = <Titles>[];
      json['titles'].forEach((v) {
        titles.add(Titles.fromJson(v));
      });
    }
    more = json['more'];
    matches = json['matches'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (tags != null) {
      data['tag'] = tags.map((v) => v.toJson()).toList();
    }
    if (cats != null) {
      data['cats'] = cats.map((v) => v.toJson()).toList();
    }
    if (tagsNCats != null) {
      data['tagsncats'] = tagsNCats.map((v) => v.toJson()).toList();
    }
    if (titles != null) {
      data['titles'] = titles.map((v) => v.toJson()).toList();
    }
    data['more'] = more;
    data['matches'] = matches;
    return data;
  }
}

class Tag {
  int termId;
  String name;
  String icon;

  Tag({this.termId, this.name, this.icon});

  Tag.fromJson(Map<String, dynamic> json) {
    try {
      termId = json['term_id'];
      name = Tools.parseHtmlString(json['name']);

      icon = json['icon'];
    } catch (e) {
      log('$name $e');
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['term_id'] = termId;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}

class TagsNCats {
  int tagTermId;
  int catTermId;
  String catIcon;
  String tagName;
  String catName;

  TagsNCats(
      {this.tagTermId,
      this.catTermId,
      this.catIcon,
      this.tagName,
      this.catName});

  TagsNCats.fromJson(Map<String, dynamic> json) {
    try {
      tagTermId = json['tag_term_id'];
      catTermId = json['cat_term_id'];
      catIcon = json['cat_icon'];
      tagName = Tools.parseHtmlString(json['tag_name']);
      catName = Tools.parseHtmlString(json['cat_name']);
    } catch (e) {
      log('$tagName-$catName $e');
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tag_term_id'] = tagTermId;
    data['cat_term_id'] = catTermId;
    data['cat_icon'] = catIcon;
    data['tag_name'] = tagName;
    data['cat_name'] = catName;
    return data;
  }
}

class Titles {
  int termId;
  String name;
  String icon;
  String location;
  Listing listing;

  Titles({this.termId, this.name, this.icon, this.location, this.listing});

  Titles.fromJson(Map<String, dynamic> json) {
    try {
      termId = json['term_id'];
      name = Tools.parseHtmlString(json['name']);
      icon = json['icon'];
      location = json['location'];
      listing = Listing.fromJson(json['listing']);
    } catch (e) {
      log('$name ss $e');
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['term_id'] = termId;
    data['name'] = name;
    data['icon'] = icon;
    data['location'] = location;
    data['listing'] = listing.toJson();
    return data;
  }
}
