import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:koto/models/doc_title.dart';
import 'package:koto/models/head_title.dart';
import 'package:koto/models/section_title.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Network.dart';
import '../app_bar.dart';
import '../bottom_bar.dart';
import '../const.dart';
import '../swiper_button.dart';

class NewsDet extends StatefulWidget {
  final String href;
  const NewsDet(this.href, {Key? key}) : super(key: key);
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
                      element.localName == 'h3') {
                    return SectionTitle(text: element.text);
                  } else if (element.localName == 'h4' ||
                      element.localName == 'h5' ||
                      element.localName == 'h6') {
                    return DocTitle(text: element.text);
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
                          var imgAttr =
                              swipes[index].children.first.attributes["src"];

                          return SingleSlide(
                            imgAttr: imgAttr,
                            sourceList: thumbImages,
                            id: index,
                          );
                          return Container();
                        },
                        itemCount: swipes.length,
                        pagination:
                            swipes.length > 1 ? kotoSliderArrow() : null,
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

  SwiperPagination kotoSliderArrow() {
    return SwiperPagination(
      builder: SwiperCustomPagination(
          builder: (BuildContext context, SwiperPluginConfig config) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: const Alignment(-1, 0),
              child: SwiperButton(
                onPress: () {
                  swiperController.previous();
                },
                painterType: LeftPainter(),
                icon: Icons.chevron_left,
              ),
            ),
            Align(
              alignment: const Alignment(1, 0),
              child: SwiperButton(
                painterType: RightPainter(),
                icon: Icons.chevron_right,
                onPress: () {
                  swiperController.next();
                },
              ),
            ),
          ],
        );
      }),
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

class SingleSlide extends StatelessWidget {
  const SingleSlide(
      {Key? key,
      required this.imgAttr,
      required this.sourceList,
      required this.id})
      : super(key: key);

  final String? imgAttr;
  final List sourceList;
  final int id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute<void>(
            builder: (BuildContext context) => InteractiveviewerGallery(
              sources: sourceList,
              initIndex: sourceList.indexOf(id),
              itemBuilder: (context, index, status) => Image.network(
                "http://koto.org.tr/${sourceList[index]}",
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.width,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(mainColor),
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
        imgAttr != "" ? "http://koto.org.tr/$imgAttr" : "",
        loadingBuilder: (context, img, event) {
          if (event == null) return img;

          return SizedBox(
            height: (MediaQuery.of(context).size.width / 16) * 9,
            child: const Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            ),
          );
        },
        height: (MediaQuery.of(context).size.width / 16) * 9,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
