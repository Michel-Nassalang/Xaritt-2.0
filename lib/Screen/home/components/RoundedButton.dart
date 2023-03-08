import 'package:SmartFriend/utils/Colors.dart';
import 'package:flutter/material.dart';
    
class RoundedButton extends StatelessWidget {

  
   final String text;
  final double radious;
  final VoidCallback press;
  
  const RoundedButton({
    Key? key,
    required this.text,
    this.radious = 29,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: flexyCardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radious),
            bottomRight: Radius.circular(radious),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}