import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/common_input.dart';
import '../../../entities/conversation.dart';
import '../../../models/authentication_model.dart';
import '../../../services/api_service.dart';
import '../../../tools/tools.dart';

class MessageInput extends StatefulWidget {
  final Conversation conversation;

  const MessageInput({Key key, this.conversation}) : super(key: key);
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  var _assets = [];

  void _onSubmitMessage() async {
    if (_controller.text.trim().isEmpty && _assets.isEmpty) {
      return;
    }

    var data = {
      'id': widget.conversation.senderId,
      'createdAt': Timestamp.now(),
      'message': _controller.text,
      'images': []
    };

    var gallery = [];
    if (_assets.isNotEmpty) {
      for (var img in _assets) {
        var byteData = await img.getByteData(quality: 100);
        var bytes = byteData.buffer.asUint8List();
        var unit = await Tools.compressList(list: bytes);
        gallery.add(base64Encode(unit));
      }
    }

    _controller.clear();
    _assets.clear();
    FocusScope.of(context).unfocus();
    setState(() {});
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    await ApiServices().submitMessage(
        data: data,
        images64: gallery,
        user: user,
        conversationId: widget.conversation.documentId);
  }

  Future<void> pickImages() async {
    try {
      var list =
          await MultiImagePicker.pickImages(maxImages: 5, enableCamera: true);
      _assets = list;
      setState(() {});
    } on Exception {
      _assets = _assets;
    }
  }

  void _removeImage(int index) {
    _assets.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_assets.isNotEmpty)
            Container(
              height: 100.0,
              margin: const EdgeInsets.only(bottom: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                      _assets.length,
                      (index) => Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            width: 80,
                            height: 100,
                            child: Stack(
                              children: [
                                AssetThumb(
                                    asset: _assets[index],
                                    width: 80,
                                    height: 100),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () => _removeImage(index),
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ),
                                    )),
                              ],
                            ),
                          )),
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: CommonInput(
                  onSubmitted: (message) => _onSubmitMessage(),
                  controller: _controller,
                ),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                  onTap: pickImages,
                  child: const Icon(Icons.camera_alt_outlined)),
              const SizedBox(width: 10.0),
              InkWell(onTap: _onSubmitMessage, child: const Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
