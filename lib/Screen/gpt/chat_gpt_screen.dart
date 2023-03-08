import 'package:SmartFriend/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chats_provider.dart';
import '../../providers/models_provider.dart';
import 'chat_screen.dart';
    
class ChatGptScreen extends StatefulWidget {
  const ChatGptScreen({Key? key}) : super(key: key);

  @override
  _ChatGptScreenState createState() => _ChatGptScreenState();
}

class _ChatGptScreenState extends State<ChatGptScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Smart-Friend',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: colorBackGpt,
            appBarTheme: const AppBarTheme(
              color: colorBackGpt,
            )),
        home: const ChatScreen(),
      ),
    );
  }
}