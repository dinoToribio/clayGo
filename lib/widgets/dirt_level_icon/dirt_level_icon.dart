import 'package:claygo_app/core/core.dart';
import 'package:claygo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DirtLevelIcon extends StatelessWidget {
  final double height;
  final double width;
  final bool isOnline;
  final int dirtLevel;
  const DirtLevelIcon({
    super.key,
    required this.height,
    required this.width,
    required this.isOnline,
    required this.dirtLevel,
  });
  @override
  Widget build(BuildContext context) {
    return TableContainer(
      height: height,
      width: width,
      containerColor: getOfflineOrWarningColor(
        isOnline: isOnline,
        color: Colors.blue,
        showWarningColor: dirtLevel == 100,
      ),
      containerCapColor: Colors.grey,
      fillLevel: dirtLevel.toDouble(),
      fillColor: getOfflineOrWarningColor(
        isOnline: isOnline,
        color: Colors.brown,
        showWarningColor: dirtLevel == 100,
      ),
    );
  }
}
