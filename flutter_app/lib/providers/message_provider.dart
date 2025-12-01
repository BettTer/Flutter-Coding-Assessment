import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';
import '../shared/shared_library.dart';

const _uuid = Uuid();

class ChatNotifier extends Notifier<List<SingleMessage>> {
  @override
  List<SingleMessage> build() {
    // Fake Messages
    return [
      SingleMessage(
        id: _uuid.v4(),
        text: "Hello, can I help you?",
        isFromMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessage = SingleMessage(
      id: _uuid.v4(),
      text: text,
      isFromMe: true,
      timestamp: DateTime.now(),
    );

    // show newMessage first
    state = [newMessage, ...state];

    // 2. 模拟网络延迟和客服回复
    await Future.delayed(const Duration(seconds: 1));
    _simulateAutoReply(newMessage);
  }

  void _simulateAutoReply(SingleMessage prevMessage) {
    final repliesMap = {
      0: "The last message you sent me was: ",
      1: "I have recorded it.",
      2: "Good luck. See you.",
    };

    final randomTextID = Random().nextInt(repliesMap.length);
    var replyText = repliesMap[randomTextID]!;
    if (randomTextID == 0) {
      String dateTimeStr = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(prevMessage.timestamp);
      replyText = "$replyText $prevMessage, time: $dateTimeStr";
    }

    final replyMessage = SingleMessage(
      id: _uuid.v4(),
      text: replyText,
      isFromMe: false,
      timestamp: DateTime.now(),
    );

    state = [replyMessage, ...state];
  }
}

final chatProvider = NotifierProvider<ChatNotifier, List<SingleMessage>>(
  ChatNotifier.new,
);
