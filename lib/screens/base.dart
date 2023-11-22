import 'package:flutter/material.dart';

mixin Base {
  Widget networkImgWidget(
    String path, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.network(
      path,
      fit: fit,
      width: width,
      height: height,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/not_found.jpg',
          fit: fit,
          width: width,
          height: height,
        );
      },
    );
  }

  Widget errorWidget(BuildContext context, Object? err) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Center(
          child: Text(
            err.toString(),
          ),
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
