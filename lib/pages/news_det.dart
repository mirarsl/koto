import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:koto/models/doc_title.dart';
import 'package:koto/models/event_calendar.dart';
import 'package:koto/models/head_title.dart';
import 'package:koto/models/html_table.dart';
import 'package:koto/models/koto_kent_item.dart';
import 'package:koto/models/koto_slider_arrow.dart';
import 'package:koto/models/nav_menu.dart';
import 'package:koto/models/section_title.dart';
import 'package:koto/models/single_slide.dart';
import 'package:koto/models/single_video.dart';
import 'package:koto/models/video_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Network.dart';
import '../app_bar.dart';
import '../bottom_bar.dart';
import '../const.dart';
import '../models/accordion_title.dart';

class NewsDet extends StatefulWidget {
  final String href;
  final int barIndex;

  const NewsDet(
    this.href, {
    this.barIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  _NewsDetState createState() => _NewsDetState();
}

class _NewsDetState extends State<NewsDet> {
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
              child: ListView(
                // physics: NeverScrollableScrollPhysics(),
                children: [
                  HtmlWidget(
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
                      } else if (element.id == "main-slider") {
                        var swipes = element.children.first.children;
                        for (var data in swipes) {
                          thumbImages.add(
                              data.children.first.attributes["src"].toString());
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          height: (MediaQuery.of(context).size.width / 16) * 12,
                          width: MediaQuery.of(context).size.width,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              var imgAttr = swipes[index]
                                  .children
                                  .first
                                  .attributes["src"];

                              return SingleSlide(
                                imgAttr: imgAttr,
                                sourceList: thumbImages,
                                id: index,
                                controller: swiperController,
                              );
                              return Container();
                            },
                            itemCount: swipes.length,
                            pagination: swipes.length > 1
                                ? kotoSliderArrow(swiperController)
                                : null,
                            controller: swiperController,
                            loop: swipes.length > 1 ? true : false,
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
                                            valueColor: AlwaysStoppedAnimation(
                                                mainColor),
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
                                      (MediaQuery.of(context).size.width / 16) *
                                          9,
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
                        if (heads.isNotEmpty) {
                          return MyHtmlTable(
                            tableHeight: tableHeight,
                            heads: heads,
                            rows: rows,
                          );
                        }
                      } else if (element.className == "singleBelge") {
                        String? text = element.children.first.text;
                        String? href =
                            element.children.first.attributes['href'];
                        return AccordionTitle(
                          text: text,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDet('http://koto.org.tr/$href'),
                              ),
                            );
                            // Get.to(() => MyHomePage());
                          },
                        );
                      } else if (element.className == "event-calendar") {
                        var calendarList = element.children;
                        return EventCalendar(
                          source: calendarList,
                        );
                      } else if (element.className == "video-item") {
                        String? videoLink =
                            element.children.first.attributes['href'];
                        String? imageLink = element
                            .children.first.children.first.attributes['src'];
                        String? text = element.children.first.children[1].text;
                        String desc = "";
                        if (element.children.first.children.asMap()[3] !=
                            null) {
                          desc = element.children.first.children[3].text;
                        }
                        return RawMaterialButton(
                          onPressed: () {
                            videoBottomSheet(context, videoLink);
                          },
                          child: SingleVideo(
                            imageLink: imageLink,
                            text: text,
                            desc: desc,
                          ),
                        );
                      } else if (element.className == "navbar-menu") {
                        var menu = element.children.first.children;
                        return NavMenu(
                          menu: menu,
                        );
                      } else if (element.className ==
                          "koto-kent-item-section") {
                        var imageLink =
                            element.children.first.attributes['src'];
                        var title = element.children[1].children.first.text;
                        var desc = element.children[1].children[1].text;
                        var href =
                            element.children[1].children[2].attributes['href'];
                        return KotoKentItem(
                          imageLink: imageLink!,
                          title: title,
                          desc: desc,
                          href: href!,
                        );
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 60,
                    width: double.infinity,
                  ),
                  const Text(
                    "Kaynak: http://koto.org.tr",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(cIndex: widget.barIndex),
      ),
    );
  }
}
