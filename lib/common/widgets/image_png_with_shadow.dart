import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_animation/tabs/tab1_discover.dart';

class ImagePngWithShadow extends StatelessWidget {
  final String assetUrl;
  final String tag;
  final int degree;

  const ImagePngWithShadow({
    super.key,
    required this.assetUrl,
    required this.tag,
    this.degree = 0,
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

  Widget imageWithShadow() {
    return Stack(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: _flightShuttleBuilderImage,
      child: Transform.rotate(
        angle: oneDegree * degree,
        child: imageWithShadow(),
      ),
    );
  }

  Widget _flightShuttleBuilderImage(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final tw = flightDirection == HeroFlightDirection.push
        ? Tween<double>(begin: 0, end: 1)
        : Tween<double>(begin: 1, end: 0);
    tw.animate(animation);
    return TweenAnimationBuilder(
      tween: tw,
      duration: const Duration(milliseconds: 300),
      builder: (_, value, __) {
        return Transform.rotate(
          angle: oneDegree * 12 * value,
          child: imageWithShadow(),
        );
      },
    );
  }
}
