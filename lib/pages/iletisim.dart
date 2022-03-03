import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:koto/models/doc_title.dart';
import 'package:koto/models/head_title.dart';
import 'package:koto/models/html_table.dart';
import 'package:koto/models/section_title.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Network.dart';
import '../app_bar.dart';
import '../bottom_bar.dart';
import '../const.dart';

class Iletisim extends StatefulWidget {
  final String href;
  const Iletisim(this.href, {Key? key}) : super(key: key);
  @override
  _IletisimState createState() => _IletisimState();
}

class _IletisimState extends State<Iletisim> {
  dynamic pageData;
  Future<dynamic> loadPage() async {
    pageData = "";
    try {
      var data = await Network().getPage(widget.href);
      pageData = data;
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  double tableHeight = Get.height - 40;

  @override
  void initState() {
    loadPage();
    super.initState();
  }

  final advancedDrawerController = AdvancedDrawerController();
  SwiperController swiperController = SwiperController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    Loader.show(
      context,
      progressIndicator: loaderIndicator,
      overlayColor: mainColor.withOpacity(.8),
    );
    await loadPage();
    Loader.hide();
    _refreshController.refreshCompleted();
  }

  List<String> thumbImages = [];

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
                customWidgetBuilder: (element) {
                  if (element.className == 'document') {
                    String? href = element.attributes['href'];
                    return DocTitle(
                      text: element.text,
                      href: href!,
                    );
                  } else if (element.localName == 'h1') {
                    return HeadTitle(text: element.text);
                  } else if (element.localName == 'h2' ||
                      element.localName == 'h3' ||
                      element.localName == 'h4' ||
                      element.localName == 'h5' ||
                      element.localName == 'h6') {
                    return SectionTitle(text: element.text);
                  } else if (element.className == "btn") {
                    String text = element.text;
                    String? href = element.attributes['href'];
                    return TextButton(
                      onPressed: () {
                        if (href!.isNotEmpty) {
                          launchURL(href);
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
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
                  } else if (element.localName == "table") {
                    var heads = [], rows = [];
                    for (var data in element.children) {
                      if (data.localName == "thead") {
                        heads = data.children.first.children;
                      } else if (data.localName == "tbody") {
                        rows = data.children;
                      }
                    }
                    if (rows.length < 6) {
                      tableHeight = (rows.length * 100) + 60;
                    } else {
                      tableHeight = Get.height - 250;
                    }
                    if (heads.isNotEmpty &&
                        rows.isNotEmpty &&
                        heads.length == rows[0].children.length) {
                      return MyHtmlTable(
                        tableHeight: tableHeight,
                        heads: heads,
                        rows: rows,
                      );
                    }
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
