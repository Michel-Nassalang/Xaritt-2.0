import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/Colors.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.name,
    required this.bio,
  }) : super(key: key);

  final String name, bio;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: cardBackColor,
        child: Icon(
          CupertinoIcons.person,
          color: colorIcon,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(color: textColor),
      ),
      subtitle: Text(
        bio,
        style: const TextStyle(color: textSubtitle),
      ),
    );
  }
}
