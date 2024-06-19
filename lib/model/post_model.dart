import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? postId;
  String? uid;
  String? photo;
  String? text;
  DateTime? dateTime;
  List<String>? likesUserIds; // قائمة بمعرفات المستخدمين الذين قاموا بالإعجاب

  PostModel({
    this.postId,
    this.uid,
    this.photo,
    this.dateTime,
    this.text,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      uid: json['uid'],
      photo: json['photo'],
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      text: json['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'photo': photo,
      'dateTime': dateTime != null ? Timestamp.fromDate(dateTime!) : null,
      'text': text,
    };
  }
}
