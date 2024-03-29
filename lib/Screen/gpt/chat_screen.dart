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
import '../../widgets/expandable.dart';
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
  late int askQuestionType = 1;

  late bool isOpened = false;
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
                          chatProvider.getChatList.length, // chatList.length,
                      itemBuilder: (context, index) {
                        return ChatWidget(
                          msg: chatProvider
                              .getChatList[index].msg, // chatList[index].msg,
                          chatIndex: chatProvider.getChatList[index]
                              .chatIndex, // chatList[index].chatIndex,
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
                    horizontal: 15,
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
                        IconButton(
                            icon: Icon(
                              isOpened ? Icons.close : Icons.attach_file,
                              color: Colors.white.withOpacity(0.64),
                            ),
                            onPressed: () {
                              setState(() {
                                focusNode.unfocus();
                                isOpened = !isOpened;
                              });
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            constraints: const BoxConstraints(
                              minWidth: 26,
                              minHeight: kMinInteractiveDimension,
                            )),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!focusNode.hasFocus) {
                                  isOpened = false;
                                  focusNode.requestFocus();
                                }
                              });
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10 * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: TextFormField(
                                  minLines: 1,
                                  maxLines: 5,
                                  focusNode: focusNode,
                                  style: const TextStyle(color: Colors.white),
                                  controller: textEditingController,
                                  onFieldSubmitted: (value) async {
                                    await sendMessageFCT(
                                        modelsProvider: modelsProvider,
                                        chatProvider: chatProvider);
                                  },
                                  onTap: () {
                                    isOpened = false;
                                  },
                                  onTapOutside: (event) {
                                    setState(() {
                                      focusNode.unfocus();
                                    });
                                  },
                                  decoration: const InputDecoration.collapsed(
                                      hintText: "Comment puis je t'aider",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 55),
          child: isOpened
              ? Row(children: [
                  const Expanded(child: Padding(padding: EdgeInsets.zero)),
                  ExpandableFab(distance: 170, children: [
                    ActionButton(
                        icon:
                            const Icon(Icons.text_fields, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            askQuestionType = 1;
                            isOpened = false;
                          });
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 3000),
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Texte",
                                message:
                                    "Génération de texte: Vous donnez un message en texte et vous recever une réponse en texte.",
                                contentType: ContentType.help,
                              ),
                            ));
                        }),
                    const Padding(padding: EdgeInsets.only(bottom: 5)),
                    ActionButton(
                        icon: const Icon(Icons.image, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            askQuestionType = 2;
                            isOpened = false;
                          });
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 3000),
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Image",
                                message:
                                    "Génération d'images: Vous donnez un message en texte et vous recever une réponse en image.",
                                contentType: ContentType.help,
                              ),
                            ));
                        }),
                    const Padding(padding: EdgeInsets.only(bottom: 5)),
                  ]),
                ])
              : const Padding(padding: EdgeInsets.zero),
        ));
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
          duration: const Duration(milliseconds: 3000),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "Erreur",
            message: "Patientez que la réponse en cours soit terminé.",
            contentType: ContentType.failure,
          ),
        ));
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 3000),
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
      askQuestionType == 1
          ? await chatProvider.sendMessageAndGetAnswers(
              msg: msg, chosenModelId: modelsProvider.getCurrentModel)
          :  await chatProvider.sendMessageAndGetImages(msg: msg);

      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 3000),
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
