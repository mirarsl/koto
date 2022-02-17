import 'package:flutter/material.dart';

import '../const.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
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
              fontSize: 18,
              fontWeight: FontWeight.w700,
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
