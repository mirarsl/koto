import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:koto/Network.dart';
import 'package:koto/const.dart';
import 'package:koto/models/slide_with_image.dart';
import 'package:koto/models/slide_without_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../app_bar.dart';
import '../bottom_bar.dart';
import '../swiper_button.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic pageData = "";
  Future<dynamic> loadPage() async {
    var data = await Network().getPage('http://koto.org.tr/app_ind.php');
    pageData = data;
    setState(() {});
  }

  @override
  void initState() {
    loadPage();
    super.initState();
  }

  SwiperController swiperController = SwiperController();
  final advancedDrawerController = AdvancedDrawerController();
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
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: HtmlWidget(
                pageData,
                customWidgetBuilder: (element) {
                  if (element.id == "main-slider") {
                    var swipes = element.children.first.children;
                    return Container(
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
                          var aAttr = swipes[index].children.first.attributes;
                          String? href = aAttr['href'];
                          var imgAttr = swipes[index]
                              .children
                              .first
                              .children
                              .first
                              .attributes;
                          var text = swipes[index]
                              .children
                              .first
                              .children[1]
                              .children
                              .first
                              .children
                              .first
                              .innerHtml;
                          return SlideWithImage(
                            imgAttr: imgAttr,
                            text: text,
                            href: href!,
                          );
                        },
                        itemCount: swipes.length,
                        pagination: kotoSliderArrow(),
                        controller: swiperController,
                      ),
                    );
                  }
                  if (element.className == "content-box-header") {
                    var icon = element.children[0];
                    var head = element.text;
                    return Container(
                      margin: const EdgeInsets.only(top: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            decoration: const BoxDecoration(
                              color: mainColor,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  icon.className == "fas fa-bullhorn"
                                      ? Icons.volume_down_sharp
                                      : Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                Text(
                                  head,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (element.className == "swiper-container") {
                    var icon =
                        element.parent?.children[0].children[0].className;

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

                          var aAttr = swipes[index].children[3].attributes;
                          String? href = aAttr['href'];

                          var text = swipes[index].children.first.innerHtml;
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
