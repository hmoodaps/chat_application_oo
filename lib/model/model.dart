
class Model {
  String? email  ;
  String ? uid ;
  String? userName;
  String? profilePhoto;
  String? bio ;
  String? backgroundPhoto;

  Model(
      {this.email,
      this.userName,
      this.profilePhoto,
      this.bio,
      this.uid,
      this.backgroundPhoto});

  Model.fromJson(Map<String, dynamic> json)
      : email = json['email'] ?? '',
        userName = json['userName'] ?? '',
        uid = json['uid'] ?? '',
        profilePhoto = json['profilePhoto'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXksdu3aWAj1aBuoU5l7yOPx7SMr3Ee7HnAp7u4-TaJg&s',
        bio = json['bio'] ?? 'Write Your Bio ..',
        backgroundPhoto = json['backgroundPhoto'] ??  'https://lectera.com/info/storage/img/20210805/fa586bb6c04bf0989d70_808xFull.jpg';

  Map<String, dynamic> toMap() => {
        'userName': userName,
        'uid': uid,
        'email': email,
        'profilePhoto': profilePhoto,
        'bio': bio ,
        'backgroundPhoto': backgroundPhoto,
      };

  // factory Model.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
  //   final data = document.data()!;
  //   return Model(
  //       email: data['email'],
  //       userName: data['userName'],
  //       profilePhoto: data['profilePhoto'],
  //       bio: data['bio'],
  //       backgroundPhoto: data['backgroundPhoto']);
  // }
}
