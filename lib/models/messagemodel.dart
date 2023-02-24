class MessageModel {
  late final String sender;
  late final String text;
  late final bool seen;
  late final DateTime createdon;

  MessageModel({
    required this.createdon,
    required this.seen,
    required this.sender,
    required this.text,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
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
    };
  }
}
