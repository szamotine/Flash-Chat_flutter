import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class CustomMessageBubble extends StatelessWidget {
  const CustomMessageBubble({super.key, required this.sender, required this.text, required this.isSender, required this.timeStamp});

  final String sender;
  final String text;
  final bool isSender;
  final DateTime timeStamp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.only(
                topLeft: isSender ? const Radius.circular(30) : Radius.zero,
                bottomLeft: const Radius.circular(30),
                bottomRight: const Radius.circular(30),
                topRight: isSender ? Radius.zero : const Radius.circular(30)),
            elevation: 5.0,
            color: isSender ? Colors.lightBlueAccent : Colors.green,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: kSendButtonTextStyle,
              ),
            ),
          ),
          Text(
            sender,
            style: kChatMessageDataTextStyle.copyWith(color: isSender ? Colors.lightBlueAccent : Colors.green),
          ),
          Text(
            DateFormat(
              'yyyy-MM-dd HH:mm',
            ).format(timeStamp),
            style: kChatMessageDataTextStyle,
          ),
        ],
      ),
    );
  }
}
