import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:koto/Network.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic pageData = "";
  Future<dynamic> loadPage() async {
    var data = await Network().getPage('app_ind.php');
    pageData = data;
    setState(() {});
  }

  @override
  void initState() {
    loadPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            HtmlWidget(
              pageData,
              customWidgetBuilder: (element) {
                if (element.className == "swiper-container") {
                  print(element.children.first.innerHtml);
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
