import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/widgets/chat_buble.dart';
import 'package:flutter_app/widgets/constant.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser;

class Chat extends StatefulWidget {
  const Chat({super.key});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _auth = FirebaseAuth.instance;
  String messageText = "";
  final messagetextcontroler = TextEditingController();
  get builder => null;
  @override
  void initState() {
    // ignore: unused_local_variable
    String? messageText;
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getmessage() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          children: [
            Image.asset(
              'assets/imgs/scholar.png',
              height: 25,
            ),
            const SizedBox(width: 10),
            const Text('Text Hatem'),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // _auth.signOut();
                  // Navigator.pop(context);
                  //getmessage();
                  messageStream();
                },
                icon: const Icon(Icons.download),
              ),
              IconButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const mystreambulder(),
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                  color: Colors.orange,
                ))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messagetextcontroler,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          hintText: 'your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        messagetextcontroler.clear();
                        _firestore.collection("messages").add({
                          'text': messageText,
                          'sender': signedInUser.email,
                          'time' :FieldValue.serverTimestamp(),
                        });
                      },
                      child: const Text(
                        'send',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class msgline extends StatelessWidget {
  const msgline({this.txt, this.sender, required this.isMe, super.key});
  final String? txt;
  final String? sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    var choose = isMe?
          ChatBuble(message: '$txt',sender: '$sender')
         : ChatBubleForFriend(message2: '$txt', sender2: '$sender');
    return choose;
  }
}

class mystreambulder extends StatelessWidget {
  const mystreambulder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('time').snapshots(),
        builder: (context, snapshots) {
          List<msgline> widgetmessage = [];
          if (!snapshots.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final message = snapshots.data!.docs;
          for (var msg in message) {
            final messageText = msg.get('text');
            final msgSender = msg.get('sender');
            final currentuser = signedInUser.email;
            if (currentuser == msgSender) {}
            final wid = msgline(
              isMe: currentuser == msgSender,
              txt: messageText,
              sender: msgSender,
            );
            widgetmessage.add(wid);
          }
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView(
                children: widgetmessage,
              ),
            ),
          );
        });
  }
}
