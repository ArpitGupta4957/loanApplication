import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> getStreamToken(String userId) async {
  final url = Uri.parse('http://localhost:3000/get-stream-token');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'userId': userId}),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['token'];
  } else {
    print('Error: ${response.body}');
    return null;
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
  final ImagePicker _picker = ImagePicker();
  final StreamChatClient _client = StreamChatClient(
    'pc75euj8pznv',
    logLevel: Level.INFO,
  );
  Channel? _channel;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    // Get phone number from previous screen or global state
    final phoneNumber =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'user-id';
    _initializeChat(phoneNumber);
  }

  Future<void> _initializeChat(String userId) async {
    final token = await getStreamToken(userId);
    if (token != null) {
      await _client.connectUser(
        User(id: userId, extraData: {'name': userId}),
        token,
      );
      _channel = _client.channel(
        'messaging',
        id: 'mudra-bot',
        extraData: {
          'members': [userId, 'mudra-bot'],
        },
      );
      await _channel!.watch();
      _loadMessages();
      setState(() {});
    } else {
      print('Failed to fetch Stream token');
    }
  }

  Future<void> _loadMessages() async {
    if (_channel != null) {
      final res = await _channel!.query();
      setState(() {
        _messages = res.messages ?? [];
      });
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || _channel == null) return;
    await _channel!.sendMessage(Message(text: text));
    _controller.clear();
    _loadMessages();
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
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && _channel != null) {
      final imageUrl =
          'https://via.placeholder.com/180'; // Replace with uploaded image URL later
      await _channel!.sendMessage(
        Message(
          text: '[Image]',
          attachments: [
            Attachment(type: 'image', imageUrl: imageUrl, title: file.name),
          ],
        ),
      );
      _loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mudra Bot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[idx];
                final isUser = msg.user?.id == 'user-id';
                if (msg.attachments.isNotEmpty &&
                    msg.attachments.first.type == 'image') {
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: Image.network(
                        msg.attachments.first.imageUrl ?? '',
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg.text ?? '', style: TextStyle(fontSize: 16)),
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
