import 'package:flutter/material.dart';

class OverlayPoint extends StatelessWidget {
  const OverlayPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.green,
          child: const SizedBox(
            width: 100,
            height: 100,
            child: Icon(Icons.dew_point, size: 100),
          ),
        ),
      ),
    );
  }
}
