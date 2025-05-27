
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmergencyDetailScreen extends StatelessWidget {
  const EmergencyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            tooltip: "Open Chat",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmergencyChatScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Details",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // Bordered Table
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                _row("Name", "Ravi Sharma"),
                _row("Mobile", "+91 9876543210"),
                _row("Emergency", "Medical"),
                _row("Location", "Karauli, Rajasthan"),
              ],
            ),

            const SizedBox(height: 30),
            Text(
              "Description",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: const Text("User is injured and needs urgent medical help."),
            ),

            const SizedBox(height: 30),
            Text(
              "Extra Info (Striped Rows)",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _stripedRow("Reported By", "Local Citizen", true),
                _stripedRow("Time", "24-May-2025 2:30 PM", false),
                _stripedRow("Priority", "High", true),
              ],
            ),


          ],
        ),
      ),
    );
  }

  TableRow _row(String key, String value) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _stripedRow(String key, String value, bool isLight) {
    return Container(
      color: isLight ? Colors.grey.shade100 : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          Expanded(child: Text(key, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(value),
        ],
      ),
    );
  }
}


class EmergencyChatScreen extends StatefulWidget {
  const EmergencyChatScreen({super.key});

  @override
  State<EmergencyChatScreen> createState() => _EmergencyChatScreenState();
}

class _EmergencyChatScreenState extends State<EmergencyChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(sender: "Support", message: "Hello! How can I help you?"),
    _ChatMessage(sender: "You", message: "I need urgent medical help."),
  ];

  bool _isTyping = false;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(sender: "You", message: text, time: TimeOfDay.now()));
      _isTyping = true;
    });
    _controller.clear();

    // Simulate reply delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.add(_ChatMessage(sender: "Support", message: "Help is on the way!", time: TimeOfDay.now()));
        _isTyping = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFE95168);
    final purple = const Color(0xFFBA68C8);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [pink.withOpacity(0.8), purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.medical_services, color: Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Emergency Support",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Online",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[_messages.length - 1 - index];
                    final isUser = msg.sender == "You";

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isUser ? 18 : 4),
                            bottomRight: Radius.circular(isUser ? 4 : 18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.message,
                              style: TextStyle(
                                color: isUser ? pink : purple,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                msg.time != null ? msg.time!.format(context) : '',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_isTyping)
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Icon(Icons.medical_services, color: pink),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Support is typing...",
                        style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: Colors.white.withOpacity(0.85),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: pink,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String sender;
  final String message;
  final TimeOfDay? time;

  _ChatMessage({required this.sender, required this.message, this.time});
}

