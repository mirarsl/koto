import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:koto/models/head_title.dart';
import 'package:koto/models/section_title.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Network.dart';
import '../app_bar.dart';
import '../bottom_bar.dart';
import '../const.dart';

class VideoList extends StatefulWidget {
  final String href;
  const VideoList(this.href, {Key? key}) : super(key: key);
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
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
                customWidgetBuilder: (element) {
                  if (element.localName == 'h1') {
                    return HeadTitle(text: element.text);
                  } else if (element.localName == 'h2' ||
                      element.localName == 'h3') {
                    return SectionTitle(text: element.text);
                  } else if (element.className == "swiper-container") {
                    var swipes = element.children.first.children;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 10),
                      height: (MediaQuery.of(context).size.width / 16) * 12,
                      width: MediaQuery.of(context).size.width,
                      child: Swiper(
                        autoplay: true,
                        autoplayDelay: 3000,
                        itemBuilder: (BuildContext context, int index) {
                          String? videoLink =
                              swipes[index].children.first.attributes["href"];
                          var imageLink = swipes[index]
                              .children
                              .first
                              .children
                              .first
                              .attributes['src'];
                          var text =
                              swipes[index].children[1].children.first.text;
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
                                          (MediaQuery.of(context).size.width /
                                                  16) *
                                              9,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: mainColor,
                                        ),
                                      ),
                                    );
                                  },
                                  height:
                                      (MediaQuery.of(context).size.width / 16) *
                                          9,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width: double.infinity,
                                  height:
                                      (MediaQuery.of(context).size.width / 16) *
                                          3,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      text,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: mainColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        pagination: kotoPagination(),
                        itemCount: swipes.length,
                      ),
                    );
                  } else if (element.className == "singleVideo") {
                    String? videoLink =
                        element.children.first.attributes["href"];
                    var imageLink =
                        element.children.first.children.first.attributes['src'];
                    var text = element.children[1].children.first.text;
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
                                (MediaQuery.of(context).size.width / 16) * 3,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                text,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (element.className == "btn") {
                    String? link = element.attributes["href"];
                    return TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                          mainColor.withOpacity(.3),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          mainColor,
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(() => VideoList("http://koto.org.tr/${link!}"));
                      },
                      child: const Text("Tümünü Gör"),
                    );
                  } else if (element.className == "btn btn-lg") {
                    String? link = element.attributes["href"];
                    return TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                          mainColor.withOpacity(.3),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          mainColor,
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(() => VideoList("http://koto.org.tr/${link!}"));
                      },
                      child: const Text("Diğerlerini Gör"),
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
    return showModalBottomSheet(
      context: context,
      builder: (e) {
        String? id = YoutubePlayer.convertUrlToId(videoLink!);
        YoutubePlayerController _controller;
        _controller = YoutubePlayerController(
          initialVideoId: id!,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
          ),
        );
        return Container(
          height: MediaQuery.of(context).size.height - 120,
          child: YoutubePlayer(
            width: MediaQuery.of(context).size.width,
            controller: _controller,
            aspectRatio: 16 / 9,
            progressIndicatorColor: mainColor,
            progressColors: const ProgressBarColors(
              playedColor: mainColor,
              handleColor: mainColor,
            ),
          ),
        );
      },
      isScrollControlled: true,
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
