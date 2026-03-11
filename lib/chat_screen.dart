import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const _primaryGreen = Color(0xFF2F7F34);
  static const _bgColor = Color(0xFFF0F4F0);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Chat messages
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: "Hello! I'm your AI agriculture expert. How can I help you with your crops today?",
      isUser: false,
      type: _MessageType.text,
    ),
    _ChatMessage(
      text: "My tomato leaves are turning yellow and curling at the edges. What should I do?",
      isUser: true,
      type: _MessageType.text,
    ),
    _ChatMessage(
      text:
          "Yellow curling leaves can be a sign of nitrogen deficiency, but it's often a symptom of tomato yellow leaf curl virus (TYLCV) or irregular watering.\n\nCould you upload a photo of the leaves or describe the watering schedule?",
      isUser: false,
      type: _MessageType.text,
    ),
    _ChatMessage(
      isUser: true,
      type: _MessageType.voice,
      duration: '0:14',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true, type: _MessageType.text));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
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
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _buildDateChip('TODAY'),
                const SizedBox(height: 12),
                ..._messages.map((m) => _buildMessageItem(m)),
              ],
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2F7F34)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 26),
              ),
              const Expanded(
                child: Text(
                  'Chat with AI Expert',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              // Info button (circle outlined)
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'i',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.more_vert_rounded, color: Colors.white, size: 26),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  // ── Date chip ──
  Widget _buildDateChip(String label) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFDDE8DD),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Color(0xFF3A6B3A),
          ),
        ),
      ),
    );
  }

  // ── Single message dispatcher ──
  Widget _buildMessageItem(_ChatMessage msg) {
    if (msg.isUser) {
      return _UserMessage(message: msg);
    } else {
      return _AgentMessage(message: msg);
    }
  }

  // ── Input Bar ──
  Widget _buildInputBar() {
    return Container(
      color: _bgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Attachment button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE8DD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.attach_file_rounded, color: Color(0xFF4A7A4A), size: 22),
                ),
                const SizedBox(width: 8),
                // Text field
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: Color(0xFFAAAFAA), fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        // Send icon
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.send_rounded,
                              color: _primaryGreen,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Mic button
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: _primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic_rounded, color: Colors.white, size: 26),
                ),
              ],
            ),
          ),
          const Text(
            'HOLD TO SPEAK',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
              color: Color(0xFFAAAAAA),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MESSAGE MODEL
// ─────────────────────────────────────────────

enum _MessageType { text, voice }

class _ChatMessage {
  final String? text;
  final String? duration;
  final bool isUser;
  final _MessageType type;

  const _ChatMessage({
    this.text,
    this.duration,
    required this.isUser,
    required this.type,
  });
}

// ─────────────────────────────────────────────
//  AGENT MESSAGE (left side)
// ─────────────────────────────────────────────

class _AgentMessage extends StatelessWidget {
  final _ChatMessage message;
  const _AgentMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 54, bottom: 4),
            child: Text(
              'Agri Expert',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A7A3A),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Bot avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE8DD),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.smart_toy_rounded, color: Color(0xFF3A7A3A), size: 22),
              ),
              const SizedBox(width: 10),
              // Bubble
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Text(
                    message.text ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A1A1A),
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40), // right margin balance
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  USER MESSAGE (right side)
// ─────────────────────────────────────────────

class _UserMessage extends StatelessWidget {
  final _ChatMessage message;
  const _UserMessage({required this.message});

  static const _primaryGreen = Color(0xFF2F7F34);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 54, bottom: 4),
            child: Text(
              'You',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A7A3A),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 40), // left margin balance
              // Bubble
              Flexible(
                child: message.type == _MessageType.voice
                    ? _VoiceBubble(duration: message.duration ?? '0:00')
                    : _TextBubble(text: message.text ?? ''),
              ),
              const SizedBox(width: 10),
              // User avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE8DD),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Container(
                    color: const Color(0xFF8DAF8D),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 26),
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

// ─────────────────────────────────────────────
//  TEXT BUBBLE (green, user)
// ─────────────────────────────────────────────

class _TextBubble extends StatelessWidget {
  final String text;
  const _TextBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF2F7F34),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          height: 1.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  VOICE BUBBLE (green, user)
// ─────────────────────────────────────────────

class _VoiceBubble extends StatefulWidget {
  final String duration;
  const _VoiceBubble({required this.duration});

  @override
  State<_VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<_VoiceBubble> {
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF2F7F34),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: () => setState(() => _playing = !_playing),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: const Color(0xFF2F7F34),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Waveform bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.55,
                    minHeight: 4,
                    backgroundColor: Colors.white.withOpacity(0.30),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Duration
          Text(
            widget.duration,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}