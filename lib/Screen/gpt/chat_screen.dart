import 'dart:developer';

import 'package:SmartFriend/Screen/startApp/StartPage.dart';
import 'package:SmartFriend/utils/Colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/chats_provider.dart';
import '../../providers/models_provider.dart';
import '../../services/assets_manager.dart';
import '../../services/services.dart';
import '../../widgets/widget_gpt/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor2,
        elevation: 2,
        leading: BackButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StartPage()));
          },
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: backgroundColorLight,
                radius: 24,
                backgroundImage: AssetImage(AssetsManager.botImage),
              ),
            ),
            const Text("Xaritt"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Material(
          color: backgroundColorLight,
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    controller: _listScrollController,
                    itemCount:
                        chatProvider.getChatList.length, //chatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                        msg: chatProvider
                            .getChatList[index].msg, // chatList[index].msg,
                        chatIndex: chatProvider.getChatList[index]
                            .chatIndex, //chatList[index].chatIndex,
                      );
                    }),
              ),
              if (_isTyping) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: SpinKitFadingCube(
                    color: backgroundColor2,
                    size: 18,
                  ),
                ),
              ],
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20 / 2,
                ),
                decoration: const BoxDecoration(
                  color: backgroundColor2,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 32,
                      color: backgroundColor2,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!focusNode.hasFocus) {
                                focusNode.requestFocus();
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20 * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: TextField(
                                minLines: 1,
                                maxLines: 5,
                                focusNode: focusNode,
                                style: const TextStyle(color: Colors.white),
                                controller: textEditingController,
                                onSubmitted: (value) async {
                                  await sendMessageFCT(
                                      modelsProvider: modelsProvider,
                                      chatProvider: chatProvider);
                                },
                                decoration: const InputDecoration.collapsed(
                                    hintText: "Comment puis je t'aider",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.blue.withOpacity(0.1),
                        ),
                        padding: const EdgeInsets.only(left: 3),
                        child: IconButton(
                            onPressed: () async {
                              await sendMessageFCT(
                                  modelsProvider: modelsProvider,
                                  chatProvider: chatProvider);
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 1500),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "Erreur",
            message:
                "Vous ne pouvez pas envoyer plusieurs messages à un moment donné.",
            contentType: ContentType.failure,
          ),
        ));
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 1500),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "Erreur",
            message:
                "S'il vous plait taper votre message sur l'éditeur de texte.",
            contentType: ContentType.failure,
          ),
        ));
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 1500),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "Erreur",
            message: "Impossible d'accéder au modèle d'IA.",
            contentType: ContentType.failure,
          ),
        ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
