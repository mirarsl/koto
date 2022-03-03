import 'package:flutter/material.dart';
import 'package:koto/const.dart';

class ListVideoItem extends StatelessWidget {
  const ListVideoItem({
    Key? key,
    required this.imageLink,
    required this.text,
  }) : super(key: key);

  final String? imageLink;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
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
          height: (MediaQuery.of(context).size.width / 16) * 9,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: (MediaQuery.of(context).size.width / 16) * 3,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
