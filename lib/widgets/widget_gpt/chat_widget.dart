import 'package:SmartFriend/utils/Colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'imageAffichage.dart';
import '../../services/assets_manager.dart';

class ChatWidget extends StatelessWidget {
  ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  FlutterTts flutterTts = FlutterTts(); 

  Future<void> downloadAndSaveImage(String url) async {
    var response = await http.get(Uri.parse(url));
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = url.split("/").last;
    final file = File("${appDir.path}/$fileName");
    await file.writeAsBytes(response.bodyBytes);
    final result = await ImageGallerySaver.saveFile(file.path);
    print(result);
  }

  void textToSpeech(String text) async {
    await flutterTts.setLanguage("fr-FR");
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                            child: Padding(padding: EdgeInsets.zero)),
                        Container(
                          width: size.width * .6,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: const BoxDecoration(
                            color: askMessageColor,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Stack(
                            children: [
                              Expanded(
                                  child: SelectableText(msg,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ))),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                    onPressed: () async {
                                      await Clipboard.setData(
                                          ClipboardData(text: msg));
                                    },
                                    icon: const Icon(
                                      size: 15,
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: CircleAvatar(
                                backgroundColor:
                                    backgroundColor2.withOpacity(0.5),
                                child: Image.asset(
                                  AssetsManager.userImage,
                                  height: size.width * 0.25,
                                  width: size.width * 0.25,
                                ))),
                      ],
                    )
                  : chatIndex == 1
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CircleAvatar(
                                    backgroundColor:
                                        backgroundColor2.withOpacity(0.5),
                                    child: Image.asset(
                                      AssetsManager.botImage,
                                      height: size.width * 0.25,
                                      width: size.width * 0.25,
                                    ))),
                            Container(
                              width: size.width * .7,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: const BoxDecoration(
                                color: gptMessageColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Stack(
                                children: [
                                  Expanded(
                                    child: DefaultTextStyle(
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                      child: AnimatedTextKit(
                                          isRepeatingAnimation: false,
                                          repeatForever: false,
                                          displayFullTextOnTap: true,
                                          totalRepeatCount: 1,
                                          onTap: () => textToSpeech(msg),
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              msg.trim(),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                        onPressed: () async {
                                          await Clipboard.setData(
                                              ClipboardData(text: msg));
                                          final snackBar = SnackBar(
                                            duration: const Duration(
                                                milliseconds: 1500),
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    0, 156, 146, 146),
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
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CircleAvatar(
                                    backgroundColor:
                                        backgroundColor2.withOpacity(0.5),
                                    child: Image.asset(
                                      AssetsManager.botImage,
                                      height: size.width * 0.25,
                                      width: size.width * 0.25,
                                    ))),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ImageAffiche(img: msg)));
                                  },
                                  child: Container(
                                    width: size.width * .7,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: const BoxDecoration(
                                      color: gptMessageColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Container(
                                      height: size.height * .34,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.network(msg,
                                                    alignment: Alignment.center,
                                                    fit: BoxFit.contain,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/images/smart_friend.png")),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8.0),
                                                            )),
                                                    child: const Center(
                                                      child: SpinKitFadingCube(
                                                        color:
                                                            backgroundColorLight,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  );
                                                }, errorBuilder: (context,
                                                        object, stackTrace) {
                                                  return const Material(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .error_outline_outlined,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const IconButton(onPressed: null, icon: Icon(Icons.downloading_rounded))
                              ],
                            ),
                          ],
                        )),
        ),
      ],
    );
  }
}
