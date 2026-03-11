import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/message.dart';

// Provide the API key via env or hardcode for now
const apiKey = 'AIzaSyDMaLCKnYFCx2B4CVLsBcyTwkdplvwPj3E';

// Shared system prompt we’ll inject into user prompts, so we don't rely on
// the systemInstruction field (which older model configs may not support).
const _systemPrompt = """
Role: You are 'Buddy,' the Gen Z insurance expert for Bajaj (BAGIC).
Tone: Witty, helpful, uses emojis, and speaks in Hinglish.
Analogies:
- 'Deductible' = 'Cover charge at a club' (pay first, then enter).
- 'Zero Dep' = 'God Mode' for your car.
- 'NCB' = 'Level Up' bonus for safe driving.
Task: Ensure the AI always responds in short, readable bubbles and uses these analogies when asked about technical terms.
""";

final chatServiceProvider = Provider((ref) => ChatService());

class ChatService {
  late final GenerativeModel _textModel;
  late final GenerativeModel _visionModel;

  ChatService() {
    
    _textModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );

    _visionModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  Future<String> sendMessage(List<ChatMessage> history, String newMessage) async {
    try {
      // Map domain message models to Gemini's Content models
      final geminiHistory = history.map((msg) => Content(
        msg.isUser ? 'user' : 'model',
        [TextPart(msg.text)],
      )).toList();

      // Inject our system prompt into the new user message instead of using
      // the systemInstruction request field.
      final promptWithSystem = """
$_systemPrompt

User: $newMessage
""";

      final chat = _textModel.startChat(history: geminiHistory);
      final response = await chat.sendMessage(Content.text(promptWithSystem));
      
      return response.text ?? "Kuch technical glitch ho gaya buddy 😅";
    } catch (e) {
      if (e.toString().contains('API key not valid') || e.toString().contains('expired')) {
        return "Oops! Network ka locha lag raha hai yaar 😢 (API Key Issue)";
      }
      return "Oops! Network ka locha lag raha hai yaar 😢. Error: $e";
    }
  }

  Future<String> analyzeCompetitorPolicy(Uint8List imageBytes) async {
    try {
      final prompt = """
$_systemPrompt

Analyze this competitor's insurance policy image.
Act as Buddy and read the text. Extract key details and then provide a comparison highlighting
3 specific things Bajaj does better than what is seen here (e.g., faster claim settlement in 20 mins,
more network hospitals, higher claim settlement ratio 98%).
Format the 3 highlights clearly so they can be parsed or displayed nicely.
""";
      
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];
      
      final response = await _visionModel.generateContent(content);
      return response.text ?? "Couldn't read the policy image buddy.";
    } catch (e) {
      if (e.toString().contains('API key not valid') || e.toString().contains('expired')) {
        return "Policy scanning failed yaara 😢 network ka locha. (API Key Issue)";
      }
      return "Policy scanning failed yaara 😢. Error: $e";
    }
  }
}
