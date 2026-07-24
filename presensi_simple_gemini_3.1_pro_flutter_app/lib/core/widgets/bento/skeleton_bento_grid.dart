import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';

class SkeletonBentoGrid extends StatelessWidget {
  final int itemCount;

  const SkeletonBentoGrid({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColorTokens.border,
      highlightColor: AppColorTokens.surface,
      child: Column(
        children: [
          _buildSkeletonBox(height: 160, width: double.infinity, radius: AppDimensions.radiusBentoLarge),
          const SizedBox(height: AppDimensions.bentoGap),
          Row(
            children: [
              Expanded(child: _buildSkeletonBox(height: 100)),
              const SizedBox(width: AppDimensions.bentoGap),
              Expanded(child: _buildSkeletonBox(height: 100)),
            ],
          ),
          const SizedBox(height: AppDimensions.bentoGap),
          _buildSkeletonBox(height: 200, width: double.infinity, radius: AppDimensions.radiusBentoLarge),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({required double height, double? width, double? radius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white, // Shimmer requires an opaque color to mask over
        borderRadius: BorderRadius.circular(radius ?? AppDimensions.radiusBentoSmall),
      ),
    );
  }
}
