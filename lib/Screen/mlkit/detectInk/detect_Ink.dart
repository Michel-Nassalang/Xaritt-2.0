import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart' hide Ink;
import 'package:flutter/services.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import '../../../utils/Colors.dart';
import '../components/BorderIcon.dart';
import '../components/OptionButton.dart';
import '../components/activity_indicator.dart';

class InkDetection extends StatefulWidget {
  @override
  State<InkDetection> createState() => _InkDetectionState();
}

class _InkDetectionState extends State<InkDetection> {
  final DigitalInkRecognizerModelManager _modelManager =
      DigitalInkRecognizerModelManager();
  final String _language = 'fr-FR';
  late bool _isOpened = false;
  late final DigitalInkRecognizer _digitalInkRecognizer =
      DigitalInkRecognizer(languageCode: _language);
  final Ink _ink = Ink();
  List<StrokePoint> _points = [];
  String _recognizedText = '';
  final _controller_result = TextEditingController();

  @override
  void dispose() {
    _digitalInkRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final Size size = MediaQuery.of(context).size;
    const double padding = 25;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: size.width,
                        child:
                            Image.asset("assets/images/inkddetection.png"),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 70)),
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GestureDetector(
                      onPanStart: (DragStartDetails details) {
                        _ink.strokes.add(Stroke());
                      },
                      onPanUpdate: (DragUpdateDetails details) {
                        setState(() {
                          final RenderObject? object =
                              context.findRenderObject();
                          final localPosition = (object as RenderBox?)
                              ?.globalToLocal(details.localPosition);
                          if (localPosition != null) {
                            _points = List.from(_points)
                              ..add(StrokePoint(
                                x: localPosition.dx,
                                y: localPosition.dy,
                                t: DateTime.now().millisecondsSinceEpoch,
                              ));
                          }
                          if (_ink.strokes.isNotEmpty) {
                            _ink.strokes.last.points = _points.toList();
                          }
                        });
                      },
                      onPanEnd: (DragEndDetails details) {
                        _points.clear();
                        setState(() {});
                      },
                      child: CustomPaint(
                        painter: Signature(ink: _ink),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                  if (_recognizedText.isNotEmpty)
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
                            minLines: 4,
                            maxLines: 4,
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
                                  ClipboardData(text: _recognizedText));
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
                  //---------------------
                  Positioned(
                    bottom: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OptionButton(
                          text: "Convertir",
                          icon: Icons.change_circle,
                          width: size.width * 0.4,
                          onpressed: _recogniseText,
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        OptionButton(
                          text: "Effacer",
                          icon: Icons.clear_all,
                          width: size.width * 0.4,
                          onpressed: _clearPad,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              (_isOpened == true)
                  ? Positioned(
                      bottom: 70,
                      width: size.width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OptionButton(
                                text: "",
                                icon: Icons.check_circle_outline_rounded,
                                width: size.width * 0.2,
                                onpressed: _isModelDownloaded,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(right: 10)),
                              OptionButton(
                                text: "",
                                icon: Icons.download,
                                width: size.width * 0.2,
                                onpressed: _downloadModel,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(right: 10)),
                              OptionButton(
                                text: "",
                                icon: Icons.delete,
                                width: size.width * 0.2,
                                onpressed: _deleteModel,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : const Padding(padding: EdgeInsets.zero)
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isOpened = !_isOpened;
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor2, shape: const CircleBorder()),
            child: Icon(
              !_isOpened ? Icons.settings : Icons.close,
              color: backgroundColorLight,
            ),
          ),
        ),
      ),
    );
  }

  void _clearPad() {
    setState(() {
      _ink.strokes.clear();
      _points.clear();
      _recognizedText = '';
      _controller_result.clear();
    });
  }

  Future<void> _isModelDownloaded() async {
    Toast().show(
        'Vérification de téléchargement...',
        _modelManager
            .isModelDownloaded(_language)
            .then((value) => value ? 'téléchargé' : 'not téléchargé'),
        context,
        this);
  }

  Future<void> _deleteModel() async {
    Toast().show(
        'Suppression du modèle...',
        _modelManager
            .deleteModel(_language)
            .then((value) => value ? 'Succès' : 'Echec'),
        context,
        this);
  }

  Future<void> _downloadModel() async {
    Toast().show(
        'Téléchargement du modèle...',
        _modelManager
            .downloadModel(_language)
            .then((value) => value ? 'Succès' : 'Echec'),
        context,
        this);
  }

  Future<void> _recogniseText() async {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text('Reconnaissance'),
            ),
        barrierDismissible: true);
    try {
      final candidates = await _digitalInkRecognizer.recognize(_ink);
      _recognizedText = '';
      for (final candidate in candidates) {
        _recognizedText += '\n${candidate.text}';
      }
      setState(() {
        _controller_result.text = _recognizedText;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    Navigator.pop(context);
  }
}

class Signature extends CustomPainter {
  Ink ink;

  Signature({required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor2
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (final stroke in ink.strokes) {
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];
        canvas.drawLine(Offset(p1.x.toDouble(), p1.y.toDouble()),
            Offset(p2.x.toDouble(), p2.y.toDouble()), paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => true;
}