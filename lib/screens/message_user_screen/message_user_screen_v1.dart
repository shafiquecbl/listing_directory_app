import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../entities/conversation.dart';
import '../../entities/message.dart';
import '../../models/authentication_model.dart';
import 'widgets/message_input.dart';
import 'widgets/receiver_message.dart';
import 'widgets/sender_message.dart';

class MessageUserScreenV1 extends StatefulWidget {
  final Conversation conversation;

  final String userName;
  final String avatar;
  final String authorId;
  final String authorName;
  final String authorAvatar;

  const MessageUserScreenV1(
      {Key key,
      this.conversation,
      this.authorId,
      this.userName,
      this.avatar,
      this.authorName,
      this.authorAvatar})
      : super(key: key);
  @override
  _MessageUserScreenV1State createState() => _MessageUserScreenV1State();
}

class _MessageUserScreenV1State extends State<MessageUserScreenV1> {
  final _fireStore = FirebaseFirestore.instance;
  int perPage = 5;
  bool isOutOfMessages = false;
  final RefreshController _refreshController = RefreshController();
  var _conversation;
  Widget _buildConversation() {
    final theme = Theme.of(context);
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.conversation.receiverName,
          style: theme.textTheme.headline6,
        ),
        centerTitle: true,
        brightness: theme.brightness,
        backgroundColor: theme.backgroundColor,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _fireStore
                    .collection('conversations')
                    .doc(widget.conversation.documentId)
                    .collection('messages')
                    .orderBy('createdAt', descending: true)
                    .limit(perPage)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    var messages = [];
                    snapshot.data.docs.forEach((document) =>
                        messages.add(Message.fromJson(document.data())));
                    if (messages.length < perPage) {
                      isOutOfMessages = true;
                    }
                    return SmartRefresher(
                      controller: _refreshController,
                      onLoading: () {
                        if (!isOutOfMessages) {
                          perPage += perPage;

                          _refreshController.loadComplete();
                        } else {
                          _refreshController.loadNoData();
                        }
                        setState(() {});
                      },
                      enablePullDown: false,
                      enablePullUp: true,
                      child: ListView.builder(
                        reverse: true,
                        itemBuilder: (context, index) {
                          if (messages[index].id == user.id.toString()) {
                            return SenderMessage(
                                message: messages[index].message,
                                time: messages[index].createdAt,
                                images: messages[index].images);
                          }
                          return ReceiverMessage(
                            message: messages[index].message,
                            receiverAvatar: widget.conversation.receiverAvatar,
                            time: messages[index].createdAt,
                            images: messages[index].images,
                          );
                        },
                        itemCount: messages.length,
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            MessageInput(
              conversation: widget.conversation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationWithId() {
    final theme = Theme.of(context);
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          _conversation?.receiverName ?? widget.authorName,
          style: theme.textTheme.headline6,
        ),
        centerTitle: true,
        brightness: theme.brightness,
        backgroundColor: theme.backgroundColor,
      ),
      body: _conversation == null
          ? Container()
          : Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: _fireStore
                          .collection('conversations')
                          .doc(_conversation.documentId)
                          .collection('messages')
                          .orderBy('createdAt', descending: true)
                          .limit(perPage)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          var messages = [];
                          snapshot.data.docs.forEach((document) =>
                              messages.add(Message.fromJson(document.data())));
                          if (messages.length < perPage) {
                            isOutOfMessages = true;
                          }
                          return SmartRefresher(
                            controller: _refreshController,
                            onLoading: () {
                              if (!isOutOfMessages) {
                                perPage += perPage;

                                _refreshController.loadComplete();
                              } else {
                                _refreshController.loadNoData();
                              }
                              setState(() {});
                            },
                            enablePullDown: false,
                            enablePullUp: true,
                            child: ListView.builder(
                              reverse: true,
                              itemBuilder: (context, index) {
                                if (messages[index].id == user.id.toString()) {
                                  return SenderMessage(
                                      message: messages[index].message,
                                      time: messages[index].createdAt,
                                      images: messages[index].images);
                                }
                                return ReceiverMessage(
                                  message: messages[index].message,
                                  receiverAvatar: _conversation.receiverAvatar,
                                  time: messages[index].createdAt,
                                  images: messages[index].images,
                                );
                              },
                              itemCount: messages.length,
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  MessageInput(
                    conversation: _conversation,
                  ),
                ],
              ),
            ),
    );
  }

  void _findConversation() async {
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    var list = await _fireStore
        .collection('conversations')
        .where('users.user${user.id}.id', isEqualTo: '${user.id}')
        .where('users.user${widget.authorId}.id',
            isEqualTo: '${widget.authorId}')
        .get();
    if (list.docs.isEmpty) {
      ///Create new conversation
      final data = {
        'createdAt': Timestamp.now(),
        'lastMessage': '',
        'users': {
          'user${user.id}': {
            'id': user.id.toString(),
            'name': user.displayName,
            'avatar': user.avatar,
          },
          'user${widget.authorId}': {
            'id': widget.authorId,
            'name': widget.authorName,
            'avatar': widget.authorAvatar,
          },
        }
      };

      await _fireStore.collection('conversations').add(data).then((value) {
        _conversation =
            Conversation.fromJson(data, user.id.toString(), value.id);
        setState(() {});
      });
    } else {
      _conversation = Conversation.fromJson(
          list.docs.first.data(), user.id.toString(), list.docs.first.id);
      setState(() {});
    }
  }

  @override
  void initState() {
    if (widget.conversation == null) {
      _findConversation();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.conversation != null) {
      return _buildConversation();
    }
    return _buildConversationWithId();
  }
}
