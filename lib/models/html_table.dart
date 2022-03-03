import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:koto/const.dart';
import 'package:koto/pages/news_det.dart';

class MyHtmlTable extends StatelessWidget {
  const MyHtmlTable({
    Key? key,
    required this.tableHeight,
    required this.heads,
    required this.rows,
  }) : super(key: key);

  final double tableHeight;
  final List heads;
  final List rows;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tableHeight,
      child: Row(
        children: [
          Expanded(
            child: ExpandableTable(
              scrollShadowColor: mainColor.withOpacity(.1),
              headerHeight: 60,
              firstColumnWidth: 0,
              cellWidth: heads.length <= 3
                  ? (MediaQuery.of(context).size.width - 40) / heads.length
                  : 100,
              header: ExpandableTableHeader(
                firstCell: const SizedBox(),
                children: heads
                    .map(
                      (e) => TableCell(
                        text: e.text,
                        bgColor: Color(0xFFEAEAEA),
                        href: "",
                      ),
                    )
                    .toList(),
              ),
              rows: rows.map((e) {
                var flag = -1;
                return ExpandableTableRow(
                  height: 80,
                  firstCell: const SizedBox(),
                  children: heads.map(
                    (en) {
                      ++flag;
                      String href = "";
                      if (e.children[flag].children.isNotEmpty) {
                        if (e.children[flag].children.first.localName == "a") {
                          href = e
                              .children[flag].children.first.attributes["href"];
                        }
                      }
                      return TableCell(
                        text: e.children[flag].text,
                        bgColor: Colors.white,
                        href: href,
                      );
                    },
                  ).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TableCell extends StatelessWidget {
  final String text;
  final Color bgColor;
  final String href;
  const TableCell({
    required this.text,
    required this.bgColor,
    required this.href,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.zero,
      onPressed: href != ""
          ? () {
              if (!href.startsWith('app_')) {
                if (href.startsWith('http')) {
                  launchURL(href);
                } else {
                  launchURL('http://koto.org.tr/$href');
                }
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDet(
                      'http://koto.org.tr/$href',
                    ),
                  ),
                );
              }
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            width: 1,
            color: mainColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
