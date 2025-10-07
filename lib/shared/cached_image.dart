import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:straysave/shared/loading.dart';

//makes image that will be cached into user device so i can save even 0.0000001 cent in bandwith
class CachedImage extends StatelessWidget {
  final String? imgUrl;
  final double? width;
  final double? height;
  final double placeholderSize;
  final double borderRadius;

  const CachedImage({
    super.key,
    this.imgUrl,
    this.width,
    this.height,
    this.placeholderSize = 80,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: imgUrl != null && imgUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imgUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: Loading()),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.pets, size: placeholderSize)),
              )
            : Center(child: Icon(Icons.pets, size: placeholderSize)),
      ),
    );
  }
}
