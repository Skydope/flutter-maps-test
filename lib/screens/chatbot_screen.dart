import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      '¡Hola! Soy tu asistente virtual de Bolívar. ¿En qué puedo ayudarte hoy?',
    );
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: false));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });
    _scrollToBottom();
    _simulateBotResponse(text);
  }

  void _simulateBotResponse(String userText) async {
    setState(() => _isTyping = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate thinking

    String reply = '';
    final lowerText = userText.toLowerCase();

    if (lowerText.contains('hola') || lowerText.contains('buen')) {
      reply = '¡Hola! ¿Cómo estás?';
    } else if (lowerText.contains('turno') || lowerText.contains('medico')) {
      reply =
          'Para sacar un turno médico, podés ir a la sección de Inicio y seleccionar "Turnos Médicos". ¿Querés que te lleve allí?';
    } else if (lowerText.contains('farmacia')) {
      reply =
          'Hoy están de turno: Farmacia Del Pueblo (Av. San Martín 150) y Farmacia Nueva (Belgrano 440).';
    } else if (lowerText.contains('clima') || lowerText.contains('tiempo')) {
      reply =
          'Puedes ver el clima actualizado en la pantalla de inicio. Hoy tenemos un día agradable.';
    } else if (lowerText.contains('reclamo') || lowerText.contains('queja')) {
      reply =
          'Entiendo. Para realizar un reclamo, ve a la pestaña "Reclamos" y toca el botón (+).';
    } else {
      reply =
          'No estoy seguro de entender esa consulta, pero puedes llamar al 147 para atención personalizada.';
    }

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(Message(text: reply, isUser: false));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSubmitted() {
    if (_controller.text.trim().isEmpty) return;
    _addUserMessage(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.support_agent, color: Colors.blue),
            ),
            SizedBox(width: 12),
            Text('Asistente Virtual'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20).copyWith(
                        bottomRight: msg.isUser
                            ? Radius.zero
                            : const Radius.circular(20),
                        bottomLeft: !msg.isUser
                            ? Radius.zero
                            : const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Escribiendo...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Mock quick actions menu
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu consulta...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _handleSubmitted(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _handleSubmitted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}
