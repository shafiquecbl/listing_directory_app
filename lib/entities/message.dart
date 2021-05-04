import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Message {
  String createdAt;
  String id;
  String message;
  List<dynamic> images = [];
  Message.fromJson(json) {
    Timestamp timestamp = json['createdAt'];
    createdAt = DateFormat('HH:mm').format(
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch));
    id = json['id'];
    message = json['message'];
    images = json['images'];
  }
}
