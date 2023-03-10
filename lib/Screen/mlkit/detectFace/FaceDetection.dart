import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/Colors.dart';
import '../components/BorderIcon.dart';
import '../components/OptionButton.dart';
import 'face_detector_painter.dart';
    
class FaceDetection extends StatefulWidget {
  const FaceDetection({Key? key}) : super(key: key);

  @override
  _FaceDetectionState createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  XFile? imageFile;
  String _text = "";

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }
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
                        if (_isBusy)
                          const SpinKitFadingCube(
                            color: backgroundColor2,
                          ),
                        if (imageFile == null)
                          Container(
                            width: size.width,
                            height: 300,
                            color: Colors.grey[300]!,
                          ),
                        if (imageFile != null)
                          Image.file(
                            File(imageFile!.path),
                          ),
                        if(_isBusy )
                        SizedBox(
                          width: size.width,
                          child: _customPaint,
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
                        "Visage",
                        style: TextStyle(
                          color: backgroundColor2,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 35)),
                    (_text != "")
                        ? Row(
                            children: [
                              Expanded(child: Container()),
                              const Spacer(),
                              Flexible(
                                  child: ElevatedButton(
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: _text));
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
                        child: (_text != "")
                            ? Container(
                                padding: const EdgeInsets.fromLTRB(
                                    12.5, 25, 12.5, 15),
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
                                child: SelectableText(
                                  _text,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(fontSize: 17),
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
        _canProcess = true;
        imageFile = pickedImage;
        setState(() {});
        final inputImage = InputImage.fromFilePath(pickedImage.path);
        processImage(inputImage);
      }
    } catch (e) {
      _canProcess = false;
      imageFile = null;
      _text = "Erreur produit pendant le scan";
      setState(() {});
    }
  }

  void processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Visages trouvées: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'Visage: ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}