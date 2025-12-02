import 'package:hive/hive.dart';
part 'message_model.g.dart';

@HiveType(typeId: 1)
enum MessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  image,
}

@HiveType(typeId: 0)
class SingleMessage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isFromMe;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4, defaultValue: MessageType.text)
  final MessageType type;

  @HiveField(5)
  final String? localImagePath;

  const SingleMessage({
    required this.id,
    required this.text,
    required this.isFromMe,
    required this.timestamp,
    // default: text type
    this.type = MessageType.text,
    this.localImagePath,
  });

  factory SingleMessage.fromJson(Map<String, dynamic> json) {
    return SingleMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      isFromMe: json['isFromMe'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: MessageType.values[json['type'] ?? 0],
      localImagePath: json['localImagePath'],
    );
  }

  // 3. Method: 用于转成 JSON 保存到本地
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isFromMe': isFromMe,
      'timestamp': timestamp.toIso8601String(),
      'type': type.index,
      'localImagePath': localImagePath,
    };
  }
}
