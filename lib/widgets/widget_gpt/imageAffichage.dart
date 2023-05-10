import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ImageAffiche extends StatefulWidget {
  const ImageAffiche({Key? key, required this.img }) : super(key: key);
  final String img;

  @override
  _ImageAfficheState createState() => _ImageAfficheState();
}

class _ImageAfficheState extends State<ImageAffiche>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late TransformationController controlZoom;
  late TapDownDetails tapDownDetails;

  @override
  void initState() {
    super.initState();
    controlZoom = TransformationController();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    controlZoom.dispose();
  }

  Future<void> downloadAndSaveImage(String url) async {
    var response = await http.get(Uri.parse(url));
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = url.split("/").last;
    final file = File("${appDir.path}/$fileName");
    await file.writeAsBytes(response.bodyBytes);
    final result = await ImageGallerySaver.saveFile(file.path);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 65, 65, 65),
      appBar: buildAppBar(),
      body: GestureDetector(
        onDoubleTapDown: (details) => tapDownDetails = details,
        onDoubleTap: () {
          final position = tapDownDetails.localPosition;
          const double scale = 3;
          final x = -position.dx * (scale - 1);
          final y = -position.dy * (scale - 1);
          final zoom = Matrix4.identity()
            ..translate(x, y)
            ..scale(scale);
          final value =
              controlZoom.value.isIdentity() ? zoom : Matrix4.identity();
          controlZoom.value = value;
        },
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          panEnabled: true,
          constrained: true,
          transformationController: controlZoom,
          child: Container(
            alignment: Alignment.center,
            child: Image.network(widget.img,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain, loadingBuilder: (BuildContext context,
                    Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/smart_friend.png")),
                ),
                child: const Center(
                  child: SpinKitFadingCube(
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              );
            }, errorBuilder: (context, object, stackTrace) {
              return  const Material(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
                child: Center(
                  child: SpinKitFadingCube(
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Image générée',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              downloadAndSaveImage(widget.img);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  duration: const Duration(milliseconds: 3000),
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: "Téléchargement",
                    message:
                        "Vous allez télécharger l'image générée dans votre système de stockage.",
                    contentType: ContentType.help,
                  ),
                ));
            }, icon: const Icon(Icons.download_rounded)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        PopupMenuButton<String>(
          onSelected: null,
          itemBuilder: (BuildContext context) {
            return {'Details', 'Caractéristiques'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
