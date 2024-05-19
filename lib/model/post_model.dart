
class PostModel {
  String ? uid ;
  String? userName;
  String? photo;
  String ? text ;


  PostModel(
      {this.uid,
        this.userName,
        this.photo,
        this.text});

  PostModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] ?? '',
        userName = json['userName'] ?? '',
        photo = json['photo'] ?? '',
        text = json['text'] ?? '';

  Map<String, dynamic> toMap() => {
    'userName': userName,
    'uid': uid,
    'photo': photo,
    'text': text ,
  };

}
