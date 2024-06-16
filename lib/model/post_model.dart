import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? uid;
  String? userName;
  String? profilePhoto;
  String? photo;
  String? text;
  DateTime? dateTime; // تحديد نوع DateTime

  PostModel({
    this.uid,
    this.userName,
    this.profilePhoto,
    this.photo,
    this.dateTime,
    this.text,
  });

  // تحويل من JSON إلى نموذج
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      uid: json['uid'],
      userName: json['userName'],
      profilePhoto: json['profilePhoto'],
      photo: json['photo'],
      dateTime: (json['dateTime'] as Timestamp).toDate(), // تحويل Timestamp إلى DateTime هنا
      text: json['text'],
    );
  }

  // تحويل إلى Map للتخزين في Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'profilePhoto': profilePhoto,
      'photo': photo,
      'dateTime': dateTime != null ? Timestamp.fromDate(dateTime!) : null, // تحويل DateTime إلى Timestamp هنا
      'text': text,
    };
  }
}
