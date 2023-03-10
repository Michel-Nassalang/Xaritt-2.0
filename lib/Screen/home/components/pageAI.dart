import 'package:SmartFriend/utils/Colors.dart';
import 'package:flutter/material.dart';

import 'RoundedButton.dart';
    
class PageAi extends StatelessWidget {

  
  final String image;
  final String title;
  final String? auth;
  final VoidCallback onPress;
  final VoidCallback onPressdetails;

  const PageAi({
    Key? key,
    required this.image,
    required this.title,
    this.auth,
    required this.onPress,
    required this.onPressdetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, bottom: 40),
      height: 245,
      width: 202,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: onPress,
              child: Container(
                height: 221,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 33,
                      color: backgroundColor2.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onPress,
            child: SizedBox(
              width: 150,
              height: 165,
              child: Image.asset(
                image,
                width: 150,
              ),
            ),
          ),
          Positioned(
            top: 35,
            right: 10,
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.travel_explore_outlined,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            top: 160,
            child: Container(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: onPress,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                          style: const TextStyle(color: backgroundColor2),
                          children: [
                            TextSpan(
                              text: "$title\n",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: auth,
                              style: const TextStyle(
                                color: backgroundColor2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: onPressdetails,
                        child: Container(
                          width: 101,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: const Text("Details"),
                        ),
                      ),
                      Expanded(
                        child: RoundedButton(
                          text: "Voir",
                          press: onPress,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}