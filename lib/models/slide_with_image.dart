import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koto/pages/news_det.dart';

import '../const.dart';

class SlideWithImage extends StatelessWidget {
  const SlideWithImage({
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
        Get.to(
          () => NewsDet(
            "http://koto.org.tr/${href.toString()}",
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
                    color: mainColor,
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
                  color: mainColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
