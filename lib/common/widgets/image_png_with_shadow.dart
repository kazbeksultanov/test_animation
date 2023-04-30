import 'dart:ui';

import 'package:flutter/material.dart';

class ImagePngWithShadow extends StatelessWidget {
  final String assetUrl;
  final String tag;

  const ImagePngWithShadow({
    super.key,
    required this.assetUrl,
    required this.tag,
  });

  Widget _imagePlacement({required Widget child}) {
    return Positioned(
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 0),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Stack(
        children: [
          _imagePlacement(
            child: Opacity(
              opacity: 0.5,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Image.asset(
                  assetUrl,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _imagePlacement(
            child: Image.asset(assetUrl),
          ),
        ],
      ),
    );
  }
}
