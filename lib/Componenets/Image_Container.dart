import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    this.borderRadius = 0,
    this.padding,
    required this.width,
    required this.image,
    this.height = 130,
    this.child,
    this.margin,
    this.showShadow = false,
    super.key,
  });
  final double height;
  final double width;
  final String image;
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final bool showShadow ;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: precacheImage(NetworkImage(image), context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // While the image is loading,  the Shimmer.
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
             // padding: const EdgeInsets.only(
                  //top: 17.0, left: 12.0, right: 12, bottom: 10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey,
              ),
            ),
          );
        }
        // Once the image is loaded, show the image.
        return Container(
          height: height,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
                image: NetworkImage(
                  image,
                ),
                fit: BoxFit.fill),
            boxShadow: showShadow ? [
              BoxShadow(
                color: Colors.grey.withOpacity(1),
                spreadRadius: 4,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ] : null,
          ),
          child: child,
        );
      },
    );
  }
}
