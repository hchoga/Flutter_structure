import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:touch/core/constants/app_colors.dart';

class CircleAvatarImage extends StatelessWidget {
  final String image;
  final String? position;
  final String name;
  const CircleAvatarImage({
    required this.image,
    required this.position,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.darkD4,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, _) => CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.darkD4,
          child: SizedBox(
            width: 18.w,
            height: 18.h,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, _, _) => CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.darkD4,
          child: Icon(Icons.person, size: 22.r, color: AppColors.darkD3),
        ),
      ),
      title: Text(name),
      subtitle: position == null ? null : Text(position ?? ""),
    );
  }
}
