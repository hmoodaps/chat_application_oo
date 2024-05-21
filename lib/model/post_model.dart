
class PostModel {
  String ? uid ;
  String? userName;
  String? profilePhoto;
  String? photo;
  String ? text ;


  PostModel(
      {this.uid,
        this.userName,
        this.profilePhoto,
        this.photo,
        this.text});

  PostModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] ?? '',
        userName = json['userName'] ?? '',
        profilePhoto = json['profilePhoto'] ?? '',
        photo = json['photo'] ?? '',
        text = json['text'] ?? '';

  Map<String, dynamic> toMap() => {
    'userName': userName,
    'uid': uid,
    'profilePhoto': profilePhoto,
    'photo': photo,
    'text': text ,
  };

}
