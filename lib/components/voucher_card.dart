import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VoucherCard extends StatelessWidget {
  VoucherCard({super.key, required this.image});
  String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          image: DecorationImage(image: CachedNetworkImageProvider(image))),
    );
  }
}
