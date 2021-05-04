import '../configs/app_constants.dart';
import '../tools/tools.dart';

class Conversation {
  String receiverId;
  String receiverAvatar;
  String receiverName;
  String senderId;
  String lastMessage;
  String documentId;

  Conversation.fromJson(
      Map<dynamic, dynamic> json, this.senderId, this.documentId) {
    try {
      json['users'].forEach((key, value) {
        if (value['id'] != senderId.toString()) {
          receiverId = value['id'];
          receiverAvatar = value['avatar'];
          if (receiverAvatar.isEmpty) {
            receiverAvatar = kDefaultImage;
          }
          receiverName = value['name'];
        }
      });
      lastMessage = json['lastMessage'];
    } catch (e) {
      log(e);
    }
  }
}
