import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';
import '../shared/shared_library.dart';

const _uuid = Uuid();

class ChatNotifier extends Notifier<List<SingleMessage>> {
  Box<SingleMessage> get _box => Hive.box<SingleMessage>('chat_history');

  @override
  List<SingleMessage> build() {
    final savedMessages = _box.values.toList();
    if (savedMessages.isEmpty) {
      final welcomeMsg = _generateFirstMessage();

      _box.add(welcomeMsg);
      return [welcomeMsg];
    } else {
      savedMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return savedMessages;
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessage = SingleMessage(
      id: _uuid.v4(),
      text: text,
      isFromMe: true,
      timestamp: DateTime.now(),
    );

    // ⚠️ Save & change state
    await _box.add(newMessage);
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
      replyText = "$replyText ${prevMessage.text}, time: $dateTimeStr";
    }

    final replyMessage = SingleMessage(
      id: _uuid.v4(),
      text: replyText,
      isFromMe: false,
      timestamp: DateTime.now(),
    );

    // ⚠️ Save & change state
    _box.add(replyMessage);
    state = [replyMessage, ...state];
  }

  Future<void> clearMessages() async {
    await _box.clear();
    state = [];

    await Future.delayed(const Duration(seconds: 1));
    final welcomeMsg = _generateFirstMessage();
    await _box.add(welcomeMsg);
    state = [welcomeMsg, ...state];
  }

  SingleMessage _generateFirstMessage() {
    return SingleMessage(
      id: _uuid.v4(),
      text: "Hello, this is the first message. How can I help you?",
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    );
  }
}

final chatProvider = NotifierProvider<ChatNotifier, List<SingleMessage>>(
  ChatNotifier.new,
);
