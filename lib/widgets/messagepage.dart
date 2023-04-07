import 'dart:io';

import 'package:flutter/material.dart';
import 'package:payment/models/global.dart';
import 'package:payment/bloc/blocs/user_bloc_provider.dart';
import 'package:payment/bloc/resources/repository.dart';
import 'package:payment/bloc/resources/message socket.dart';
import 'package:payment/bloc/resources/message socket exit.dart';


class ChatScreen extends StatefulWidget {
  String subtaskKey;
  ChatScreen({required this.subtaskKey});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  late String loggedInUser;
  late String messageText;
  message_StreamSocket socket= message_StreamSocket();
  messageExitSocket exitSocket = messageExitSocket();
  //late messageBloc message;

  @override
  void initState() {
    //message =messageBloc(widget.subtaskKey);
    super.initState();
    getCurrentUser();
    //socket.openingapprovalconnectAndListen(widget.subtaskKey);
  }

  void dispose() {
    super.dispose();
    print('dispose messagepage');
    exitSocket.Stopthread();
  }

  void getCurrentUser() async {
    try {
      final user = userBloc.getUserObject();
      if (user != null) {
        loggedInUser = user.username;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(loggedInUser: loggedInUser, data:socket),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                      ),
                  ),

                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      //message.addmessage(messageText, loggedInUser);
                      //repository.send_message(messageText, loggedInUser,widget.subtaskKey);
                    },
                    child: Text(
                      'send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
  }
}

class MessagesStream extends StatelessWidget {
  final String loggedInUser;
  final  message_StreamSocket data;
  late List<dynamic> messages;


  MessagesStream({required this.loggedInUser, required this.data});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: data.getResponse,
      initialData: [],
      builder: (context,  AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
        List<MessageBubble> messageBubbles = [];
        messages = snapshot.data as List<dynamic>;
        if (messages.isEmpty) {
          return Center(
            child: Container(
              color: Colors.white,
            ),
          );
        }
        messageBubbles = messages.map((var message){
          final messageText = message['message'];
          final messageSender = message['sender'];
          final currenttime = message['time_created'];
          final currentUser = loggedInUser;

          return MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
            timeCreated: currenttime,
          );
        }).toList();


        return
            ListView(
              physics: NeverScrollableScrollPhysics(), ///
              shrinkWrap: true, ///
              scrollDirection: Axis.vertical,
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,

            );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe, required this.timeCreated});

  final String sender;
  final String text;
  final bool isMe;
  final String timeCreated;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender.toUpperCase(),
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5.0),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          SizedBox(height:5.0),
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Text(
                timeCreated.substring(0,10),
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.black,
                ),
              ),
          ),

          //
        ],
      ),
    );
  }
}