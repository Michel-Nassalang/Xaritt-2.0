import 'package:SmartFriend/utils/Colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/assets_manager.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Material(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: chatIndex == 0
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Expanded(child: Padding(padding: EdgeInsets.zero)),
                      Container(
                        width: size.width * .7,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: askMessageColor,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await Clipboard.setData(
                                          ClipboardData(text: msg));
                                    },
                                    icon: const Icon(
                                      size: 15,
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            Expanded(
                              child: SelectableText(
                                msg,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    )
                              )
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: CircleAvatar(
                            backgroundColor: backgroundColor2.withOpacity(0.5),
                              child: Image.asset(
                            AssetsManager.userImage,
                            height: size.width * 0.25,
                            width: size.width * 0.25,
                          ))),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: backgroundColor2.withOpacity(0.5),
                              child: Image.asset(
                            AssetsManager.botImage,
                            height: size.width * 0.25,
                            width: size.width * 0.25,
                          ))),
                      Container(
                        width: size.width * .7,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: const BoxDecoration(
                                  color: gptMessageColor,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                        child: Row(
                          children: [
                            Expanded(
                              child: DefaultTextStyle(
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                                child: AnimatedTextKit(
                                    isRepeatingAnimation: false,
                                    repeatForever: false,
                                    displayFullTextOnTap: true,
                                    totalRepeatCount: 1,
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        msg.trim(),
                                      ),
                                    ]),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await Clipboard.setData(
                                          ClipboardData(text: msg));
                                      final snackBar = SnackBar(
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Copie',
                                          message:
                                              "L'intégrale du texte généré à été copié dans votre papier presse.",
                                          contentType: ContentType.success,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    },
                                    icon: const Icon(
                                      size: 15,
                                      Icons.copy_outlined,
                                      color: Colors.white,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
