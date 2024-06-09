
class MessageModel {
  String? message  ;
  String ? senderUid ;
  String? receiverUid;
  String ? date ;

  MessageModel(
      {this.message,
        this.senderUid,
        this.receiverUid,
        this.date,
});

  MessageModel.fromJson(Map<String, dynamic> json)
      : message = json['message'] ?? '',
        senderUid = json['senderUid'] ?? '',
        receiverUid = json['receiverUid'] ?? '',
        date = json['date'] ?? '';

  Map<String, dynamic> toMap() => {
    'message': message,
    'senderUid': senderUid,
    'receiverUid': receiverUid,
    'date': date,
  };


}
