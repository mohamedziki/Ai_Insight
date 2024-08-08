import 'package:flutter/material.dart';

class CustomTag extends StatelessWidget {
  const CustomTag(
      {super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFfcb0f3), // Lighter blue
            Color(0xFF3d05dd),
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(mainAxisSize: MainAxisSize.min,children: children,),
    );
  }
}
