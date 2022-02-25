import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:koto/models/accordion_title.dart';
import 'package:koto/models/head_title.dart';
import 'package:koto/models/section_title.dart';
import 'package:koto/pages/news_det.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Network.dart';
import '../app_bar.dart';
import '../bottom_bar.dart';
import '../const.dart';

class Councils extends StatefulWidget {
  final String href;
  const Councils(this.href, {Key? key}) : super(key: key);
  @override
  _CouncilsState createState() => _CouncilsState();
}

class _CouncilsState extends State<Councils> {
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
                left: 10,
                right: 10,
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
                      element.localName == 'h3' ||
                      element.localName == 'h4' ||
                      element.localName == 'h5' ||
                      element.localName == 'h6') {
                    return SectionTitle(text: element.text);
                  } else if (element.className == "person-information") {
                    var img =
                        element.children.first.children.first.attributes['src'];
                    var title = element.children[1].children[0].text;
                    var name = element.children[1].children[1].text;
                    var comp = element.children[1].children[2].text;
                    var tel = element.children[1].children[3].text;
                    var email = element.children[1].children[4].text;
                    return SinglePerson(
                      title: title,
                      image: img,
                      name: name,
                      company: comp,
                      tel: tel,
                      email: email,
                    );
                  } else if (element.className == "announcement-item") {
                    var href = element.children.first.attributes['href'];
                    return AccordionTitle(
                      text: element.children.first.children.first.children.first
                          .children.first.text,
                      onTap: () {
                        Get.to(
                          () => NewsDet(
                            'http://koto.org.tr/$href',
                          ),
                        );
                      },
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

class SinglePerson extends StatelessWidget {
  const SinglePerson({
    Key? key,
    required this.title,
    required this.image,
    required this.name,
    required this.company,
    required this.tel,
    required this.email,
  }) : super(key: key);

  final String title;
  final String? image;
  final String name;
  final String company;
  final String tel;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 10,
        left: 5,
        right: 5,
      ),
      width: double.infinity / 2,
      child: Stack(
        children: [
          Container(
            height: 150,
            margin: const EdgeInsets.only(top: 35),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
              color: const Color(0xFFF3F3F3),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image!.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                            )
                          ],
                          color: Theme.of(context).canvasColor,
                          image: const DecorationImage(
                            image: NetworkImage(
                              'http://koto.org.tr/images/arkaplan.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 5),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Image(
                            image: NetworkImage(
                              image!.startsWith('http')
                                  ? image!
                                  : 'http://koto.org.tr/$image',
                              headers: {},
                            ),
                            height: 150,
                            width: 110,
                            fit: BoxFit.fitHeight,
                            loadingBuilder: (context, img, event) {
                              if (event == null) return img;
                              return const SizedBox(
                                height: 150,
                                width: 110,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: mainColor,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, exp, stack) {
                              return const SizedBox(
                                width: 110,
                                height: 150,
                              );
                            },
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 110,
                        height: 150,
                      ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width - 180,
                            padding: const EdgeInsets.only(bottom: 5, top: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2B2B2B),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            right: MediaQuery.of(context).size.width / 4,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 3,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          company,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width - 180,
                      ),
                      tel.isNotEmpty
                          ? SizedBox(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 50,
                                    child: Text(
                                      "Tel:",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 230,
                                    child: Text(
                                      tel,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width - 180,
                            )
                          : const SizedBox(),
                      email.isNotEmpty
                          ? SizedBox(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 50,
                                    child: Text(
                                      "E-Posta:",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 230,
                                    child: Text(
                                      email,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width - 180,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
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
                  height: 40,
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
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