import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import '../../../utils/Colors.dart';
import '../components/BorderIcon.dart';
import '../components/OptionButton.dart';
import '../components/activity_indicator.dart';

class TextTraduction extends StatefulWidget {
  const TextTraduction({Key? key}) : super(key: key);

  @override
  _TextTraductionState createState() => _TextTraductionState();
}

class _TextTraductionState extends State<TextTraduction> {
  String _translatedText = "";
  final _controller = TextEditingController();
  final _controller_result = TextEditingController();
  final _modelManager = OnDeviceTranslatorModelManager();
  late bool _isOpened = false;
  late TranslateLanguage _sourceLanguage = TranslateLanguage.french;
  late TranslateLanguage _targetLanguage = TranslateLanguage.english;
  late OnDeviceTranslator _onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);

  List<String> listLangage = [
    'afrikaans',
    'albanais',
    'arabe',
    'biélorusse',
    'bengali',
    'bulgare',
    'catalan',
    'chinois',
    'croate',
    'tchèque',
    'danois',
    'néerlandais',
    'anglais',
    'espéranto', 
    'estonien',
    'finnois',
    'français',
    'galicien',
    'géorgien',
    'allemand',
    'grec',
    'gujarati',
    'haïtien',
    'hébreu',
    'hindi',
    'hongrois',
    'islandais',
    'indonésien',
    'irlandais',
    'italien',
    'japonais',
    'kannada',
    'coréen',
    'letton',
    'lituanien',
    'macédonien',
    'malais',
    'maltais',
    'marathi',
    'norvégien',
    'persan',
    'polonais',
    'portugais',
    'roumain',
    'russe',
    'slovaque',
    'slovène',
    'espagnol',
    'swahili',
    'suédois',
    'tagalog',
    'tamoul',
    'télougou',
    'thaï',
    'turc',
    'ukrainien',
    'ourdou',
    'vietnamien',
    'gallois'
  ];

  List<String> listLangagevalues = [
    'afrikaans',
    'albanian',
    'arabic',
    'belarusian',
    'bengali',
    'bulgarian',
    'catalan',
    'chinese',
    'croatian',
    'czech',
    'danish',
    'dutch',
    'english',
    'esperanto', 
    'estonian',
    'finnish',
    'french',
    'galician',
    'georgian',
    'german',
    'greek',
    'gujarati',
    'haitian',
    'hebrew',
    'hindi',
    'hungarian',
    'icelandic',
    'indonesian',
    'irish',
    'italian',
    'japanese',
    'kannada',
    'korean',
    'latvian',
    'lithuanian',
    'macedonian',
    'malay',
    'maltese',
    'marathi',
    'norwegian',
    'persian',
    'polish',
    'portuguese',
    'romanian',
    'russian',
    'slovak',
    'slovenian',
    'spanish',
    'swahili',
    'swedish',
    'tagalog',
    'tamil',
    'telugu',
    'thai',
    'turkish',
    'ukrainian',
    'urdu',
    'vietnamese',
    'welsh'
  ];

  String? selectedOptionsource = "french";
  String? selectedOptioncible = "english";

  @override
  void dispose() {
    _onDeviceTranslator.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    const double padding = 25;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
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
                        SizedBox(
                          width: size.width,
                          child:
                              Image.asset("assets/images/textetraduction.png"),
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
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: DropdownButton(
                              dropdownColor: backgroundColor2,
                              iconEnabledColor: Colors.blueGrey,
                              items: List<DropdownMenuItem<String>>.generate(
                                  listLangage.length,
                                  (index) => DropdownMenuItem(
                                        value: listLangagevalues[index],
                                        child: Text(listLangage[index],
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w100,
                                            )),
                                      )),
                              value: selectedOptionsource,
                              onChanged: (val) {
                                setState(() {
                                  selectedOptionsource = val.toString();
                                });
                                _sourceLanguage = translateLanguageFromString(selectedOptionsource!)!;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: IconButton(
                                onPressed: () {
                                  String? textturn = _controller_result.text;
                                  _controller_result.text = _controller.text;
                                  _controller.text = textturn;
                                  String? varturn = selectedOptionsource;
                                  selectedOptionsource = selectedOptioncible;
                                  selectedOptioncible = varturn;
                                  setState(() {
                                  });
                                  _sourceLanguage = translateLanguageFromString(selectedOptionsource!)!;
                                  _targetLanguage = translateLanguageFromString(selectedOptioncible!)!;
                                },
                                icon: const Icon(Icons.change_circle_outlined)),
                          ),
                          Flexible(
                            child: DropdownButton(
                              dropdownColor: backgroundColor2,
                              iconEnabledColor: Colors.blueGrey,
                              items: List<DropdownMenuItem<String>>.generate(
                                  listLangage.length,
                                  (index) => DropdownMenuItem(
                                        value: listLangagevalues[index],
                                        child: Text(listLangage[index],
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            )),
                                      )),
                              value: selectedOptioncible,
                              onChanged: (val) {
                                setState(() {
                                  selectedOptioncible = val.toString();
                                });
                                _targetLanguage = translateLanguageFromString(selectedOptioncible!)!;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    // Texte à inserer
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
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
                            onChanged: (value) => _translateText,
                            onSubmitted: (value) => _translateText,
                            onEditingComplete: () => _translateText,
                            minLines: 10,
                            maxLines: null,
                            controller: _controller,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                                color: backgroundColor2,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                labelText: 'Source',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: backgroundColor2, width: 1),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(2.5),
                                      bottomRight: Radius.circular(2.5),
                                    ))),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                          onPressed: _translateText,
                          child: const Text(
                            'Traduire',
                            style: TextStyle(color: backgroundColor2,
                              fontFamily: "Poppins",),
                          ))
                    ]),
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
                                  ClipboardData(text: _translatedText));
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
                                text: "Langue source",
                                icon: Icons.download_rounded,
                                width: size.width * 0.45,
                                onpressed: _downloadSourceModel,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(right: 10)),
                              OptionButton(
                                text: "Langue cible",
                                icon: Icons.download_rounded,
                                width: size.width * 0.45,
                                onpressed: _downloadTargetModel,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OptionButton(
                                text: "Langue source",
                                icon: Icons.delete,
                                width: size.width * 0.45,
                                onpressed: _deleteSourceModel,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(right: 10)),
                              OptionButton(
                                text: "Langue cible",
                                icon: Icons.delete,
                                width: size.width * 0.45,
                                onpressed: _deleteTargetModel,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OptionButton(
                                text: "Langue source",
                                icon: Icons.check_circle_outline_rounded,
                                width: size.width * 0.45,
                                onpressed: _isSourceModelDownloaded,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(right: 10)),
                              OptionButton(
                                text: "Langue cible",
                                icon: Icons.check_circle_outline_rounded,
                                width: size.width * 0.45,
                                onpressed: _isTargetModelDownloaded,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isOpened = !_isOpened;
            });
          },
          child: Icon(
            !_isOpened ? Icons.settings : Icons.close,
            color: backgroundColor2,
          ),
        ),
      ),
    );
  }

