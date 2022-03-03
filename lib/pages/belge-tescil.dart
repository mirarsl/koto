import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:koto/Network.dart';
import 'package:koto/const.dart';
import 'package:koto/models/accordion_title.dart';
import 'package:koto/pages/news_det.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../app_bar.dart';
import '../bottom_bar.dart';
import '../models/head_title.dart';
import '../models/section_title.dart';

class BelgeTescil extends StatefulWidget {
  const BelgeTescil({Key? key}) : super(key: key);

  @override
  _BelgeTescilState createState() => _BelgeTescilState();
}

class _BelgeTescilState extends State<BelgeTescil> {
  dynamic pageData;
  Future<dynamic> loadPage() async {
    pageData = "";
    try {
      var data =
          await Network().getPage('http://koto.org.tr/app_belge_tescil.php');
      pageData = data;
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  void initState() {
    loadPage();
    super.initState();
  }

  final advancedDrawerController = AdvancedDrawerController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  // Map<String, Map<String, dynamic>> tescilIslemleri = {
  //   "Oda Hakkında": {
  //     'icon': "images/koto-bakis/oda-hakkinda.png",
  //     'navigate': () {
  //       Get.to(() => const NewsDet('http://koto.org.tr/app_about_us.php'));
  //     },
  //   },
  //   "Oda Politikaları": {
  //     'icon': "images/koto-bakis/oda-politikalari.png",
  //     'navigate': () {
  //       Get.to(() => const NewsDet('http://koto.org.tr/app_quality.php'));
  //     },
  //   },
  //   "Misyonumuz ve Vizyonumuz": {
  //     'icon': "images/koto-bakis/misyon-vizyon.png",
  //     'navigate': () {
  //       Get.to(() => const NewsDet('http://koto.org.tr/app_missionvision.php'));
  //     },
  //   },
  //   "İş Programı 2019": {
  //     'icon': "images/koto-bakis/is-programi.png",
  //     'navigate': () {
  //       Get.to(() => const NewsDet('http://koto.org.tr/app_isprogrami.php'));
  //     },
  //   },
  //   "Stratejik Plan": {
  //     'icon': "images/koto-bakis/stratejik-plan.png",
  //     'navigate': () {
  //       Get.to(() => const NewsDet('http://koto.org.tr/app_strategy_plan.php'));
  //     },
  //   },
  //   "Çalışma Raporu": {
  //     'icon': "images/koto-bakis/calisma-raporu.png",
  //     // 'icon': "images/koto-bakis/calisma-raporu.png",
  //     'navigate': () {
  //       Get.to(() => const NewsDet('http://koto.org.tr/app_work_report.php'));
  //     },
  //   },
  // };
  // Map<String, Map<String, dynamic>> organizasyon = {
  //   "Meclis": {
  //     'icon': "images/koto-bakis/meclis.png",
  //     'navigate': () {
  //       Get.to(() => const Councils('http://koto.org.tr/app_konsey.php'));
  //     },
  //   },
  //   "Yönetim Kurulu": {
  //     'icon': "images/koto-bakis/yonetim-kurulu.png",
  //     'navigate': () {
  //       Get.to(
  //           () => const Councils('http://koto.org.tr/app_yonetim_kurulu.php'));
  //     },
  //   },
  //   "Meslek Komiteleri": {
  //     'icon': "images/koto-bakis/meslek-komiteleri.png",
  //     'navigate': () {
  //       Get.to(() => const Accordion('http://koto.org.tr/app_committees.php'));
  //     },
  //   },
  //   "İdari Kadro": {
  //     'icon': "images/koto-bakis/idari-kadro.png",
  //     'navigate': () {
  //       Get.to(() => const Accordion('http://koto.org.tr/app_idari_kadro.php'));
  //     },
  //   },
  // };
  //
  // Map<String, Map<String, dynamic>> kotoDinamik = {
  //   "Haberler": {
  //     'icon': "images/koto-bakis/haberler.png",
  //     'navigate': () {
  //       Get.to(() => const ListDet('http://koto.org.tr/app_news.php'));
  //     },
  //   },
  //   "Duyurular": {
  //     'icon': "images/koto-bakis/duyurular.png",
  //     'navigate': () {
  //       Get.to(() => const ListDet('http://koto.org.tr/app_ann.php'));
  //     },
  //   },
  //   "Etkinlikler": {
  //     'icon': "images/koto-bakis/etkinlikler.png",
  //     'navigate': () {
  //       Get.to(() => const ListDet('http://koto.org.tr/app_evn.php'));
  //     },
  //   },
  //   "Komite Çalışmaları": {
  //     'icon': "images/koto-bakis/komite-calismalari.png",
  //     'navigate': () {
  //       Get.to(() => const ListDet('http://koto.org.tr/app_khd.php'));
  //     },
  //   },
  //   "Foto Galeri": {
  //     'icon': "images/koto-bakis/foto-galeri.png",
  //     'navigate': () {
  //       Get.to(() => const ListDet('http://koto.org.tr/app_foto.php'));
  //     },
  //   },
  //   "Video Galeri": {
  //     'icon': "images/koto-bakis/video-galeri.png",
  //     'navigate': () {
  //       Get.to(() => const VideoList('http://koto.org.tr/app_video.php'));
  //     },
  //   },
  // };
  //
  // List<Widget> _kurumsalList = [];
  // List<Widget> _organizationList = [];
  // List<Widget> _dinamikList = [];
  // void generateList() async {
  //   _kurumsalList = [];
  //   _organizationList = [];
  //   _dinamikList = [];
  //
  //   for (var element in tescilIslemleri.entries) {
  //     _kurumsalList.add(
  //       SinglePage(
  //         text: element.key,
  //         icon: element.value["icon"],
  //         onTap: element.value["navigate"],
  //       ),
  //     );
  //   }
  //   for (var element in organizasyon.entries) {
  //     _organizationList.add(
  //       SinglePage(
  //         text: element.key,
  //         icon: element.value["icon"],
  //         onTap: element.value["navigate"],
  //       ),
  //     );
  //   }
  //   for (var element in kotoDinamik.entries) {
  //     _dinamikList.add(
  //       SinglePage(
  //         text: element.key,
  //         icon: element.value["icon"],
  //         onTap: element.value["navigate"],
  //       ),
  //     );
  //   }
  //   setState(() {});
  // }

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
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 15,
                right: 15,
                bottom: 20,
              ),
              child: HtmlWidget(
                pageData,
                onTapImage: (image) {},
                textStyle: const TextStyle(fontSize: 14.5, height: 1.25),
                onTapUrl: (href) {
                  if (!href.startsWith('http')) {
                    href = "https://koto.org.tr/" + href;
                  }
                  launchURL(href);
                  return true;
                },
                onLoadingBuilder: (context, element, status) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  );
                },
                customStylesBuilder: (element) {
                  if (element.localName == "strong") {
                    return {'margin': '7px 0'};
                  }
                  return null;
                },
                customWidgetBuilder: (element) {
                  if (element.localName == 'h1') {
                    return HeadTitle(text: element.text);
                  } else if (element.localName == 'h2' ||
                      element.localName == 'h3' ||
                      element.localName == 'h4' ||
                      element.localName == 'h5' ||
                      element.localName == 'h6') {
                    return SectionTitle(text: element.text);
                  } else if (element.className == "singleBelge") {
                    String? text = element.children.first.text;
                    String? href = element.children.first.attributes['href'];
                    return AccordionTitle(
                      text: text,
                      onTap: () {
                        Get.to(() => NewsDet('http://koto.org.tr/$href'));
                      },
                    );
                  } else if (element.localName == "img") {
                    String? imgSrc = element.attributes['src'];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            HeroDialogRoute<void>(
                              builder: (BuildContext context) =>
                                  InteractiveviewerGallery(
                                sources: [imgSrc],
                                initIndex: 0,
                                itemBuilder: (context, index, status) =>
                                    Image.network(
                                  imgSrc!.startsWith('http')
                                      ? imgSrc
                                      : 'http://koto.org.tr/$imgSrc',
                                  fit: BoxFit.contain,
                                  height: MediaQuery.of(context).size.width,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation(mainColor),
                                        strokeWidth: 2,
                                        backgroundColor: mainColor,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          imgSrc!.startsWith('http')
                              ? imgSrc
                              : 'http://koto.org.tr/$imgSrc',
                          loadingBuilder: (context, img, event) {
                            if (event == null) return img;

                            return SizedBox(
                              height:
                                  (MediaQuery.of(context).size.width / 16) * 9,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: mainColor,
                                ),
                              ),
                            );
                          },
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(cIndex: 0),
      ),
    );
  }
}
