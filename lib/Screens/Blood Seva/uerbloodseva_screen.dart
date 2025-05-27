import 'package:flutter/material.dart';
class UserBloodSevaScreen extends StatelessWidget {
  final String title;

  UserBloodSevaScreen({super.key, required this.title});

  final Map<String, String> userData = {
    'Name': 'Rahul Kumar',
    'Mobile': '9876543210',
    'Blood Type': 'B+',
    'Hospital': 'City Hospital',
    'Address': '123 Main Street, Cityname',
  };

  final Map<String, String> donationHistory = {
    'Last Donation Date': '2024-04-10',
    'Total Donations': '5',
  };

  final String medicalNotes = "Donor has no known medical conditions. Eligible for donation.";

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFE95168);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: pink,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            tooltip: "Chat with Donor",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(donorName: userData['Name']!),
                ),
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
              "Donor Details",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            Table(
              border: TableBorder.all(color: Colors.grey.shade400),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: userData.entries
                  .map((e) => _buildTableRow(e.key, e.value))
                  .toList(),
            ),

            const SizedBox(height: 30),
            Text(
              "Additional Information",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: pink),
              ),
              child: const Text(
                "Please contact the donor to arrange blood donation and confirm availability.",
                style: TextStyle(color: Colors.black87),
              ),
            ),

            // ==== New Section: Donation History ====
            const SizedBox(height: 30),
            Text(
              "Donation History",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.grey.shade400),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: donationHistory.entries
                  .map((e) => _buildTableRow(e.key, e.value))
                  .toList(),
            ),

            // ==== New Section: Medical Notes ====
            const SizedBox(height: 30),
            Text(
              "Medical Notes",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: pink),
              ),
              child: Text(
                medicalNotes,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}

class ChatScreen extends StatefulWidget {
  final String donorName;

  const ChatScreen({super.key, required this.donorName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
