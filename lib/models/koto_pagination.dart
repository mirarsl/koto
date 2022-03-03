import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

import '../const.dart';

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
