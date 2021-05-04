import '../tools/tools.dart';

class Booking {
  String firstName;
  String lastName;
  String email;
  String phone;
  String status;
  String title;
  String featuredImage;

  Booking(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.status,
      this.title,
      this.featuredImage});

  Booking.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    status = json['status'];
    title = Tools.parseHtmlString(json['title']);
    featuredImage = json['featured_image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['status'] = status;
    data['title'] = title;
    data['featured_image'] = featuredImage;
    return data;
  }
}
