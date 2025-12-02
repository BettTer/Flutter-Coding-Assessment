import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/message_model.dart';
import '../providers/message_provider.dart';

import '../shared/shared_library.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  void _handleSend() {
    ref.read(chatProvider.notifier).sendMessage(_textController.text);
    _textController.clear();
  }

  void _handleImagePick() {
    // resign keyboard focus
    FocusScope.of(context).unfocus();
    ref.read(chatProvider.notifier).sendImage();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear History',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Clear All?"),
                  content: const Text(
                    "This will delete all messages permanently.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(chatProvider.notifier).clearMessages();
                        Navigator.pop(ctx);
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Top blank, resign keyboard focus
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // 1. list zone
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return _ChatBubble(message: msg);
                },
              ),
            ),

            // 2. input
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        onSubmitted: (_) => _handleSend(),
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _handleImagePick,
                      icon: const Icon(Icons.add_photo_alternate),
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _handleSend,
                      icon: const Icon(Icons.send),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _ChatBubble Widget
class _ChatBubble extends StatelessWidget {
  final SingleMessage message;

  const _ChatBubble({required this.message});

  Widget buildAvatar(bool isMe) {
    return Container(
      margin: EdgeInsets.only(left: isMe ? 8 : 0, right: isMe ? 0 : 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8), // 圆角半径，8表示正方形带圆角
        child: Image.asset(
          isMe ? 'assets/images/IMG_2722.JPG' : 'assets/images/10479785.png',
          width: 40, // 头像大小
          height: 40,
          fit: BoxFit.cover, // 充满容器
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isFromMe;
    Widget messageContent;

    if (message.type == MessageType.image) {
      messageContent = _AsyncLocalImage(
        relativePath: message.localImagePath ?? "joiweq",
        heroTag: message.id,
      );
    } else {
      messageContent = Text(
        message.text,
        style: TextStyle(
          color: isMe ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) buildAvatar(isMe),

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 16 : 4),
                  topRight: Radius.circular(isMe ? 4 : 16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  messageContent,
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MM-dd HH:mm').format(message.timestamp),
                    style: TextStyle(
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) buildAvatar(isMe),
        ],
      ),
    );
  }
}

class _FullScreenImageViewer extends StatelessWidget {
  final File imageFile;
  final String heroTag;

  const _FullScreenImageViewer({
    required this.imageFile,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: Hero(tag: heroTag, child: Image.file(imageFile)),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 将此代码粘贴到 chat_screen.dart 最底部

class _AsyncLocalImage extends StatelessWidget {
  final String relativePath;
  final String heroTag;

  const _AsyncLocalImage({required this.relativePath, required this.heroTag});

  Future<File?> _getFullFile() async {
    final appDir = await getApplicationDocumentsDirectory();
    final fullPath = '${appDir.path}/$relativePath';
    final file = File(fullPath);

    if (await file.exists()) {
      return file;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _getFullFile(),
      builder: (context, snapshot) {
        // 1. calculating
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 150,
            height: 150,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        // 2.
        if (snapshot.hasData && snapshot.data != null) {
          final file = snapshot.data!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      _FullScreenImageViewer(imageFile: file, heroTag: heroTag),
                ),
              );
            },
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  file,
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        // 3. missing
        return Container(
          width: 150,
          height: 150,
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.grey),
              Text("Image Lost", style: TextStyle(fontSize: 10)),
            ],
          ),
        );
      },
    );
  }
}
