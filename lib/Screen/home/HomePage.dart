import 'package:SmartFriend/Screen/gpt/chat_gpt_screen.dart';
import 'package:SmartFriend/Screen/home/components/pageAI.dart';
import 'package:SmartFriend/Screen/mlkit/detectFace/FaceDetection.dart';
import 'package:SmartFriend/Screen/mlkit/detectInk/detect_Ink.dart';
import 'package:SmartFriend/Screen/mlkit/detectObject/ObjectDetection.dart';
import 'package:SmartFriend/Screen/mlkit/detectText/TextDetection.dart';
import 'package:SmartFriend/Screen/mlkit/traductionText/TextTraduction.dart';
import 'package:SmartFriend/utils/Colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import 'components/RoundedButton.dart';
    
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor2.withOpacity(0.7),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/back_IA.jpg"),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: size.height * .1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(),
                        children: [
                          TextSpan(text: "IA \n"),
                          TextSpan(
                              text: "Un ami intelligent",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        PageAi(
                          image: "assets/images/textdetection.png",
                          title: "Détection de textes",
                          auth: "IA-Texte",
                          onPress: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const TextDetection();
                                },
                              ),
                            );
                          },
                          onPressdetails: () {
                            final snackBar = SnackBar(
                              duration: const Duration(milliseconds: 5000),
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Détextion de texte',
                                message:
                                    "Cet outil permet la reconnaissance de texte à l'aide des caractères latins. Il analyse la structure du texte et réalise la détection des mots ou éléments, des lignes et des paragraphes",
                                contentType: ContentType.help,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          },
                        ),
                        PageAi(
                          image: "assets/images/texttraduction.png",
                          title: "Traduction de textes",
                          auth: "IA-Texte",
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const TextTraduction();
                                },
                              ),
                            );
                          },
                          onPressdetails: () {
                            final snackBar = SnackBar(
                              duration: const Duration(milliseconds: 5000),
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Détextion de texte',
                                message:
                                    "Cet outil permet la reconnaissance de texte à l'aide des caractères latins. Il analyse la structure du texte et réalise la détection des mots ou éléments, des lignes et des paragraphes",
                                contentType: ContentType.help,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          },
                        ),
                        PageAi(
                          image: "assets/images/inkdetection.png",
                          title: "Reconnaissance de textes",
                          auth: "IA-Texte",
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return InkDetection();
                                },
                              ),
                            );
                          },
                          onPressdetails: () {
                            final snackBar = SnackBar(
                              duration: const Duration(milliseconds: 5000),
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Reconnaissance texte",
                                message:
                                    "Cet outil permet de reconnaitre toutes les écritures qui sont faits dans la base du language fondé sur le latin.",
                                contentType: ContentType.help,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          },
                        ),
                        PageAi(
                          image: "assets/images/objetdetection.png",
                          title: "Détection d'objet",
                          auth: "IA-Objet",
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ObjectDetection();
                                },
                              ),
                            );
                          },
                          onPressdetails: () {
                            final snackBar = SnackBar(
                              duration: const Duration(milliseconds: 5000),
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: "Détection d'objet",
                                message:
                                    "Grâce à cet outil, vous pouvez détecter et suivre des objets dans un flux d'image.",
                                contentType: ContentType.help,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          },
                        ),
                        PageAi(
                          image: "assets/images/facedetection.png",
                          title: "Détection de visage",
                          auth: "IA-Visage",
                          onPress: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const FaceDetection();
                                },
                              ),
                            );
                          },
                          onPressdetails: () {
                            final snackBar = SnackBar(
                              duration: const Duration(milliseconds: 5000),
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Détection de visage',
                                message:
                                    "Cet outil permet de reconnaître et localiser les traits du visage d'obtenir les coordonnées des yeux, des oreilles, des joues, du nez et de la bouche de chaque visage détecté.",
                                contentType: ContentType.help,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          },
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.grey
                            ),
                            children: [
                              TextSpan(text: "IA: "),
                              TextSpan(
                                text: "Xaritt 2.0",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ChatGptScreen();
                                  },
                                ),
                              );
                            },
                          child: bestOfTheDayCard(size, context)),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(),
                            children: [
                              TextSpan(text: "Outils: "),
                              TextSpan(
                                text: "Mes favoris",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(38.5),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 10),
                                blurRadius: 33,
                                color: const Color(0xFFD3D3D3).withOpacity(.84),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(38.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 30, right: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const <Widget>[
                                              Text(
                                                "Favoris",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Paquets d'outils",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  "Améliorer vos rendus",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                        Image.asset(
                                          "assets/images/mr_bean.png",
                                          width: 55,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 7,
                                  width: size.width * .65,
                                  decoration: BoxDecoration(
                                    color: backgroundColor2.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container bestOfTheDayCard(Size size, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 245,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 220, 220).withOpacity(.25),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: const Text(
                      "Recupérer l'important dans nos informations",
                      style: TextStyle(
                        fontSize: 9,
                        color: backgroundColorLight,
                      ),
                    ),
                  ),
                  const Text(
                    "Gagner en productivité avec votre ami intelligent",
                    style: TextStyle(),
                  ),
                  const Text(
                    "Xaritt 2.0",
                    style: TextStyle(color: backgroundColorLight,
                      fontFamily: "Poppins",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Row(
                      children: const <Widget>[
                        Expanded(
                          child: Text(
                            "Demandez tous ce que vous voudrez et nous vous apporterons une réponse pertinente.",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: backgroundColorLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              "assets/images/smart_friend.png",
              width: size.width * .45,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              width: size.width * .3,
              child: RoundedButton(
                text: "voir  IA",
                radious: 24,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ChatGptScreen();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}