import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
 const SkeletonLoader({required this.height});
  final double height ;
  @override
  Widget build(BuildContext context) {
    return
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.grey,
                ),
                width: 80, // Approximate width of your source tag
                height: 40, // Increased height
              ),
            ),
            const SizedBox(height: 10.0),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey,
                ),
                width: double.infinity, // Width of the title
                height: 40, // Increased height
                 // Changed from Colors.white to Colors.grey
              ),
            ),
          ], ) ;
  }
}
