import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koto/pages/news_det.dart';

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
