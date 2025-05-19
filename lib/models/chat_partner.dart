class ChatPartner {
  final int id;
  final String username;
  final String? lastMessage;
  final String? lastTimestamp;

  ChatPartner({
    required this.id,
    required this.username,
    this.lastMessage,
    this.lastTimestamp,
  });

  factory ChatPartner.fromMap(Map<String, dynamic> map) {
    return ChatPartner(
      id: map['id'] as int,
      username: map['username'] as String,
      lastMessage: map['last_message'] as String?,
      lastTimestamp: map['last_timestamp'] as String?,
    );
  }
} 