class ConversationModel {
  String? id;
  String? lastMessage;
  int? lastTime;
  List<String>? participants;
  
  // Store participant names and images for faster retrieval in chat list
  String? id1Name;
  String? id1Image;
  String? id2Name;
  String? id2Image;

  ConversationModel({
    this.id,
    this.lastMessage,
    this.lastTime,
    this.participants,
    this.id1Name,
    this.id1Image,
    this.id2Name,
    this.id2Image,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "lastMessage": lastMessage,
      "lastTime": lastTime ?? DateTime.now().millisecondsSinceEpoch,
      "participants": participants,
      "id1Name": id1Name,
      "id1Image": id1Image,
      "id2Name": id2Name,
      "id2Image": id2Image,
    };
  }

  ConversationModel.fromJson(Map<String, dynamic>? json, String? docId) {
    if (json == null) return;
    id = docId;
    lastMessage = json['lastMessage'];
    lastTime = json['lastTime'];
    participants = List<String>.from(json['participants'] ?? []);
    id1Name = json['id1Name'];
    id1Image = json['id1Image'];
    id2Name = json['id2Name'];
    id2Image = json['id2Image'];
  }

  // Get other person's name based on current user's ID
  String getOtherName(String currentUserId) {
    if (participants == null || participants!.length < 2) return "Unknown";
    return participants![0] == currentUserId ? (id2Name ?? "") : (id1Name ?? "");
  }

  // Get other person's ID based on current user's ID
  String getOtherId(String currentUserId) {
    if (participants == null || participants!.length < 2) return "";
    return participants![0] == currentUserId ? participants![1] : participants![0];
  }
}
