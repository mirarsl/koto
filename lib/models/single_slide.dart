import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:koto/const.dart';

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
