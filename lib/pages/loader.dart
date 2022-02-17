import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  void goHome() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    Navigator.popAndPushNamed(context, '/start');
  }

  @override
  void initState() {
    goHome();
    super.initState();
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
