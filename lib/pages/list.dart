import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:koto/models/doc_title.dart';
import 'package:koto/models/head_title.dart';
import 'package:koto/models/section_title.dart';
import 'package:koto/models/slide_without_image.dart';
import 'package:koto/pages/news_det.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Network.dart';
import '../app_bar.dart';
import '../bottom_bar.dart';
import '../const.dart';

class ListDet extends StatefulWidget {
  final String href;
  const ListDet(this.href, {Key? key}) : super(key: key);
  @override
  _ListDetState createState() => _ListDetState();
}

class _ListDetState extends State<ListDet> {
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
                // onTapUrl: (href) {
                //   if (!href.startsWith('http')) {
                //     href = "https://koto.org.tr/" + href;
                //   }
                //   launchURL(href);
                //   return true;
                // },
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
                  } else if (element.className == 'document') {
                    String? href = element.attributes['href'];
                    return DocTitle(
                      text: element.text,
                      href: href!,
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
                  } else if (element.className == "announcement-item mb-4") {
                    var title =
                        element.children[1].children.first.children.first.text;
                    var link = element.children[0].attributes['href'];
                    var date =
                        element.children[1].children.first.children[1].text;
                    // print(title);
                    return SingleNews(
                      text: title,
                      onTap: () {
                        if (link!.isNotEmpty) {
                          Get.to(() => NewsDet("http://koto.org.tr/$link"));
                        }
                      },
                      date: date,
                    );
                  } else if (element.className == "pagination-nav") {
                    var pages = element.children.first.children;

                    return Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: pages.map(
                          (e) {
                            bool isActive = e.children.first.className ==
                                "page-link active-page";
                            var href = e.children.first.attributes['href'];
                            return MaterialButton(
                              minWidth: 40,
                              height: 40,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pop(context);
                                Get.to(
                                    () => ListDet('http://koto.org.tr/$href'));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: !isActive
                                      ? Border.all(color: Colors.white)
                                      : Border.all(color: mainColor),
                                  color: !isActive ? Colors.white : mainColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(.3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    e.text,
                                    style: TextStyle(
                                      color: !isActive
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    );
                  } else if (element.id == "announcement-slider") {
                    var swipes = element.children.first.children;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: (MediaQuery.of(context).size.width / 16) * 12,
                      width: MediaQuery.of(context).size.width,
                      child: Swiper(
                        autoplay: true,
                        autoplayDelay: 3000,
                        itemBuilder: (BuildContext context, int index) {
                          var desc = swipes[index].children[2].text;
                          var date = swipes[index].children[1].text;
                          String? href =
                              swipes[index].children[0].attributes["href"];
                          var icon =
                              'swipes[index].children[3].children[0].className';
                          var text =
                              swipes[index].children.first.children.first.text;
                          return SlideWithOutImage(
                            desc: desc,
                            date: date,
                            href: href.toString(),
                            text: text,
                            icon: icon == "fas fa-bullhorn"
                                ? Icons.volume_down_sharp
                                : Icons.calendar_today,
                          );
                        },
                        pagination: kotoPagination(),
                        itemCount: swipes.length,
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

  SwiperCustomPagination kotoPagination() {
    return SwiperCustomPagination(
      builder: (BuildContext context, SwiperPluginConfig config) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: Iterable.generate(
                config.itemCount,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ),
                  width: 20,
                  height: 5,
                  color: config.activeIndex == i ? mainColor : Colors.grey,
                ),
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}

class SingleNews extends StatelessWidget {
  final String text;
  final Function onTap;
  final String date;
  const SingleNews({
    required this.text,
    required this.onTap,
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        onTap();
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              border: const Border.fromBorderSide(
                BorderSide(width: 2, color: Color(0xFFECECEC)),
              ),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(.1)),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              children: [
                const Image(
                  image: NetworkImage(
                      'http://koto.org.tr/assets/img/logo-icon.png'),
                  width: 70,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 130,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
