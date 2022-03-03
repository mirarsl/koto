import 'package:flutter/material.dart';

class SingleNews extends StatelessWidget {
  final String text;
  final Function onTap;
  final String date;
  const SingleNews({
    required this.text,
    required this.onTap,
    required this.date,
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
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              border: const Border.fromBorderSide(
                BorderSide(width: 2, color: Color(0xFFECECEC)),
              ),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(.1)),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              children: [
                const Image(
                  image: NetworkImage(
                      'http://koto.org.tr/assets/img/logo-icon.png'),
                  width: 70,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 130,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
