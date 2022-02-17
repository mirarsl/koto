import 'package:flutter/material.dart';

import '../const.dart';

class HeadTitle extends StatelessWidget {
  final String text;
  const HeadTitle({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: Colors.grey,
              ),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2B2B2B),
            ),
          ),
        ),
        Positioned.fill(
          right: MediaQuery.of(context).size.width / 3,
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
    );
  }
}
