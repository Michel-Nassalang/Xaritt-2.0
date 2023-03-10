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
  final _modelManager = OnDeviceTranslatorModelManager();
  final _sourceLanguage = TranslateLanguage.french;
  final _targetLanguage = TranslateLanguage.english;
  late final _onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);

  List<String> listLangage = <String>[
    'Anglais',
    'Francais',
    'Espagnol',
    'Italien',
    'Chinois',
    'Grec',
    'Allemand',
    'Portugais',
    'Russe',
    'Swahili',
    'Polonais',
    'Japonais',
    'Coréen',
    'Slovaque',
    'Roumain',
    'Arabe',
    'Hébreu',
    'Irlandais',
    'Afrikaans',
    'Biélorusse',
    'Suédois',
    'Néerlandais'
        'Turc',
    'Ukrainien',
    'Vietnamien',
    'Croate',
    'Estonien',
    'Gallois',
    'Malaisien',
    'Tchèque',
    'Catalan',
    'Bulgare',
    '	Danois',
    '	Persan',
    'Finnois',
    'Haïtien',
    'Hongrois',
    'Indonésien',
    'Islandais',
    'Macédonien'
  ];

  List<String> listLangagevalues = <String>[
    'english',
    'french',
    'spanish',
    'italian',
    'chinese',
    'greek',
    'german',
    'portuguese',
    'russian',
    'swahili',
    'polish',
    'japanese',
    'korean',
    'slovak',
    'romanian',
    'arabic',
    'hebrew',
    'irish',
    'afrikaans',
    'belarusian',
    'swedish',
    'dutch'
        'turkish',
    'ukrainian',
    'vietnamese',
    'croatian',
    'estonian',
    'welsh',
    'malaysian',
    'czech',
    'catalan',
    'bulgarian',
    'danish',
    'persian',
    'finnish',
    'haitian',
    'hungarian',
    'indonesian',
    'icelandic',
    'macedonian'
  ];


  String? selectedOptionsource;
  String? selectedOptioncible;

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
                          DropdownButton(
                            dropdownColor: backgroundColor2,
                            iconEnabledColor: Colors.white,
                            items: List<DropdownMenuItem<String>>.generate(listLangage.length, (index) => 
                            DropdownMenuItem(
                              value: listLangagevalues[index],
                              child: Text(listLangage[index],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    )),
                            value: selectedOptionsource,
                            onChanged: (val) {
                              setState(() {
                                selectedOptionsource = val.toString();
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.change_circle_outlined)),
                          ),
                          DropdownButton(
                            dropdownColor: backgroundColor2,
                            iconEnabledColor: Colors.white,
                            items: List<DropdownMenuItem<String>>.generate(
                                listLangage.length,
                                (index) => DropdownMenuItem(
                                      value: listLangagevalues[index],
                                      child: Text(listLangage[index],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    )),
                            value: selectedOptioncible,
                            onChanged: (val) {
                              setState(() {
                                selectedOptioncible = val.toString();
                              });
                            },
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
                          child: TextFormField(
                            controller: _controller,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                          onPressed: _translateText, child: Text('Traduire'))
                    ]),
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Resultat",
                        style: TextStyle(
                          color: backgroundColor2,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    (_translatedText != "")
                        ? Row(
                            children: [
                              Expanded(child: Container()),
                              const Spacer(),
                              Flexible(
                                  child: ElevatedButton(
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: _translatedText));
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
                        child: (_translatedText != "")
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
                                  _translatedText,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(fontSize: 17),
                                ),
                              )
                            : const SpinKitFadingCube(
                                color: backgroundColor2,
                              ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 150)),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
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
                        const Padding(padding: EdgeInsets.only(right: 10)),
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
                        const Padding(padding: EdgeInsets.only(right: 10)),
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
                        const Padding(padding: EdgeInsets.only(right: 10)),
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
            ],
          ),
        ),
      ),
    );
  }

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
    final result = await _onDeviceTranslator.translateText(_controller.text);
    setState(() {
      _translatedText = result;
    });
  }
}
