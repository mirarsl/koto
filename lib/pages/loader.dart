import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:koto/pages/news_det.dart';

import '../const.dart';

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      Get.to(NewsDet(dynamicLinkData.link.toString()));
    });
  }

  void goHome() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    Navigator.popAndPushNamed(context, '/start');
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    goHome();
  }

  @override
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();
    var first = DateTime(1897);

    var dif = today.difference(first);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Image(
                  image: AssetImage('images/logo2.png'),
                  height: 100,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextLiquidFill(
                      loadDuration: const Duration(milliseconds: 1000),
                      waveDuration: const Duration(milliseconds: 1000),
                      text: (dif.inDays ~/ 365).toString() + '. yıl',
                      waveColor: mainColor,
                      boxBackgroundColor: Theme.of(context).canvasColor,
                      textStyle: const TextStyle(
                        fontSize: 100,
                        color: mainColor,
                        fontFamily: 'GreatVibes',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DynamicLinkService {
  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      if (deepLink != null) {
        /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestScreen()));*/
        print(deepLink);
      }

      FirebaseDynamicLinks.instance.onLink;
    } catch (e) {
      print(e.toString());
    }
  }

  ///createDynamicLink()
}
