import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:koto/Network.dart';
import 'package:koto/const.dart';
import 'package:koto/models/accordion_title.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../app_bar.dart';
import '../bottom_bar.dart';
import '../models/head_title.dart';
import '../models/section_title.dart';
import 'news_det.dart';

class TicaretNoktasi extends StatefulWidget {
  const TicaretNoktasi({Key? key}) : super(key: key);

  @override
  _TicaretNoktasiState createState() => _TicaretNoktasiState();
}

class _TicaretNoktasiState extends State<TicaretNoktasi> {
  dynamic pageData;
  Future<dynamic> loadPage() async {
    pageData = "";
    try {
      var data =
          await Network().getPage('http://koto.org.tr/app_ticaret_noktasi.php');
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
                onLoadingBuilder: (context, element, status) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  );
                },
                textStyle: const TextStyle(fontSize: 14.5, height: 1.25),
                onTapUrl: (href) {
                  if (!href.startsWith('http')) {
                    href = "https://koto.org.tr/" + href;
                  }
                  launchURL(href);
                  return true;
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
                        // Get.to(() => MyHomePage());
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
