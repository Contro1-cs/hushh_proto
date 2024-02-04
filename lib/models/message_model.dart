class Message {
  final String sender;
  final String content;

  Message({required this.sender, required this.content});
}

class Chat {
  List<Message> messages = [];

  void addMessage(Message message) {
    messages.add(message);
  }
}
