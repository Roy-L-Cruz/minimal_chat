class Message {
  final int? id;
  final int senderId;
  final int receiverId;
  final String content;
  final String timestamp;

  Message({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as int,
      senderId: map['sender_id'] as int,
      receiverId: map['receiver_id'] as int,
      content: map['content'] as String,
      timestamp: map['timestamp'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'timestamp': timestamp,
    };
  }
} 