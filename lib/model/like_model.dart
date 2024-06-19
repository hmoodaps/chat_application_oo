import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  String? userId; // معرف المستخدم الذي قام باللايك
  String? postId; // معرف البوست الذي تم إعطاء اللايك له

  LikeModel({
    this.userId,
    this.postId,
  });

  // تحويل من Map إلى LikeModel
  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      userId: map['userId'],
      postId: map['postId'],
    );
  }

  // تحويل من LikeModel إلى Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'postId': postId,
    };
  }
}
