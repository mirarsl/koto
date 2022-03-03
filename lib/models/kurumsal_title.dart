import 'package:flutter/material.dart';
import 'package:koto/const.dart';

class KurumsalTitle extends StatelessWidget {
  const KurumsalTitle({
    required this.text,
    required this.image,
    Key? key,
  }) : super(key: key);

  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 5,
            blurRadius: 10,
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Stack(
        children: [
          Image.network(
            image,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, img, event) {
              if (event == null) return img;

              return const SizedBox(
                height: 140,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: const Alignment(1, .9),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(1),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 10,
                      color: Color(0x20000000),
                    ),
                  ]),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 14,
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
