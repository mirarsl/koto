import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:koto/models/doc_title.dart';
import 'package:koto/models/head_title.dart';
import 'package:koto/models/section_title.dart';
import 'package:koto/pages/event_calendar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Network.dart';
import '../app_bar.dart';
import '../bottom_bar.dart';
import '../const.dart';
import '../models/accordion_title.dart';
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
                          var imgAttr =
                              swipes[index].children.first.attributes["src"];

                          return SingleSlide(
                            imgAttr: imgAttr,
                            sourceList: thumbImages,
                            id: index,
                            controller: swiperController,
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
                    return HtmlTable(
                      tableHeight: tableHeight,
                      heads: heads,
                      rows: rows,
                    );
                  } else if (element.className == "singleBelge") {
                    String? text = element.children.first.text;
                    String? href = element.children.first.attributes['href'];
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
                    String? imageLink =
                        element.children.first.children.first.attributes['src'];
                    String? text = element.children.first.children[1].text;
                    String? desc;
                    if (element.children.first.children.asMap()[3] != null) {
                      desc = element.children.first.children[3].text;
                    }
                    return RawMaterialButton(
                      onPressed: () {
                        videoBottomSheet(context, videoLink);
                      },
                      child: Column(
                        children: [
                          Image.network(
                            imageLink!,
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
                            height:
                                (MediaQuery.of(context).size.width / 16) * 9,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            width: double.infinity,
                            height:
                                (MediaQuery.of(context).size.width / 16) * 4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Text(
                                    text,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: mainColor,
                                    ),
                                  ),
                                ),
                                desc != ""
                                    ? Expanded(
                                        child: Text(desc!),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (element.className == "navbar-menu") {
                    var menu = element.children.first.children;
                    return NavMenu(
                      menu: menu,
                    );
                  } else if (element.className == "koto-kent-item-section") {
                    var imageLink = element.children.first.attributes['src'];
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
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(cIndex: 0),
      ),
    );
  }

  Future<dynamic> videoBottomSheet(BuildContext context, String? videoLink) {
    String? id = YoutubePlayer.convertUrlToId(videoLink!);
    YoutubePlayerController _controller;
    _controller = YoutubePlayerController(
      initialVideoId: id!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
    return Navigator.of(context).push(
      HeroDialogRoute<void>(
        builder: (BuildContext context) => InteractiveviewerGallery(
          sources: [videoLink],
          initIndex: 0,
          itemBuilder: (context, index, status) => YoutubePlayer(
            width: MediaQuery.of(context).size.width,
            controller: _controller,
            aspectRatio: 16 / 9,
            progressIndicatorColor: mainColor,
            progressColors: const ProgressBarColors(
              playedColor: mainColor,
              handleColor: mainColor,
            ),
          ),
        ),
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

class KotoKentItem extends StatelessWidget {
  const KotoKentItem({
    required this.title,
    required this.desc,
    required this.imageLink,
    required this.href,
    Key? key,
  }) : super(key: key);
  final String title;
  final String desc;
  final String imageLink;
  final String href;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 10,
            color: Colors.black.withOpacity(.2),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Get.back();
          Get.to(() => NewsDet('http://koto.org.tr/$href'));
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image(
                image: NetworkImage('http://koto.org.tr/$imageLink'),
                width: double.infinity,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    desc,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NavMenu extends StatelessWidget {
  final List menu;
  const NavMenu({
    required this.menu,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: menu.map(
          (e) {
            return MaterialButton(
              onPressed: () {
                Get.back();
                Get.to(
                  () => NewsDet(
                    'http://koto.org.tr/${e.children.first.attributes['href']}',
                  ),
                );
              },
              minWidth: 0,
              padding: EdgeInsets.zero,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Image(
                        image: NetworkImage(
                          'http://koto.org.tr/${e.children.first.children.first.attributes['src']}',
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 100,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        e.children.first.children[1].text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class HtmlTable extends StatelessWidget {
  const HtmlTable({
    Key? key,
    required this.tableHeight,
    required this.heads,
    required this.rows,
  }) : super(key: key);

  final double tableHeight;
  final List heads;
  final List rows;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tableHeight,
      child: Row(
        children: [
          Expanded(
            child: ExpandableTable(
              scrollShadowColor: mainColor.withOpacity(.1),
              headerHeight: 60,
              firstColumnWidth: 0,
              cellWidth: heads.length <= 3
                  ? (MediaQuery.of(context).size.width - 40) / heads.length
                  : 100,
              header: ExpandableTableHeader(
                firstCell: const SizedBox(),
                children: heads
                    .map(
                      (e) => TableCell(
                        text: e.text,
                        bgColor: Color(0xFFEAEAEA),
                        href: "",
                      ),
                    )
                    .toList(),
              ),
              rows: rows.map((e) {
                var flag = -1;
                return ExpandableTableRow(
                  height: 80,
                  firstCell: const SizedBox(),
                  children: heads.map(
                    (en) {
                      ++flag;
                      String href = "";
                      if (e.children[flag].children.isNotEmpty) {
                        if (e.children[flag].children.first.localName == "a") {
                          href = e
                              .children[flag].children.first.attributes["href"];
                        }
                      }
                      return TableCell(
                        text: e.children[flag].text,
                        bgColor: Colors.white,
                        href: href,
                      );
                    },
                  ).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TableCell extends StatelessWidget {
  final String text;
  final Color bgColor;
  final String href;
  const TableCell({
    required this.text,
    required this.bgColor,
    required this.href,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.zero,
      onPressed: href != ""
          ? () {
              if (!href.startsWith('app_')) {
                if (href.startsWith('http')) {
                  launchURL(href);
                } else {
                  launchURL('http://koto.org.tr/$href');
                }
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDet(
                      'http://koto.org.tr/$href',
                    ),
                  ),
                );
              }
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            width: 1,
            color: mainColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class SingleSlide extends StatelessWidget {
  const SingleSlide({
    Key? key,
    required this.imgAttr,
    required this.sourceList,
    required this.id,
    this.controller,
  }) : super(key: key);

  final String? imgAttr;
  final List sourceList;
  final int id;
  final SwiperController? controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute<void>(
            builder: (BuildContext context) => InteractiveviewerGallery(
              sources: sourceList,
              initIndex: id,
              onPageChanged: (index) {
                if (controller != null) {
                  controller!.move(index);
                }
              },
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
