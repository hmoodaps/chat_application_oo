
class Model {
  String? email  ;
  String ? uid ;
  String? userName;
  String ? name ;
  String? profilePhoto;
  String? bio ;
  String? backgroundPhoto;

  Model(
      {this.email,
      //this.userName,
      this.profilePhoto,
      this.bio,
      this.name,
      this.uid,
      this.backgroundPhoto});

  Model.fromJson(Map<String, dynamic> json)
      : email = json['email'] ?? '',
      //  userName = json['userName'] ?? '',
        uid = json['uid'] ?? '',
        name = json['name'] ?? '',
        profilePhoto = json['profilePhoto'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXksdu3aWAj1aBuoU5l7yOPx7SMr3Ee7HnAp7u4-TaJg&s',
        bio = json['bio'] ?? 'Write Your Bio ..',
        backgroundPhoto = json['backgroundPhoto'] ??  'https://lectera.com/info/storage/img/20210805/fa586bb6c04bf0989d70_808xFull.jpg';

  Map<String, dynamic> toMap() => {
       // 'userName': userName,
        'uid': uid,
        'name': name,
        'email': email,
        'profilePhoto': profilePhoto,
        'bio': bio ,
        'backgroundPhoto': backgroundPhoto,
      };


}
