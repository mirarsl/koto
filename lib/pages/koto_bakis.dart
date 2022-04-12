import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:koto/const.dart';
import 'package:koto/models/kurumsal_title.dart';
import 'package:koto/models/single_page.dart';
import 'package:koto/pages/accordion.dart';
import 'package:koto/pages/councils.dart';
import 'package:koto/pages/list.dart';
import 'package:koto/pages/news_det.dart';
import 'package:koto/pages/video_list.dart';
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
      'icon': "images/koto-bakis/oda-hakkinda.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_about_us.php'));
      },
    },
    "Oda Politikaları": {
      'icon': "images/koto-bakis/oda-politikalari.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_quality.php'));
      },
    },
    "Misyonumuz ve Vizyonumuz": {
      'icon': "images/koto-bakis/misyon-vizyon.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_missionvision.php'));
      },
    },
    "İş Programı 2021": {
      'icon': "images/koto-bakis/is-programi.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_isprogrami.php'));
      },
    },
    "Stratejik Plan": {
      'icon': "images/koto-bakis/stratejik-plan.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_strategy_plan.php'));
      },
    },
    "Çalışma Raporu": {
      'icon': "images/koto-bakis/calisma-raporu.png",
      // 'icon': "images/koto-bakis/calisma-raporu.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_work_report.php'));
      },
    },
  };
  Map<String, Map<String, dynamic>> organizasyon = {
    "Meclis": {
      'icon': "images/koto-bakis/meclis.png",
      'navigate': () {
        Get.to(() => const Councils('http://koto.org.tr/app_konsey.php'));
      },
    },
    "Yönetim Kurulu": {
      'icon': "images/koto-bakis/yonetim-kurulu.png",
      'navigate': () {
        Get.to(
            () => const Councils('http://koto.org.tr/app_yonetim_kurulu.php'));
      },
    },
    "Meslek Komiteleri": {
      'icon': "images/koto-bakis/meslek-komiteleri.png",
      'navigate': () {
        Get.to(() => const Accordion('http://koto.org.tr/app_committees.php'));
      },
    },
    "İdari Kadro": {
      'icon': "images/koto-bakis/idari-kadro.png",
      'navigate': () {
        Get.to(() => const Accordion('http://koto.org.tr/app_idari_kadro.php'));
      },
    },
  };

  Map<String, Map<String, dynamic>> kotoDinamik = {
    "Haberler": {
      'icon': "images/koto-bakis/haberler.png",
      'navigate': () {
        Get.to(() => const ListDet('http://koto.org.tr/app_news.php'));
      },
    },
    "Duyurular": {
      'icon': "images/koto-bakis/duyurular.png",
      'navigate': () {
        Get.to(() => const ListDet('http://koto.org.tr/app_ann.php'));
      },
    },
    "Etkinlikler": {
      'icon': "images/koto-bakis/etkinlikler.png",
      'navigate': () {
        Get.to(() => const ListDet('http://koto.org.tr/app_evn.php'));
      },
    },
    "Komite Çalışmaları": {
      'icon': "images/koto-bakis/komite-calismalari.png",
      'navigate': () {
        Get.to(() => const ListDet('http://koto.org.tr/app_khd.php'));
      },
    },
    "Foto Galeri": {
      'icon': "images/koto-bakis/foto-galeri.png",
      'navigate': () {
        Get.to(() => const ListDet('http://koto.org.tr/app_foto.php'));
      },
    },
    "Video Galeri": {
      'icon': "images/koto-bakis/video-galeri.png",
      'navigate': () {
        Get.to(() => const VideoList('http://koto.org.tr/app_video.php'));
      },
    },
  };

  List<Widget> _kurumsalList = [];
  List<Widget> _organizationList = [];
  List<Widget> _dinamikList = [];
  void generateList() async {
    _kurumsalList = [];
    _organizationList = [];
    _dinamikList = [];

    for (var element in kurumsal.entries) {
      _kurumsalList.add(
        SinglePage(
          text: element.key,
          icon: element.value["icon"],
          onTap: element.value["navigate"],
        ),
      );
    }
    for (var element in organizasyon.entries) {
      _organizationList.add(
        SinglePage(
          text: element.key,
          icon: element.value["icon"],
          onTap: element.value["navigate"],
        ),
      );
    }
    for (var element in kotoDinamik.entries) {
      _dinamikList.add(
        SinglePage(
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
                const KurumsalTitle(
                  text: 'Kurumsal',
                  image:
                      'http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png',
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 30),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: _kurumsalList.map((e) => e).toList(),
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ),
                const KurumsalTitle(
                  text: 'Organizasyon',
                  image:
                      'http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png',
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 30),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: _organizationList.map((e) => e).toList(),
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ),
                const KurumsalTitle(
                  text: 'Koto Dinamik',
                  image:
                      'http://koto.org.tr/images/upload/9832d0735e58d7637047fb2c795f0b48.png',
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 30),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: _dinamikList.map((e) => e).toList(),
                    physics: const NeverScrollableScrollPhysics(),
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
