import 'package:flutter/material.dart';
import 'package:jamboard/components/Globals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.button_color = const Color(0xffA7F2D0),
    this.text_color = const Color(0xff000000),
  });

  final String text;
  final VoidCallback onPressed;
  Color? button_color;
  Color? text_color;  

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: button_color,
        fixedSize: const Size(366, 61.6),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.3,
          fontWeight: FontWeight.bold,
          color: text_color,
        ),
      ),
    );
  }
}
class NextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const NextButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff90DAB9),
        fixedSize: const Size(125, 50),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Icon(
            icon,
            color: Colors.black,
            size: 30,
          ),
        ],
      ),
    );
  }
}
class GridButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final double? height;  // Optional height
  final double? width;   // Optional width

  const GridButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.height,  // Optional
    this.width,   // Optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 21.sp),
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
        ),
      ),
    );
  }
}
class SquareButton extends StatelessWidget {

  double height = Globals.screenHeight;
  double width = Globals.screenWidth;

  final String text;
  Color? text_color = Colors.black;
  Color? button_color;
  final VoidCallback onPressed;

  SquareButton({
    super.key,
    required this.text,
    this.text_color,
    this.button_color = const Color(0xffAD80FF),
    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                child: Text(text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    wordSpacing: 2,
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              Align(
                child: Icon(Icons.arrow_forward,
                  size: 36,),
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: button_color,
            borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }
}