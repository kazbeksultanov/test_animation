import 'package:flutter/material.dart';
import 'package:test_animation/common/widgets/image_png_with_shadow.dart';
import 'package:test_animation/main_page/m_main_page.dart';

class DetailPage extends StatelessWidget {
  final CardItemData data;

  const DetailPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Hero(
          tag: data.tagBox,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            child: CustomPaint(
              painter: OpenPainter(data.color),
            ),
          ),
        ),
        Positioned(
          top: 80,
          left: 16,
          right: 16,
          child: ImagePngWithShadow(
            assetUrl: data.assetUrl,
            tag: data.tagImage,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              AppBar(
                elevation: 0,
                title: Text(data.brandName),
                centerTitle: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OpenPainter extends CustomPainter {
  final Color color;

  OpenPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    var paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    //a circle
    canvas.drawCircle(Offset(w / 1.5, h / 5), w / 1.4, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
