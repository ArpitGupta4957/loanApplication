import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getGeminiResponse(String prompt) async {
  final apiKey = 'AIzaSyCw9higWfGushNfAULTpY_pB2LmWWQ4Uew';
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
  );
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json', 'X-goog-api-key': apiKey},
    body: jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
    }),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    try {
      return data['candidates'][0]['content']['parts'][0]['text'] ??
          'No response.';
    } catch (e) {
      return 'No response.';
    }
  } else {
    print('Gemini API error: ${response.body}');
    return 'Error: Could not get response.';
  }
}

class SMSChatbotScreen extends StatefulWidget {
  const SMSChatbotScreen({super.key});

  @override
  State<SMSChatbotScreen> createState() => _SMSChatbotScreenState();
}

class _SMSChatbotScreenState extends State<SMSChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _loading = false;
  String? _error;
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _loading = true;
    });
    _controller.clear();
    final aiResponse = await getGeminiResponse(text);
    setState(() {
      _messages.add({'role': 'ai', 'content': aiResponse});
      _loading = false;
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _pickMedia() async {
    // Optionally implement media upload to Gemini or remove this function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mudra Bot')),
      body: Column(
        children: [
          if (_loading)
            Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            Expanded(
              child: Center(
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            )
          else
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        'No messages yet.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, idx) {
                        final msg = _messages[idx];
                        final isUser = msg['role'] == 'user';
                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.deepPurple[100]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              msg['content'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.deepPurple),
                  onPressed: _pickMedia,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.deepPurple,
                  ),
                  onPressed: _listen,
                ),
                SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
