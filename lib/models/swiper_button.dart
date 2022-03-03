import 'package:flutter/material.dart';

class SwiperButton extends StatelessWidget {
  const SwiperButton(
      {Key? key,
      required this.onPress,
      required this.painterType,
      required this.icon})
      : super(key: key);

  final Function onPress;
  final CustomPainter painterType;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      width: 50,
      height: 50,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: RawMaterialButton(
        onPressed: () {
          onPress();
        },
        child: CustomPaint(
          painter: painterType,
          child: Icon(
            icon,
            size: 50,
            color: Color(0xFF1F8281),
          ),
        ),
      ),
    );
  }
}

class LeftPainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  LeftPainter({
    this.strokeColor = Colors.white,
    this.strokeWidth = 2,
    this.paintingStyle = PaintingStyle.fill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getLeftPath(size.width, size.height), paint);
  }

  Path getLeftPath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x, 0)
      ..lineTo(x + 25, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(LeftPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class RightPainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  RightPainter({
    this.strokeColor = Colors.white,
    this.strokeWidth = 2,
    this.paintingStyle = PaintingStyle.fill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getRightPath(size.width, size.height), paint);
  }

  Path getRightPath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x, 0)
      ..lineTo(x, y)
      ..lineTo(-25, y)
      ..lineTo(0, 0);
  }

  @override
  bool shouldRepaint(RightPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
