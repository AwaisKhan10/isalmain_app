class MessageModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? content;
  int? time;
  String? chatId;

  MessageModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.content,
      this.time,
      this.chatId});

  toJson() {
    return {
      "id": id,
      "senderId": senderId,
      "receiverId": receiverId,
      "content": content,
      "time": time ?? DateTime.now().millisecondsSinceEpoch,
      "chatId": chatId,
    };
  }

  MessageModel.fromJson(Map<String, dynamic>? json, String? docId) {
    if (json == null) return;
    id = docId;
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    content = json['content'];
    time = json['time'];
    chatId = json['chatId'];
  }
}
