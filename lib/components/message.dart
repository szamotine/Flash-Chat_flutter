import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String sender;
  final Timestamp timeStamp;
  late DateTime dateTime;
  late String messageTimeStamp;

  Message({required this.message, required this.sender, required this.timeStamp});
}
