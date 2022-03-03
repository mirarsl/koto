import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:koto/models/swiper_button.dart';

SwiperPagination kotoSliderArrow(SwiperController controller) {
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
                controller.previous();
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
                controller.next();
              },
            ),
          ),
        ],
      );
    }),
  );
}
