import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:koto/Network.dart';
import 'package:koto/const.dart';
import 'package:koto/models/doc_title.dart';
import 'package:koto/models/head_title.dart';
import 'package:koto/models/section_title.dart';
import 'package:koto/models/single_news.dart';
import 'package:koto/pages/news_det.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({Key? key}) : super(key: key);

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  dynamic pageData = "";
  Future<dynamic> loadPage(href) async {
    pageData = "";
    try {
      var data = await Network().getPage(href);
      pageData = data;
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .77,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: mainColor,
                  width: 5,
                ),
              ),
            ),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.5, horizontal: 20),
              child: const Text(
                "ARAMA",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                  color: Colors.black.withOpacity(.2),
                ),
              ],
            ),
            child: Center(
              child: TextField(
                cursorColor: mainColor,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                  hintText: 'Aramak istediğiniz kelimeyi giriniz',
                  hintStyle: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onChanged: (term) {
                  loadPage(
                      'http://koto.org.tr/app_search.php?stype=g&keyword=$term');
                },
              ),
            ),
          ),
          SizedBox(
            height: (Get.height * .77) - 200,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 20,
              ),
              children: [
                pageData != ""
                    ? HtmlWidget(
                        pageData,
                        textStyle:
                            const TextStyle(fontSize: 14.5, height: 1.25),
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
                          } else if (element.className ==
                              "announcement-item mb-4") {
                            var title = element
                                .children[1].children.first.children.first.text;
                            var link = element.children[0].attributes['href'];
                            var date = element
                                .children[1].children.first.children[1].text;
                            // print(title);
                            return SingleNews(
                              text: title,
                              onTap: () {
                                if (link!.isNotEmpty) {
                                  Get.to(() =>
                                      NewsDet("http://koto.org.tr/$link"));
                                }
                              },
                              date: date,
                            );
                          }
                          return null;
                        },
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
