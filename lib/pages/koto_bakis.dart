import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:koto/const.dart';
import 'package:koto/pages/news_det.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../app_bar.dart';
import '../bottom_bar.dart';

class KotoBakis extends StatefulWidget {
  const KotoBakis({Key? key}) : super(key: key);

  @override
  _KotoBakisState createState() => _KotoBakisState();
}

class _KotoBakisState extends State<KotoBakis> {
  @override
  void initState() {
    generateList();
    super.initState();
  }

  final advancedDrawerController = AdvancedDrawerController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  Map<String, Map<String, dynamic>> kurumsal = {
    "Oda Hakkında": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_about_us.php'));
      },
    },
    "Oda Politikaları": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_quality.php'));
      },
    },
    "Misyonumuz ve Vizyonumuz": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      // 'icon': "images/koto-bakis/misyon-vizyon.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_missionvision.php'));
      },
    },
    "İş Programı 2019": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      // 'icon': "images/koto-bakis/is-programi.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_isprogrami.php'));
      },
    },
    "Stratejik Plan": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      // 'icon': "images/koto-bakis/stratejik-plan.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_strategy_plan.php'));
      },
    },
    "Çalışma Raporu": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      // 'icon': "images/koto-bakis/calisma-raporu.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_work_report.php'));
      },
    },
  };
  Map<String, Map<String, dynamic>> organizasyon = {
    "Meclis": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_about_us.php'));
      },
    },
    "Yönetim Kurulu": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_quality.php'));
      },
    },
    "Meslek Komiteleri": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      // 'icon': "images/koto-bakis/misyon-vizyon.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_missionvision.php'));
      },
    },
    "İdari Kadro": {
      'icon':
          "http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png",
      // 'icon': "images/koto-bakis/is-programi.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_isprogrami.php'));
      },
    },
  };

  List<Widget> _kurumsalList = [];
  void generateList() async {
    _kurumsalList = [];

    for (var element in kurumsal.entries) {
      _kurumsalList.add(
        KurumsalItem(
          text: element.key,
          icon: element.value["icon"],
          onTap: element.value["navigate"],
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      rtlOpening: true,
      controller: advancedDrawerController,
      backdropColor: Colors.white24,
      drawer: const AdvDrawer(),
      child: Scaffold(
        appBar: MyAppBar(advController: advancedDrawerController),
        body: SmartRefresher(
          onRefresh: _onRefresh,
          controller: _refreshController,
          enablePullDown: true,
          header: const WaterDropMaterialHeader(
            color: Colors.white,
            backgroundColor: mainColor,
          ),
          child: SafeArea(
            child: ListView(
              children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        "Kurumsal",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ] +
                  _kurumsalList.map((e) => e).toList() +
                  <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        "Organizasyon",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(cIndex: 0),
      ),
    );
  }
}

class KurumsalItem extends StatelessWidget {
  const KurumsalItem({
    required this.text,
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String text;
  final String icon;
  final dynamic onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 5,
            blurRadius: 10,
            color: Color(0x10000000),
          ),
        ],
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          onTap();
        },
        child: Stack(
          children: [
            Image.network(
              icon,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: const Alignment(1, .9),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(1),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 10,
                        color: Color(0x20000000),
                      ),
                    ]),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 14,
                    color: mainColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
