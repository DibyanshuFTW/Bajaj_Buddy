import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message.dart';
import '../services/chat_service.dart';

final chatViewModelProvider = StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  return ChatViewModel(ref.read(chatServiceProvider));
});

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatState({required this.messages, this.isLoading = false});

  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatViewModel extends StateNotifier<ChatState> {
  final ChatService _chatService;

  ChatViewModel(this._chatService)
      : super(ChatState(messages: [
          ChatMessage(
            text: "Yo! Main Buddy hoon 😎 Aapka personal BAGIC insurance expert! "
                "Batao, Health ya Motor kya cover karna hai aaj?",
            isUser: false,
          )
        ]));

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(text: text, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
    );

    final history = state.messages.where((m) => m != userMsg).toList();

    final responseText = await _chatService.sendMessage(history, text);

    final botMsg = ChatMessage(text: responseText, isUser: false);
    state = state.copyWith(
      messages: [...state.messages, botMsg],
      isLoading: false,
    );
  }
}
