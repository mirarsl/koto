import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koto/pages/news_det.dart';

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
