import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koto/const.dart';

class SinglePerson extends StatelessWidget {
  const SinglePerson({
    Key? key,
    required this.title,
    required this.image,
    required this.name,
    required this.company,
    required this.tel,
    required this.email,
  }) : super(key: key);

  final String title;
  final String? image;
  final String name;
  final String company;
  final String tel;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      width: double.infinity / 2,
      child: Stack(
        children: [
          Container(
            height: 150,
            margin: const EdgeInsets.only(top: 35),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
              color: const Color(0xFFF3F3F3),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image!.isNotEmpty
                    ? Container(
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                            )
                          ],
                          color: Theme.of(context).canvasColor,
                          image: const DecorationImage(
                            image: NetworkImage(
                              'http://koto.org.tr/images/arkaplan.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 5),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Image(
                            image: NetworkImage(
                              image!.startsWith('http')
                                  ? image!
                                  : 'http://koto.org.tr/$image',
                              headers: {},
                            ),
                            height: 150,
                            width: 110,
                            fit: BoxFit.fitHeight,
                            loadingBuilder: (context, img, event) {
                              if (event == null) return img;
                              return const SizedBox(
                                height: 150,
                                width: 110,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: mainColor,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, exp, stack) {
                              return const SizedBox(
                                width: 110,
                                height: 150,
                              );
                            },
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 110,
                        height: 150,
                      ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: Get.width - 170,
                            padding: const EdgeInsets.only(bottom: 5, top: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2B2B2B),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            right: MediaQuery.of(context).size.width / 4,
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
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          company,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width - 170,
                      ),
                      tel.isNotEmpty
                          ? SizedBox(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 50,
                                    child: Text(
                                      "Tel:",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 220,
                                    child: Text(
                                      tel,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width - 170,
                            )
                          : const SizedBox(),
                      email.isNotEmpty
                          ? SizedBox(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 50,
                                    child: Text(
                                      "E-Posta:",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 220,
                                    child: Text(
                                      email,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width - 170,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: mainColor,
                  ),
                  height: 40,
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
