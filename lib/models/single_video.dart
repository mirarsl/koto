import 'package:flutter/material.dart';

import '../const.dart';

class SingleVideo extends StatelessWidget {
  const SingleVideo({
    Key? key,
    required this.imageLink,
    required this.text,
    required this.desc,
  }) : super(key: key);

  final String? imageLink;
  final String text;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 370,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            spreadRadius: 5,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.network(
              imageLink!,
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
              height: 220,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 15,
            ),
            width: double.infinity,
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                ),
                desc != ""
                    ? Expanded(
                        child: Text(
                          desc,
                          textAlign: TextAlign.justify,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
