import 'package:flutter/material.dart';

class AccordionTitle extends StatelessWidget {
  final String text;
  final Function onTap;
  const AccordionTitle({
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        onTap();
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFECECEC),
              border: Border.fromBorderSide(
                BorderSide(width: 2, color: Color(0xFFECECEC)),
              ),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0, blurRadius: 10, color: Colors.black26),
              ],
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2B2B2B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