//---------------------------------------------
// Conversion des languages

  TranslateLanguage? translateLanguageFromString(String value) {
    

    final index = listLangagevalues.indexWhere(
      (language) => language.toLowerCase() == value.toLowerCase(),
    );

    if (index >= 0) {
      return TranslateLanguage.values[index];
    }

    return null;
  }

//---------------------------------------------

  Future<void> _downloadSourceModel() async {
    Toast().show(
        'Téléchargement du modèle langage (${_sourceLanguage.name})...',
        _modelManager
            .downloadModel(_sourceLanguage.bcpCode)
            .then((value) => value ? 'Succès' : 'Echec'),
        context,
        this);
  }

  Future<void> _downloadTargetModel() async {
    Toast().show(
        'Téléchargement du modèle langage (${_targetLanguage.name})...',
        _modelManager
            .downloadModel(_targetLanguage.bcpCode)
            .then((value) => value ? 'Succès' : 'Echec'),
        context,
        this);
  }

  Future<void> _deleteSourceModel() async {
    Toast().show(
        'Suppression du modèle (${_sourceLanguage.name})...',
        _modelManager
            .deleteModel(_sourceLanguage.bcpCode)
            .then((value) => value ? 'Succès' : 'Echec'),
        context,
        this);
  }

  Future<void> _deleteTargetModel() async {
    Toast().show(
        'Suppression du modèle (${_targetLanguage.name})...',
        _modelManager
            .deleteModel(_targetLanguage.bcpCode)
            .then((value) => value ? 'Succès' : 'Echec'),
        context,
        this);
  }

  Future<void> _isSourceModelDownloaded() async {
    Toast().show(
        'Vérification de téléchargement du modèle (${_sourceLanguage.name})...',
        _modelManager
            .isModelDownloaded(_sourceLanguage.bcpCode)
            .then((value) => value ? 'Téléchargé' : 'Non Téléchargé'),
        context,
        this);
  }

  Future<void> _isTargetModelDownloaded() async {
    Toast().show(
        'Vérification de téléchargement du modèle (${_targetLanguage.name})...',
        _modelManager
            .isModelDownloaded(_targetLanguage.bcpCode)
            .then((value) => value ? 'Téléchargé' : 'Non Téléchargé'),
        context,
        this);
  }

  Future<void> _translateText() async {
    FocusScope.of(context).unfocus();
    _onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);
    final result = await _onDeviceTranslator.translateText(_controller.text);
    setState(() {
      _translatedText = result;
      _controller_result.text = _translatedText;
    });
  }
}
