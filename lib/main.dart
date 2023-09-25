import 'package:flutter/material.dart';
import 'package:testing/Logic/CypherChatBot.dart';
import './Widgets/Message.dart';
import 'Constants/Constant.dart';

void main() {
  runApp(
    MaterialApp(
      title: "ChatBot Testing",
      home: const MyApp(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.teal,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyAppHomePage();
  }
}

class MyAppHomePage extends StatefulWidget {
  const MyAppHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyAppHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<List<dynamic>> messages = [];
  CypherChatBot chatBot = CypherChatBot();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (_) {
        FocusManager.instance.primaryFocus?.unfocus(); //To close the keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ChatBot Testing"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Message(
                      messages[messages.length - 1 - index][2],
                      messages[messages.length - 1 - index][0],
                    ); //0th index stores the info if the message is from user or Bot. true-From User, false-from Bot
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    buildTextBox(),
                    buildSendButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    String query = _textEditingController.text.trim();
    setState(() {
      isLoading = true;
      messages.add([true, DateTime.now(), query]);
    });
    _textEditingController.clear();
    String response = await chatBot.constructCypher(query);
    messages.add([false, DateTime.now(), response]);
    setState(() {
      isLoading = false;
    });
  }

  Expanded buildSendButton() {
    return Expanded(
      flex: 15,
      child: CircleAvatar(
        backgroundColor: _textEditingController.text.isNotEmpty
            ? Colors.teal
            : Colors.black45,
        radius: 25.0,
        child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.send),
          onPressed:
              _textEditingController.text.isNotEmpty ? _sendMessage : null,
        ),
      ),
    );
  }

  Expanded buildTextBox() {
    return Expanded(
      flex: 75,
      child: Container(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : Colors.transparent,
          border: Border.all(
            color: Colors.black26,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              25.0,
            ),
          ),
        ),
        child: TextField(
          enabled: isLoading ? false : true,
          cursorColor: Colors.teal,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              _sendMessage();
            }
          },
          onChanged: (text) {
            setState(() {});
          },
          controller: _textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: isLoading
                ? 'Hold back while finding answers...'
                : 'Type a message...',
          ),
        ),
      ),
    );
  }
}
