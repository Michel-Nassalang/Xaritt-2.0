import 'dart:io';

import 'package:SmartFriend/utils/Colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import '../components/BorderIcon.dart';
import '../components/OptionButton.dart';

class ObjectDetection extends StatefulWidget {
  const ObjectDetection({Key? key}) : super(key: key);

  @override
  _ObjectDetectionState createState() => _ObjectDetectionState();
}

class _ObjectDetectionState extends State<ObjectDetection> {
  bool imageLabelChecking = false;

  XFile? imageFile;

  String imageLabel = "";
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
                        if (imageLabelChecking)
                          const SpinKitFadingCube(
                            color: backgroundColor2,
                          ),
                        if (!imageLabelChecking && imageFile == null)
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
                        "Description",
                        style: TextStyle(
                          color: backgroundColor2,
                          fontFamily: "Poppins",
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 35)),
                    (imageLabel != "")
                        ? Row(
                            children: [
                              Expanded(child: Container()),
                              const Spacer(),
                              Flexible(
                                  child: ElevatedButton(
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: imageLabel));
                                  final snackBar = SnackBar(
                                    duration:
                                        const Duration(milliseconds: 3000),
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
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        backgroundColor2)),
                                child: const Icon(Icons.copy_outlined),
                              ))
                            ],
                          )
                        : const Padding(padding: EdgeInsets.zero),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: (imageLabel != "")
                            ? Container(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                width: size.width * 0.90,
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: Border.all(
                                      width: 1, color: backgroundColor2),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: backgroundColor2,
                                      offset: Offset(25.0, 15.0),
                                      blurRadius: 15.0,
                                      spreadRadius: 10.0,
                                    ),
                                    BoxShadow(
                                      color: cardBackColor,
                                      offset: Offset(5.0, 2.5),
                                      blurRadius: 15.0,
                                      spreadRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  imageLabel,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              )
                            : const SpinKitFadingCube(
                                color: backgroundColor2,
                              ),
                      ),
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
        imageLabelChecking = true;
        imageFile = pickedImage;
        setState(() {});
        getImageLabels(pickedImage);
      }
    } catch (e) {
      imageLabelChecking = false;
      imageFile = null;
      imageLabel = "Erreur lors de la recupération de l'image";
      setState(() {});
    }
  }

  void getImageLabels(XFile image) async {
    // final inputImage = InputImage.fromFilePath(image.path);
    // ImageLabeler imageLabeler =
    //     ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.75));
    // List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    // StringBuffer sb = StringBuffer();
    // for (ImageLabel imgLabel in labels) {
    //   String lblText = imgLabel.label;
    //   double confidence = imgLabel.confidence;
    //   sb.write(lblText);
    //   sb.write(" : ");
    //   sb.write((confidence * 100).toStringAsFixed(2));
    //   sb.write("%\n");
    // }
    // imageLabeler.close();
    // imageLabel = sb.toString();
    // imageLabelChecking = false;
    // setState(() {});
  }
}
