import 'package:claygo_app/core/core.dart';
import 'package:claygo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WaterLevelIcon extends StatelessWidget {
  final double height;
  final double width;
  final bool isOnline;
  final int waterLevel;
  const WaterLevelIcon({
    super.key,
    required this.height,
    required this.width,
    required this.isOnline,
    required this.waterLevel,
  });
  @override
  Widget build(BuildContext context) {
    return TableContainer(
      height: height,
      width: width,
      containerColor: getOfflineOrWarningColor(
        isOnline: isOnline,
        color: Colors.blue,
        showWarningColor: waterLevel == 0,
      ),
      containerCapColor: Colors.grey,
      fillLevel: waterLevel.toDouble(),
      fillColor: getOfflineOrWarningColor(
        isOnline: isOnline,
        color: Colors.lightBlue,
        showWarningColor: waterLevel == 0,
      ),
    );
  }
}
