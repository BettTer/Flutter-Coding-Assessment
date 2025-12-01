class SingleMessage {
  final String id;
  final String text;
  final bool isFromMe;
  final DateTime timestamp;

  const SingleMessage({
    required this.id,
    required this.text,
    required this.isFromMe,
    required this.timestamp,
  });

  factory SingleMessage.fromJson(Map<String, dynamic> json) {
    return SingleMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      isFromMe: json['isFromMe'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // 3. Method: 用于转成 JSON 保存到本地
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isFromMe': isFromMe,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
