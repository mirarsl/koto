import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    this.cIndex = 0,
    Key? key,
  }) : super(key: key);
  final int cIndex;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.cIndex,
      onTap: (index) {
        print(index);
      },
      selectedItemColor: const Color(0xFF1F8281),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 100,
      items: const [
        BottomNavigationBarItem(
          label: "Anasayfa",
          icon: Icon(LineIcons.home),
        ),
        BottomNavigationBarItem(
          label: "E-Oda",
          icon: Icon(LineIcons.globe),
        ),
        BottomNavigationBarItem(
          label: "Arama",
          icon: Icon(LineIcons.search),
        ),
        BottomNavigationBarItem(
          label: "Koto-TV",
          icon: Icon(LineIcons.television),
        ),
      ],
    );
  }
}
