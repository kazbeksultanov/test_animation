import 'package:flutter/material.dart';

class Tab4MyBag extends StatelessWidget {
  const Tab4MyBag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(runtimeType.toString()),
    );
  }
}
