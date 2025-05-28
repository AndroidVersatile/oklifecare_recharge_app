import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class EcardRequestDetailScreen extends StatefulWidget {
  const EcardRequestDetailScreen({super.key});

  @override
  State<EcardRequestDetailScreen> createState() => _EcardRequestDetailScreenState();
}

class _EcardRequestDetailScreenState extends State<EcardRequestDetailScreen> {
  final Map<String, String> userData = {
    'Name': 'Rahul Kumar',
    'Age': '28',
    'Gender': 'Male',
    'Blood Type': 'B+',
    'Address': '123 Main Street, Cityname',
    'Mobile': '9876543210',
    'Hospital': 'City Hospital',
  };

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFE95168);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Details"),
        backgroundColor: Colors.white,
        foregroundColor: pink,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Table(
              border: TableBorder.all(color: Colors.grey.shade400),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                _buildTableRow('Name', userData['Name'] ?? ''),
                _buildTableRow('Age', userData['Age'] ?? ''),
                _buildTableRow('Gender', userData['Gender'] ?? ''),
                _buildTableRow('Blood Type', userData['Blood Type'] ?? ''),
                _buildTableRow('Address', userData['Address'] ?? ''),
              ],
            ),

            const SizedBox(height: 30),

            // Enhanced Bottom Icon Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionIcon(
                    icon: Icons.location_on,
                    color: Colors.red,
                    label: 'Location',
                    onTap: () {
                      final address = Uri.encodeComponent(userData['Address'] ?? '');
                      final url = "https://www.google.com/maps/search/?api=1&query=$address";
                      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    },
                  ),
                  _buildActionIcon(
                    icon: Icons.call,
                    color: Colors.green,
                    label: 'Call',
                    onTap: () {
                      final phone = userData['Mobile'] ?? '';
                      launchUrl(Uri.parse("tel:$phone"));
                    },
                  ),
                  _buildActionIcon(
                    icon: Icons.chat,
                    color: Colors.blue,
                    label: 'Chat',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EcardChatScreen(
                            donorName: userData['Name'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Table Row Builder
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.grey.shade200,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(value),
        ),
      ],
    );
  }

  // Action Icon Builder
  Widget _buildActionIcon({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}



class EcardChatScreen extends StatefulWidget {
  final String donorName;

  const EcardChatScreen({super.key, required this.donorName});

  @override
  State <EcardChatScreen> createState() => _EcardChatScreenState();
}

class _EcardChatScreenState extends State<EcardChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(sender: "Donor", message: "Hello! How can I help you?"),
    _ChatMessage(sender: "You", message: "I want to know more about blood donation."),
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

    // Simulate donor reply after delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(_ChatMessage(sender: widget.donorName, message: "Thanks for reaching out!", time: TimeOfDay.now()));
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
            colors: [pink, purple],
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(widget.donorName[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.donorName,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
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

              // Typing indicator
              if (_isTyping)
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Text(widget.donorName[0].toUpperCase()),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${widget.donorName} is typing...",
                        style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
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