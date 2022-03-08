import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_empty_illustration/flutter_empty_illustration.dart';
import 'package:get/get.dart';
import 'package:koto/const.dart';
import 'package:koto/models/draggable_icon.dart';
import 'package:koto/pages/belge-tescil.dart';
import 'package:koto/pages/bilgi-bankasi.dart';
import 'package:koto/pages/home.dart';
import 'package:koto/pages/news_det.dart';
import 'package:koto/pages/ticaret-noktasi.dart';
import 'package:new_version/new_version.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reorderables/reorderables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_bar.dart';
import '../bottom_bar.dart';
import 'koto_bakis.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  Future<dynamic> loadPage() async {
    generateList();
    setState(() {});
  }

  final newVersion = NewVersion(
    forceAppVersion: '1.0.0',
  );

  var internetStatus = true;
  var subscription;

  void networkControl() async {
    internetStatus = await DataConnectionChecker().hasConnection;
    setState(() {});
  }

  @override
  void initState() {
    newVersion.showAlertIfNecessary(context: context);
    networkControl();
    var listener = DataConnectionChecker().onStatusChange.listen((event) {
      networkControl();
    });

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        internetStatus = await DataConnectionChecker().hasConnection;
      }
    });

    loadPage();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  final advancedDrawerController = AdvancedDrawerController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await loadPage();
    _refreshController.refreshCompleted();
  }

  Map<String, Map<String, dynamic>> icons = {
    "Koto'ya Bakış": {
      'icon': "images/icons/kotoya-bakis.png",
      'navigate': () {
        Get.to(() => const KotoBakis());
      },
    },
    "Haberler Duyurular Etkinliker": {
      'icon': "images/icons/haber-duyuru.png",
      'navigate': () {
        Get.to(() => const Home());
      }
    },
    "Aidat Ödeme": {
      'icon': "images/icons/aidat-odeme.png",
      'navigate': () {
        launchURL('https://uye.tobb.org.tr/hizliaidatodeme.jsp');
      },
    },
    "Belge Alma": {
      'icon': "images/icons/belge-alma.png",
      'navigate': () {
        launchURL('https://uye.tobb.org.tr/organizasyon/firma-index.jsp');
      },
    },
    "Belge ve Tescil": {
      'icon': "images/icons/belge-tescil.png",
      'navigate': () {
        Get.to(() => const BelgeTescil());
      },
    },
    "Ticaret Noktası": {
      'icon': "images/icons/ticaret-noktasi.png",
      'navigate': () {
        Get.to(() => const TicaretNoktasi());
      },
    },
    "Bilgi Bankası": {
      'icon': "images/icons/bilgi-bankasi.png",
      'navigate': () {
        Get.to(() => const BilgiBankasi());
      },
    },
    "İhale İşbirliği": {
      'icon': "images/icons/ihale-isbirligi.png",
      'navigate': () {
        launchURL('https://www.tobb2b.org.tr/');
      },
    },
    "Koto Kent": {
      'icon': "images/icons/kotokent.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_koto_kent.php'));
      },
    },
    "İhracat Destek Ofisi": {
      'icon': "images/icons/ihracat-destek-ofisi.png",
      'navigate': () {
        Get.to(() => const NewsDet(
            'http://koto.org.tr/app_ticaret_noktasi_det.php?id=4'));
      },
    },
    "Kotev": {
      'icon': "images/icons/kotev.png",
      'navigate': () {
        launchURL('http://e-koto.org/Kotev/');
      },
    },
    // "İletişim": {
    //   'icon': "images/icons/iletisim.png",
    //   'navigate': () {
    //     Get.to(() => const Iletisim('http://koto.org.tr/app_iletisim.php'));
    //   },
    // },
    "Başkanımız": {
      'icon': "images/icons/baskanimiz.png",
      'navigate': () {
        Get.to(() => const NewsDet('http://koto.org.tr/app_baskanimiz.php'));
      },
    },
  };

  List<DraggableIcon> _iconList = [];
  void generateList() async {
    _iconList = [];
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('icons') != null) {
      List<String>? sharedIcons = prefs.getStringList('icons');
      for (var el in sharedIcons!) {
        _iconList.add(
          DraggableIcon(
            text: el.toString(),
            icon: icons[el.toString()]!["icon"],
            onTap: icons[el.toString()]!["navigate"],
          ),
        );
      }
    } else {
      for (var element in icons.entries) {
        _iconList.add(
          DraggableIcon(
            text: element.key,
            icon: element.value["icon"],
            onTap: element.value["navigate"],
          ),
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) async {
      setState(() {
        DraggableIcon row = _iconList.removeAt(oldIndex);
        _iconList.insert(newIndex, row);
      });

      List<String> pref = [];
      for (var element in _iconList) {
        pref.add(element.text);
      }
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('icons', pref);
    }

    return AdvancedDrawer(
      rtlOpening: true,
      controller: advancedDrawerController,
      backdropColor: Colors.white24,
      drawer: const AdvDrawer(),
      child: internetStatus
          ? Scaffold(
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
                  child: ReorderableWrap(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 15,
                    ),
                    alignment: WrapAlignment.start,
                    needsLongPressDraggable: false,
                    spacing: 15,
                    runSpacing: 15.0,
                    onReorder: _onReorder,
                    ignorePrimaryScrollController: true,
                    children: _iconList,
                  ),
                ),
              ),
              bottomNavigationBar: const BottomBar(cIndex: 0),
            )
          : CustomNoInternetWidget(
              textWidget: Column(
                children: [
                  Text(
                    "İnternet Bağlantısı Koptu",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black.withOpacity(.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      networkControl();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        mainColor,
                      ),
                    ),
                    child: const Text(
                      "Tekrar Bağlan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
