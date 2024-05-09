import 'package:claygo_app/core/core.dart';
import 'package:flutter/material.dart';

class UsageCircularIcon extends StatelessWidget {
  final double size;
  final bool isOnline;
  final double strokeWidth;
  final int maxUsageCount;
  final int usageCount;
  const UsageCircularIcon({
    super.key,
    required this.size,
    required this.isOnline,
    this.strokeWidth = 4.0,
    required this.maxUsageCount,
    required this.usageCount,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        value: 1 -
            getPercentageOf2Numbers(
              startValue: maxUsageCount.toDouble(),
              endValue: usageCount.toDouble(),
            ),
        backgroundColor: usageCount == 0 ? Colors.red : Colors.grey,
        strokeWidth: strokeWidth,
        color: Colors.blue,
      ),
    );
  }
}
