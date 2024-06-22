
class MessageModel {
  String? message  ;
  String ? senderUid ;
  String? receiverUid;
  String ? date ;
  String ? messageID ;
  bool ? showDelIcon ;
  String ? photo ;

  MessageModel(
      {this.message,
        this.senderUid,
        this.receiverUid,
        this.date,
        this.messageID,
        this.showDelIcon,
        this.photo
});

  MessageModel.fromJson(Map<String, dynamic> json)
      : message = json['message'] ?? '',
        senderUid = json['senderUid'] ?? '',
        receiverUid = json['receiverUid'] ?? '',
        showDelIcon = json['showDelIcon'] ?? false,
        messageID = json['messageID'] ?? '',
        date = json['date'] ?? '',
          photo = json['photo'] ?? '';

  Map<String, dynamic> toMap() => {
    'message': message,
    'senderUid': senderUid,
    'showDelIcon': showDelIcon,
    'messageID': messageID,
    'receiverUid': receiverUid,
    'date': date,
    'photo': photo
  };


}

