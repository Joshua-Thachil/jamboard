import 'package:flutter/material.dart';

class SegmentedProgressBar extends StatelessWidget {
  final int totalSteps; // Total number of steps (pages)
  final int currentStep; // Current step (page)

  SegmentedProgressBar({required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(55.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(totalSteps, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              decoration: BoxDecoration(
                color: index < currentStep ? Color(0xff1D6B50) : Color(0xffCFE9DA),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}
