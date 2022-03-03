import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koto/models/search_bottom_sheet.dart';
import 'package:koto/pages/news_det.dart';
import 'package:koto/pages/start.dart';
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
  Map barButtons = {
    0: {
      'label': 'Anasayfa',
      'icon': const Icon(LineIcons.home),
      'fun': () {
        Get.offAll(const Start());
      }
    },
    1: {
      'label': 'Arama',
      'icon': const Icon(LineIcons.search),
      'fun': () {
        showModalBottomSheet(
          context: Get.context!,
          builder: (el) => const SearchBottomSheet(),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          isDismissible: true,
        );
      }
    },
    2: {
      'label': 'Koto-TV',
      'icon': const Icon(LineIcons.television),
      'fun': () {
        Get.offAll(const Start());
        Get.to(
          () => const NewsDet(
            'http://koto.org.tr/app_bilgi_bankasi_det.php?id=6',
            barIndex: 2,
          ),
        );
      },
    },
    3: {
      'label': 'İletişim',
      'icon': const Icon(LineIcons.phone),
      'fun': () {
        Get.offAll(const Start());
        Get.to(
          () => const NewsDet(
            'http://koto.org.tr/app_iletisim.php',
            barIndex: 3,
          ),
        );
      },
    },
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.cIndex,
      onTap: (index) {
        barButtons[index]['fun']();
      },
      selectedItemColor: const Color(0xFF1F8281),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 100,
      items: barButtons.entries
          .map(
            (e) => BottomNavigationBarItem(
              label: e.value['label'],
              icon: e.value['icon'],
            ),
          )
          .toList(),
      // items: const [
      //   BottomNavigationBarItem(
      //     label: "Anasayfa",
      //     icon: Icon(LineIcons.home),
      //   ),
      //   BottomNavigationBarItem(
      //     label: "E-Oda",
      //     icon: Icon(LineIcons.globe),
      //   ),
      //   BottomNavigationBarItem(
      //     label: "Arama",
      //     icon: Icon(LineIcons.search),
      //   ),
      //   BottomNavigationBarItem(
      //     label: "Koto-TV",
      //     icon: Icon(LineIcons.television),
      //   ),
      // ],
    );
  }
}
