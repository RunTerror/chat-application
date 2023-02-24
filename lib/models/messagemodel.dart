class MessageModel {
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;
  String? messageId;

  MessageModel({
    this.createdon,
    this.seen,
    this.sender,
    this.text,
    this.messageId
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId=map["messageid"];
    sender = map["sender"];
    seen = map["seen"];
    text = map["text"];
    createdon = map["createdon"];
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "seen": seen,
      "text": text,
      "createdon": createdon,
      "messageid": messageId
    };
  }
}
