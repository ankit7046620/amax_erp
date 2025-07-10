import 'dart:io';

import 'package:amax_hr/utils/app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amax_hr/constant/assets_constant.dart';

// ignore_for_file: must_be_immutable
class CustomImageWidget extends StatelessWidget {
  final String? imagePath;
  final IconData? imageData;
  final double? height;
  final double? width;
  final double? size;
  final Color? color;
  final Color? placeHolderColor;
  final BoxFit? fit;
  final String? placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? radius;
  final BoxBorder? border;
  final double? placeholderHeight;
  final double? placeholderWidth;

  const CustomImageWidget({
    super.key,
    this.imagePath,
    this.imageData,
    this.height,
    this.width,
    this.size,
    this.color,
    this.placeHolderColor,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.padding,
    this.border,
    this.placeHolder = AssetsConstant.defaultImage,
    this.placeholderHeight,
    this.placeholderWidth,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImage();

    if (alignment != null) {
      imageWidget = Align(alignment: alignment!, child: imageWidget);
    }

    return Padding(padding: padding ?? EdgeInsets.zero, child: InkWell(splashColor: Colors.transparent, onTap: onTap, child: imageWidget));
  }

  Widget _buildImage() {
    Widget imageContent = _buildImageContent();

    // Apply ClipRRect only if radius is provided
    if (radius != null) {
      imageContent = ClipRRect(borderRadius: radius!, child: imageContent);
    }

    // Apply border if provided
    if (border != null) {
      return Container(decoration: BoxDecoration(border: border, borderRadius: radius), child: imageContent);
    }

    return imageContent;
  }

  Widget _buildImageContent() {
    if (imageData != null) {
      return _buildIcon();
    }

    if (imagePath != null && imagePath!.isNotEmpty) {
      return _buildImageFromPath();
    }

    return _buildPlaceholderImage();
  }

  Widget _buildIcon() {
    return SizedBox(height: height, width: width, child: Icon(imageData, size: size, color: color));
  }

  Widget _buildImageFromPath() {
    switch (imagePath!.imageType) {
      case ImageType.svg:
        return _buildSvgImage();
      case ImageType.file:
        return Image.file(File(imagePath!), height: height, width: width, fit: fit ?? BoxFit.cover, color: color);
      case ImageType.network:
        return _buildNetworkImage();
      case ImageType.jpg:
      case ImageType.png:
      default:
        return _buildAssetImage();
    }
  }

  Widget _buildSvgImage() {
    return SizedBox(
      height: height,
      width: width,
      child: SvgPicture.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        placeholderBuilder: (BuildContext context) => _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit,
      imageUrl: imagePath!,
      color: color,
      placeholder: (context, url) => _buildPlaceholderImage(),
      errorWidget: (context, url, error) => _buildPlaceholderImage(),
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(imagePath!, height: height, width: width, fit: fit ?? BoxFit.cover, color: color);
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: SizedBox(
        height: placeholderHeight ?? (height ?? 0),
        width: placeholderWidth ?? (width ?? 0),
        child: placeHolder != null && placeHolder!.endsWith('.svg') ? svgImageWidget() : assetImageWidget(),
      ),
    );
  }

  Widget assetImageWidget() {
    return Image.asset(placeHolder!, fit: BoxFit.fill);
  }

  Widget svgImageWidget() {
    return SvgPicture.asset(placeHolder!, fit: BoxFit.fill);
  }
}