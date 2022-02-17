import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DocTitle extends StatelessWidget {
  final String text;
  const DocTitle({
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
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFECECEC),
            border: Border.fromBorderSide(
              BorderSide(width: 2, color: Color(0xFFECECEC)),
            ),
            boxShadow: [
              BoxShadow(spreadRadius: 0, blurRadius: 10, color: Colors.black26),
            ],
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
    );
  }
}
