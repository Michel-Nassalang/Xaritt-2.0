import 'package:flutter/material.dart';

import '../../../utils/rive_utils.dart';
import '../models/menu.dart';
import '../utils/Colors.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Menu selectedSideMenu = sidebarMenus.first;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: boxDecoColor,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: textColor, 
            fontFamily: "Poppins",
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoCard(
                  name: "Smart-Friend",
                  bio: "Xarit 2.0",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Navigation".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: textSubtitle, 
                          fontFamily: "Poppins",
                        ),
                  ),
                ),
                ...sidebarMenus
                    .map((menu) => SideMenu(
                          menu: menu,
                          selectedMenu: selectedSideMenu,
                          press: () {
                            RiveUtils.chnageSMIBoolState(menu.rive.status!);
                            setState(() {
                              selectedSideMenu = menu;
                            });
                          },
                          riveOnInit: (artboard) {
                            menu.rive.status = RiveUtils.getRiveInput(artboard,
                                stateMachineName: menu.rive.stateMachineName);
                          },
                        ))
                    .toList(),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                  child: Text(
                    "Historique".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: textSubtitle, 
                          fontFamily: "Poppins",
                        ),
                  ),
                ),
                ...sidebarMenus2
                    .map((menu) => SideMenu(
                          menu: menu,
                          selectedMenu: selectedSideMenu,
                          press: () {
                            RiveUtils.chnageSMIBoolState(menu.rive.status!);
                            setState(() {
                              selectedSideMenu = menu;
                            });
                          },
                          riveOnInit: (artboard) {
                            menu.rive.status = RiveUtils.getRiveInput(artboard,
                                stateMachineName: menu.rive.stateMachineName);
                          },
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
