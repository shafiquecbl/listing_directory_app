import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/conversation.dart';
import '../../models/authentication_model.dart';
import '../authentication_screen/login_screen.dart';
import 'widgets/message_item.dart';

class MessagesScreenV1 extends StatefulWidget {
  @override
  _MessagesScreenV1State createState() => _MessagesScreenV1State();
}

class _MessagesScreenV1State extends State<MessagesScreenV1>
    with AutomaticKeepAliveClientMixin<MessagesScreenV1> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   final user =
    //       Provider.of<AuthenticationModel>(context, listen: false).user;
    //   Provider.of<MessagesModel>(context, listen: false)
    //       .getConversations(user.email);
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'chatScreen'.tr(),
          style: theme.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: theme.backgroundColor,
        brightness: theme.brightness,
        iconTheme: theme.iconTheme,
      ),
      body: Consumer<AuthenticationModel>(
        builder: (_, model, __) {
          if (model.state == AuthenticationState.notLogin ||
              model.state == AuthenticationState.loading) {
            return Container(
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: theme.accentColor),
                  child: Text('login'.tr()),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                ),
              ),
            );
          }
          return StreamBuilder(
            stream: _fireStore
                .collection('conversations')
                .where('users.user${model.user.id}.id',
                    isEqualTo: '${model.user.id}')
                .limit(10)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                var conversations = [];
                snapshot.data.docs.forEach((document) => conversations.add(
                    Conversation.fromJson(document.data(),
                        model.user.id.toString(), document.id)));
                return ListView.builder(
                  itemBuilder: (context, index) => MessageItem(
                    conversation: conversations[index],
                  ),
                  itemCount: conversations.length,
                );
              }
              return Container();
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
