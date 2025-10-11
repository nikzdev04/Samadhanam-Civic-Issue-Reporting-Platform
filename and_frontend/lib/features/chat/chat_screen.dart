// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http; // IMPORTANT: Requires http dependency in pubspec.yaml
//
// // FIX: If you see a 403 error, replace "" with your actual Gemini API Key here.
// // e.g., const String apiKey = "AIzaSy...your...key";
// const String apiKey = "AIzaSyAToBcfUB9BlLV9eBue5bQSzJWmiyNV3F4";
//
// class Message {
//   final String text;
//   final bool isUser;
//
//   Message({required this.text, required this.isUser});
// }
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final List<Message> _messages = [
//     // Updated welcome message to use 'Sameeksha'
//     Message(text: "Hello! I'm Sameeksha. I can help answer questions about local complaints, regulations, or app features. How can I assist you?", isUser: false),
//   ];
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   bool _isLoading = false;
//
//   // --- Gemini API Implementation with Exponential Backoff ---
//   Future<String> _getGeminiResponse(String prompt) async {
//     // Model selection
//     const String model = 'gemini-2.5-flash-preview-05-20';
//     final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey";
//
//     // System instruction updated to use 'Sameeksha' and 'Samadhanam'
//     const String systemPrompt = "You are a helpful and polite AI Assistant named Sameeksha for a community reporting app called Samadhanam. Your purpose is to answer user questions about civic issues, local regulations, and how to use the app. Keep answers concise and relevant to local government and community services.";
//
//     final payload = {
//       "contents": [
//         {
//           "parts": [
//             {"text": prompt}
//           ]
//         }
//       ],
//       "tools": [
//         {"google_search": {}} // Enable Google Search grounding for real-time data
//       ],
//       "systemInstruction": {
//         "parts": [
//           {"text": systemPrompt}
//         ]
//       },
//     };
//
//     int retries = 0;
//     const int maxRetries = 3;
//     Duration delay = const Duration(seconds: 1);
//
//     while (retries < maxRetries) {
//       try {
//         final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode(payload),
//         );
//
//         if (response.statusCode == 200) {
//           final result = jsonDecode(response.body);
//           final candidate = result['candidates']?[0];
//
//           if (candidate != null && candidate['content']?['parts']?[0]?['text'] != null) {
//             String text = candidate['content']['parts'][0]['text'];
//
//             // Extract citations (grounding sources)
//             final groundingMetadata = candidate['groundingMetadata'];
//             if (groundingMetadata != null && groundingMetadata['groundingAttributions'] != null) {
//               for (var attr in groundingMetadata['groundingAttributions']) {
//                 final title = attr['web']?['title'] ?? 'Source';
//                 final uri = attr['web']?['uri'] ?? '#';
//                 // Append citation to the text
//                 text += "\n\n**Source:** [$title]($uri)";
//               }
//             }
//             return text;
//           } else {
//             return "The AI assistant could not generate a response. Please check the prompt and try again.";
//           }
//         } else if (response.statusCode == 429 || response.statusCode >= 500) {
//           // Handle rate limit or server errors
//           retries++;
//           if (retries >= maxRetries) {
//             return "Server is currently busy (Error: ${response.statusCode}). Please try again later.";
//           }
//           await Future.delayed(delay);
//           delay = delay * 2; // Exponential delay increase
//         } else {
//           // Handle other non-recoverable errors (like 403)
//           return "An error occurred with the AI service: ${response.statusCode}";
//         }
//       } catch (e) {
//         // Handle network errors (e.g., timeout, connection issues)
//         retries++;
//         if (retries >= maxRetries) {
//           return "Could not connect to the network. Please check your internet connection.";
//         }
//         await Future.delayed(delay);
//         delay = delay * 2;
//       }
//     }
//     return "Failed to get a response from the AI assistant.";
//   }
//
//   void _sendMessage() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty || _isLoading) return;
//
//     setState(() {
//       _messages.add(Message(text: text, isUser: true));
//       _controller.clear();
//       _isLoading = true;
//     });
//
//     // Scroll to the latest message immediately
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           0.0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//
//     try {
//       final response = await _getGeminiResponse(text);
//
//       setState(() {
//         _messages.add(Message(text: response, isUser: false));
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add(Message(text: "An unknown error occurred: $e", isUser: false));
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//         // Scroll again after receiving the AI message
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (_scrollController.hasClients) {
//             _scrollController.animateTo(
//               0.0,
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeOut,
//             );
//           }
//         });
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // Updated app bar title
//         title: const Text('Sameeksha AI Chatbot'),
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 0,
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               reverse: true,
//               padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[_messages.length - 1 - index];
//                 return _buildMessage(message, context);
//               },
//             ),
//           ),
//
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.only(bottom: 8.0),
//               child: LinearProgressIndicator(),
//             ),
//
//           const Divider(height: 1.0),
//           _buildTextComposer(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMessage(Message message, BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: <Widget>[
//           Flexible(
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.75, // Max width for message bubble
//               ),
//               padding: const EdgeInsets.all(12.0),
//               decoration: BoxDecoration(
//                 color: message.isUser ? Theme.of(context).primaryColor.withOpacity(0.85) : Colors.grey.shade200,
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(15),
//                   topRight: const Radius.circular(15),
//                   bottomLeft: message.isUser ? const Radius.circular(15) : const Radius.circular(4),
//                   bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(15),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     spreadRadius: 1,
//                     blurRadius: 3,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: SelectableText( // Use SelectableText for user-friendly text selection
//                 message.text,
//                 style: TextStyle(
//                   color: message.isUser ? Colors.white : Colors.black87,
//                   fontSize: 16.0,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextComposer(BuildContext context) {
//     return IconTheme(
//       data: IconThemeData(color: Theme.of(context).primaryColor),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30),
//             border: Border.all(color: Colors.grey.shade300)
//         ),
//         child: Row(
//           children: <Widget>[
//             Flexible(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16.0),
//                 child: TextField(
//                   controller: _controller,
//                   onSubmitted: (_) => _sendMessage(),
//                   decoration: const InputDecoration.collapsed(
//                     hintText: 'Ask a question...',
//                   ),
//                   enabled: !_isLoading,
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: IconButton(
//                 icon: const Icon(Icons.send_rounded),
//                 onPressed: _isLoading ? null : _sendMessage,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // IMPORTANT: Requires http dependency in pubspec.yaml

// FIX: If you see a 403 error, replace "" with your actual Gemini API Key here.
// e.g., const String apiKey = "AIzaSy...your...key";
const String apiKey = "AIzaSyAToBcfUB9BlLV9eBue5bQSzJWmiyNV3F4";

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    // Updated welcome message to use 'Sameeksha'
    Message(text: "Hello! I'm Sameeksha. I can help answer questions about local complaints, regulations, or app features. How can I assist you?", isUser: false),
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // --- Gemini API Implementation with Exponential Backoff ---
  Future<String> _getGeminiResponse(String prompt) async {
    // Model selection
    const String model = 'gemini-2.5-flash-preview-05-20';
    final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey";

    // System instruction updated to use 'Sameeksha' and 'Samadhanam'
    const String systemPrompt = "You are a helpful and polite AI Assistant named Sameeksha for a community reporting app called Samadhanam. Your purpose is to answer user questions about civic issues, local regulations, and how to use the app. Keep answers concise and relevant to local government and community services.";

    final payload = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "tools": [
        {"google_search": {}} // Enable Google Search grounding for real-time data
      ],
      "systemInstruction": {
        "parts": [
          {"text": systemPrompt}
        ]
      },
    };

    int retries = 0;
    const int maxRetries = 3;
    Duration delay = const Duration(seconds: 1);

    while (retries < maxRetries) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final candidate = result['candidates']?[0];

          if (candidate != null && candidate['content']?['parts']?[0]?['text'] != null) {
            String text = candidate['content']['parts'][0]['text'];

            // Extract citations (grounding sources)
            final groundingMetadata = candidate['groundingMetadata'];
            if (groundingMetadata != null && groundingMetadata['groundingAttributions'] != null) {
              for (var attr in groundingMetadata['groundingAttributions']) {
                final title = attr['web']?['title'] ?? 'Source';
                final uri = attr['web']?['uri'] ?? '#';
                // Append citation to the text
                text += "\n\n**Source:** [$title]($uri)";
              }
            }
            return text;
          } else {
            return "The AI assistant could not generate a response. Please check the prompt and try again.";
          }
        } else if (response.statusCode == 429 || response.statusCode >= 500) {
          // Handle rate limit or server errors
          retries++;
          if (retries >= maxRetries) {
            return "Server is currently busy (Error: ${response.statusCode}). Please try again later.";
          }
          await Future.delayed(delay);
          delay = delay * 2; // Exponential delay increase
        } else if (response.statusCode == 403) {
          // Explicitly handle 403 Forbidden error
          return "Access Forbidden (Error 403). This usually means the daily API usage limit has been reached, or the API key is invalid/restricted. Please try again later.";
        } else {
          // Handle other non-recoverable errors
          return "An error occurred with the AI service: ${response.statusCode}";
        }
      } catch (e) {
        // Handle network errors (e.g., timeout, connection issues)
        retries++;
        if (retries >= maxRetries) {
          return "Could not connect to the network. Please check your internet connection.";
        }
        await Future.delayed(delay);
        delay = delay * 2;
      }
    }
    return "Failed to get a response from the AI assistant.";
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _controller.clear();
      _isLoading = true;
    });

    // Scroll to the latest message immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      final response = await _getGeminiResponse(text);

      setState(() {
        _messages.add(Message(text: response, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(text: "An unknown error occurred: $e", isUser: false));
      });
    } finally {
      setState(() {
        _isLoading = false;
        // Scroll again after receiving the AI message
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Updated app bar title
        title: const Text('Sameeksha AI Chatbot'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessage(message, context);
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: LinearProgressIndicator(),
            ),

          const Divider(height: 1.0),
          _buildTextComposer(context),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75, // Max width for message bubble
              ),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: message.isUser ? Theme.of(context).primaryColor.withOpacity(0.85) : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: message.isUser ? const Radius.circular(15) : const Radius.circular(4),
                  bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SelectableText( // Use SelectableText for user-friendly text selection
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300)
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Ask a question...',
                  ),
                  enabled: !_isLoading,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send_rounded),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
