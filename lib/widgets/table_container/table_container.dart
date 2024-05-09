import 'package:flutter/material.dart';

class TableContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color containerColor;
  final Color containerCapColor;
  final double fillLevel;
  final Color fillColor;

  const TableContainer({
    super.key,
    required this.height,
    required this.width,
    required this.containerColor,
    required this.containerCapColor,
    required this.fillLevel,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: height * .2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: containerColor,
              width: 2,
            ),
          ),
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: height * (fillLevel / 100),
                  width: width * .8,
                  color: fillColor,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: height * .2,
            width: width,
            decoration: BoxDecoration(
              color: containerCapColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
