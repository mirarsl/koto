import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:koto/const.dart';
import 'package:koto/pages/news_det.dart';
import 'package:koto/pages/start.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvDrawer extends StatelessWidget {
  const AdvDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 64.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'images/logo.png',
              ),
            ),
            ListTile(
              onTap: () {
                Get.offAll(const Start());
              },
              leading: const Icon(Icons.home),
              title: const Text('Anasayfa'),
            ),
            ListTile(
              onTap: () {
                Get.offAll(const Start());
                Get.to(
                  () => const NewsDet(
                    'http://koto.org.tr/app_iletisim.php',
                    barIndex: 3,
                  ),
                );
              },
              leading: const Icon(Icons.phone),
              title: const Text('İletişim'),
            ),
            // ListTile(
            //   onTap: () {},
            //   leading: const Icon(Icons.settings),
            //   title: const Text('Ayarlar'),
            // ),
            ListTile(
              onTap: () {
                Get.offAll(const Start());
                Get.to(
                  () => const NewsDet(
                    'http://koto.org.tr/app_bilgi_bankasi_det.php?id=2',
                  ),
                );
              },
              leading: const Icon(LineIcons.pollH),
              title: const Text('Üye Anketi'),
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  children: const [
                    SizedBox(
                      width: 70,
                      child: Text(
                        "E-Posta",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "koto@koto.org.tr",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    SizedBox(
                      width: 70,
                      child: Text(
                        "Telefon",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "90 (262) 322 3010",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // DefaultTextStyle(
            //   style: const TextStyle(
            //     fontSize: 12,
            //     color: Colors.white54,
            //   ),
            //   child: Container(
            //     margin: const EdgeInsets.symmetric(
            //       vertical: 16.0,
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         TextButton(
            //           onPressed: () {},
            //           child: const Text(
            //             'Kullanım Şartları',
            //             style: TextStyle(
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //         TextButton(
            //           onPressed: () {},
            //           child: const Text(
            //             "Gizlilik Politikası",
            //             style: TextStyle(
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({required this.advController, Key? key}) : super(key: key);

  final AdvancedDrawerController advController;
  @override
  Size get preferredSize => const Size.fromHeight(85);

  void _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 10,
      backgroundColor: Colors.white,
      toolbarHeight: preferredSize.height,
      foregroundColor: mainColor,
      leading: null,
      title: Image.asset(
        'images/logo3.png',
        height: 70,
      ),
      actions: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: IconButton(
                onPressed: () {
                  _launchURL('https://www.facebook.com/KocaeliKOTO/');
                },
                icon: const Icon(
                  LineIcons.facebookF,
                  size: 22,
                  color: Color(0xFF1F8281),
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: IconButton(
                onPressed: () {
                  _launchURL('https://twitter.com/kocaelitodasi');
                },
                icon: const Icon(
                  LineIcons.twitter,
                  size: 22,
                  color: Color(0xFF1F8281),
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: IconButton(
                onPressed: () {
                  _launchURL('https://www.instagram.com/kocaelito/');
                },
                icon: const Icon(
                  LineIcons.instagram,
                  size: 22,
                  color: Color(0xFF1F8281),
                ),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            advController.showDrawer();
          },
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: advController,
            builder: (_, value, __) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  value.visible ? Icons.clear : Icons.menu,
                  color: const Color(0xFF1F8281),
                  size: 36,
                  key: ValueKey<bool>(value.visible),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
