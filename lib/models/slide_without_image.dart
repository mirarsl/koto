import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koto/pages/news_det.dart';

import '../const.dart';

class SlideWithOutImage extends StatelessWidget {
  final String text;
  final String date;
  final String desc;
  final String href;
  final IconData? icon;
  const SlideWithOutImage({
    required this.text,
    required this.date,
    required this.desc,
    required this.href,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      height: (MediaQuery.of(context).size.width / 16) * 11,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 25,
                          height: 2,
                          color: mainColor,
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
                      desc.replaceAll(RegExp(r"\s+"), ' '),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    mainColor,
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Get.to(
                    () => NewsDet(
                      "http://koto.org.tr/${href.toString()}",
                    ),
                  );
                },
                child: const Text("Devamını Gör"),
              ),
            ],
          ),
          icon != null
              ? Align(
                  alignment: const Alignment(1.2, 1.2),
                  child: Icon(
                    icon,
                    size: 120,
                    color: const Color(0xF000000),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
