import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../utils/Colors.dart';
import '../components/BorderIcon.dart';
import '../components/OptionButton.dart';

class TextDetection extends StatefulWidget {
  const TextDetection({Key? key}) : super(key: key);

  @override
  _TextDetectionState createState() => _TextDetectionState();
}

class _TextDetectionState extends State<TextDetection> {
  
  final _controller_result = TextEditingController();
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        if (textScanning)
                          const SpinKitFadingCube(
                            color: backgroundColor2,
                          ),
                        if (!textScanning && imageFile == null)
                          Container(
                            width: size.width,
                            height: 300,
                            color: Colors.grey[300]!,
                          ),
                        if (imageFile != null)
                          Image.file(
                            File(imageFile!.path),
                          ),
                        Positioned(
                          width: size.width,
                          top: padding,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const BorderIcon(
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.keyboard_backspace,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const BorderIcon(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Resultat",
                        style: TextStyle(
                          color: backgroundColor2,
                          fontSize: 25,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 35)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                          child: Stack(children: [
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(12.5, 25, 12.5, 15),
                          width: size.width * 0.90,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(
                                width: 0.25, color: backgroundColor2),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: backgroundColor2,
                                offset: Offset(5.0, 2.5),
                                blurRadius: 15.0,
                                spreadRadius: 5.0,
                              ),
                              BoxShadow(
                                color: cardBackColor,
                                offset: Offset(5.0, 2.5),
                                blurRadius: 15.0,
                                spreadRadius: 10.0,
                              ),
                            ],
                          ),
                          child: TextField(
                            minLines: 10,
                            maxLines: null,
                            controller: _controller_result,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                                color: backgroundColor2,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                labelText: 'Resultat',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: backgroundColor2, width: 1),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(2.5),
                                      bottomRight: Radius.circular(2.5),
                                    ))),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          top: 15,
                          child: IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: scannedText));
                              final snackBar = SnackBar(
                                duration: const Duration(milliseconds: 3000),
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
                            icon: const Icon(Icons.copy_outlined),
                          ),
                        )
                      ])),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 100)),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OptionButton(
                      text: "Gallerie",
                      icon: Icons.photo_camera_back_outlined,
                      width: size.width * 0.35,
                      onpressed: () {
                        getImage(ImageSource.gallery);
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    OptionButton(
                      text: "Camera",
                      icon: Icons.photo_camera_outlined,
                      width: size.width * 0.35,
                      onpressed: () {
                        getImage(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Erreur produit pendant le scan";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    _controller_result.text = scannedText;
    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
