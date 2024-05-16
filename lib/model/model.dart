
class Model {
  String? email  ;

  String? userName;
  String? profilePhoto;
  String? bio ;
  String? backgroundPhoto;

  Model(
      {this.email,
      this.userName,
      this.profilePhoto,
      this.bio,
      this.backgroundPhoto});

  Model.fromJson(Map<String, dynamic> json)
      : email = json['email'] ?? '',
        userName = json['userName'] ?? '',
        profilePhoto = json['profilePhoto'] ?? '',
        bio = json['bio'] ?? '',
        backgroundPhoto = json['backgroundPhoto'] ?? '';

  Map<String, dynamic> toMap() => {
        'userName': userName,
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
