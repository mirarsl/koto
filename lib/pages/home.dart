import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:koto/Network.dart';
import 'package:koto/pages/web_page.dart';

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
    var data = await Network().getPage('app_ind.php');
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

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      rtlOpening: true,
      controller: advancedDrawerController,
      backdropColor: Colors.white24,
      drawer: const AdvDrawer(),
      child: Scaffold(
        appBar: MyAppBar(advController: advancedDrawerController),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            children: [
              HtmlWidget(
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
                          return MainSlide(
                            imgAttr: imgAttr,
                            text: text,
                            href: href!,
                          );
                        },
                        itemCount: swipes.length,
                        pagination: SwiperPagination(
                          builder: SwiperCustomPagination(builder:
                              (BuildContext context,
                                  SwiperPluginConfig config) {
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
                        ),
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
                              color: Color(0xFF1F8281),
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
                    var swipes = element.children.first.children;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: (MediaQuery.of(context).size.width / 16) * 11,
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
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(20.0),
                            width: double.infinity,
                            height:
                                (MediaQuery.of(context).size.width / 16) * 11,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    text,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F8281),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 2,
                                      color: Color(0xFF1F8281),
                                    ),
                                    Container(
                                      width: 25,
                                      height: 2,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Text(date),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  desc,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                OutlinedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF1F8281),
                                    ),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebPage(
                                          "http://koto.org.tr/${href.toString()}",
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text("Devamını Gör"),
                                ),
                              ],
                            ),
                          );
                        },
                        pagination: SwiperCustomPagination(
                          builder: (BuildContext context,
                              SwiperPluginConfig config) {
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
                                      color: config.activeIndex == i
                                          ? const Color(0xFF1F8281)
                                          : Colors.grey,
                                    ),
                                  ).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                        itemCount: swipes.length,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar(cIndex: 0),
      ),
    );
  }
}

class MainSlide extends StatelessWidget {
  const MainSlide({
    Key? key,
    required this.imgAttr,
    required this.text,
    this.href,
  }) : super(key: key);

  final LinkedHashMap<Object, String> imgAttr;
  final String text;
  final String? href;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebPage(
              "http://koto.org.tr/${href.toString()}",
            ),
          ),
        );
      },
      child: Column(
        children: [
          Image.network(
            imgAttr['src'] != "" ? "http://koto.org.tr/${imgAttr['src']}" : "",
            loadingBuilder: (context, img, event) {
              if (event == null) return img;

              return SizedBox(
                height: (MediaQuery.of(context).size.width / 16) * 9,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1F8281),
                  ),
                ),
              );
            },
            height: (MediaQuery.of(context).size.width / 16) * 9,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            height: (MediaQuery.of(context).size.width / 16) * 3,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 5, color: Color(0xFF1F8281)),
              ),
            ),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F8281),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
