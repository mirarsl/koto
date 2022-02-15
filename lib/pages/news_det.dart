import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../Network.dart';
import '../app_bar.dart';
import '../bottom_bar.dart';

class NewsDet extends StatefulWidget {
  final String href;
  const NewsDet(this.href, {Key? key}) : super(key: key);
  @override
  _NewsDetState createState() => _NewsDetState();
}

class _NewsDetState extends State<NewsDet> {
  dynamic pageData = "";
  Future<dynamic> loadPage() async {
    var data = await Network().getPage(widget.href);
    pageData = data;
    setState(() {});
  }

  @override
  void initState() {
    loadPage();
    super.initState();
  }

  final advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      rtlOpening: true,
      controller: advancedDrawerController,
      backdropColor: Colors.white24,
      drawer: const AdvDrawer(),
      child: Scaffold(
        appBar: MyAppBar(advController: advancedDrawerController),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            children: [
              HtmlWidget(
                pageData,
                customWidgetBuilder: (element) {
                  if (element.id == "others") {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar(cIndex: 0),
      ),
    );
  }
}
