import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';
import '../shared/shared_library.dart';

const _uuid = Uuid();

class ChatNotifier extends Notifier<List<SingleMessage>> {
  Box<SingleMessage> get _box => Hive.box<SingleMessage>('chat_history');
  final ImagePicker _picker = ImagePicker();

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

  Future<Directory> _fetchCachedImagesDir() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final imagesDirPath = '${appDirectory.path}/$_fetchCachedImagesFolderName';
    final imagesDir = Directory(imagesDirPath);
    return imagesDir;
  }

  String _fetchCachedImageRelativePath(String fileName) {
    return '$_fetchCachedImagesFolderName/$fileName';
  }

  String _fetchCachedImagesFolderName() {
    return 'chat_images';
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessage = SingleMessage(
      id: _uuid.v4(),
      text: text,
      isFromMe: true,
      timestamp: DateTime.now(),
    );
    _updateHiveAndStateAsync(newMessage);

    // 2. 模拟网络延迟和客服回复
    await Future.delayed(const Duration(seconds: 1));
    _simulateAutoReply(newMessage);
  }

  // * send Image
  Future<void> sendImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      // did cancel
      if (pickedFile == null) return;
      final imagesDir = await _fetchCachedImagesDir();
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      // rename
      final fileName = '${_uuid.v4()}${path.extension(pickedFile.path)}';
      final _ = await File(pickedFile.path).copy('${imagesDir.path}/$fileName');

      final newImageMessage = SingleMessage(
        id: _uuid.v4(),
        text: "",
        isFromMe: true,
        timestamp: DateTime.now(),
        type: MessageType.image,
        localImagePath: _fetchCachedImageRelativePath(fileName),
      );
      _updateHiveAndStateAsync(newImageMessage);

      await Future.delayed(const Duration(seconds: 1));
      _simulateAutoReply(newImageMessage);
    } catch (e) {
      Log.e("Send Image failed");
    }
  }

  void _simulateAutoReply(SingleMessage prevMessage) {
    final repliesMap = {
      0: "The last message you sent me was: ",
      1: "I have recorded it.",
      2: "Good luck. See you.",
    };

    var replyText = "";
    if (prevMessage.type == MessageType.image) {
      replyText = "You sent me a cool image.";
    } else {
      final randomTextID = Random().nextInt(repliesMap.length);

      replyText = repliesMap[randomTextID]!;
      if (randomTextID == 0) {
        String dateTimeStr = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(prevMessage.timestamp);
        replyText = "$replyText ${prevMessage.text}, time: $dateTimeStr";
      }
    }

    final replyMessage = SingleMessage(
      id: _uuid.v4(),
      text: replyText,
      isFromMe: false,
      timestamp: DateTime.now(),
    );

    _updateHiveAndState(replyMessage);
  }

  SingleMessage _generateFirstMessage() {
    return SingleMessage(
      id: _uuid.v4(),
      text: "Hello, this is the first message. How can I help you?",
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    );
  }

  void _updateHiveAndState(SingleMessage newMessage) {
    _box.add(newMessage);
    state = [newMessage, ...state];
  }

  Future<void> _updateHiveAndStateAsync(SingleMessage newMessage) async {
    await _box.add(newMessage);
    state = [newMessage, ...state];
  }

  Future<void> clearMessages() async {
    await _box.clear();
    state = [];

    final imagesDir = await _fetchCachedImagesDir();
    if (await imagesDir.exists() == true) {
      await imagesDir.delete(recursive: true);
      Log.i("deleted cached images");
    }

    await Future.delayed(const Duration(seconds: 1));
    final welcomeMsg = _generateFirstMessage();
    _updateHiveAndState(welcomeMsg);
  }
}

final chatProvider = NotifierProvider<ChatNotifier, List<SingleMessage>>(
  ChatNotifier.new,
);
