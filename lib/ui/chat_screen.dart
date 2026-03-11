import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shimmer/shimmer.dart';
import '../view_models/chat_view_model.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;
  const ChatScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatViewModelProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Scroll to bottom when messages update
    _scrollToBottom();
    
    final content = Column(
      children: [
        Expanded(
          child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == chatState.messages.length && chatState.isLoading) {
                  return _buildShimmerBubble(isDark);
                }
                final msg = chatState.messages[index];
                return _buildChatBubble(msg, theme, isDark);
              },
            ),
          ),
          _buildInputArea(theme, isDark),
        ],
      );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: isDark ? Colors.blue.withOpacity(0.2) : Colors.blue.withOpacity(0.1),
              child: const Icon(Icons.support_agent_rounded, color: Colors.blueAccent),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Buddy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Online and ready to chill', style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
      body: content,
    );
  }

  Widget _buildChatBubble(ChatMessage msg, ThemeData theme, bool isDark) {
    bool isUser = msg.isUser;
    final botColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF9F9F9);
    final userColorSecondary = const Color(0xFF0D47A1); // Blue for some user msgs
    final userColorPrimary = const Color(0xFF001B48); // Dark Navy for main user msgs

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? userColorPrimary : botColor,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
          ),
          border: isUser ? null : Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: isUser
            ? Text(
                msg.text,
                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              )
            : MarkdownBody(
                data: msg.text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 13, height: 1.4),
                  strong: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }

  Widget _buildShimmerBubble(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16).copyWith(
              bottomLeft: Radius.zero,
            ),
          ),
          child: const SizedBox(width: 100, height: 20),
        ),
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black26, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    ref.read(chatViewModelProvider.notifier).sendMessage(val);
                    _controller.clear();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_controller.text.trim().isNotEmpty) {
                ref.read(chatViewModelProvider.notifier).sendMessage(_controller.text);
                _controller.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF001B48),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
