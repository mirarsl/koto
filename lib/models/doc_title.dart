import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../const.dart';

class DocTitle extends StatelessWidget {
  final String text;
  final String href;
  const DocTitle({
    required this.text,
    required this.href,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        String newHref;
        if (!href.startsWith('http')) {
          newHref = "https://koto.org.tr/" + href;
        } else {
          newHref = href;
        }
        launchURL(newHref);
      },
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFECECEC),
              border: const Border.fromBorderSide(
                BorderSide(width: 2, color: Color(0xFFECECEC)),
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.2),
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                  child: Icon(LineIcons.download),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
