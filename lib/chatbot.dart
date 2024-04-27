import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  static const String apiKey = 'AIzaSyB8XeODLgLKMXUJdceR4CR5b_TK8CHLLC4';

  GenerativeModel? _generativeModel;
  TextEditingController _messageController = TextEditingController();
  List<String> _conversationHistory = [];

  @override
  void initState() {
    super.initState();
    // Initialize the Gemini model
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    _generativeModel =
        await GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    setState(() {});
  }
  // final prompt = 'Write a story about a magic backpack.';

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String userMessage = _messageController.text;

      setState(() {
        _conversationHistory.add('User: $userMessage');
      });

      _messageController.clear();

      String? response = await _generateResponse(userMessage);

      setState(() {
        _conversationHistory.add('Gemini: $response');
      });
    }
  }

  Future<String?> _generateResponse(String userMessage) async {
    if (_generativeModel != null) {
      final content = [Content.text(userMessage)];

      final response = await _generativeModel?.generateContent(content);

      return response?.text;
    } else {
      return 'Error: Ao inicializar o model.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 105, 161, 207),
      appBar: AppBar(
        title: Text('Chatbot com Gemini'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _conversationHistory.length,
              itemBuilder: (context, index) {
                final message = _conversationHistory[index];
                final isUserMessage = _conversationHistory.indexOf(message) % 2 == 0; 
                print(_conversationHistory[index]);
                return ListTile(
                  title: Container(
                    decoration: BoxDecoration(
                        color: isUserMessage ? Colors.white : Colors.blueGrey[100] , // Cor do background
                        borderRadius: BorderRadius.circular(10)
                        ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_conversationHistory[index]),
                    )),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, // Cor do background
                        borderRadius: BorderRadius.circular(10)
                        ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        hintStyle: const TextStyle(color: Colors.blue),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: const Color.fromARGB(255, 3, 101, 182), width: 3.0),
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color:  Color.fromARGB(255, 3, 101, 182), width: 3.0),
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClayContainer(
                  borderRadius: 10,
                  color: Colors.white,
                  spread: 0,
                  height: 60,
                  width: 50,
                  child: IconButton(
                    onPressed: _sendMessage,
                    color: Colors.blue,
                    icon: const Icon(Icons.send),
              
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
