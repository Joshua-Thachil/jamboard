import 'dart:async';
import 'package:jamboard/Style/Palette.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class EventCard extends StatefulWidget {
  final File? image;
  final String title;
  final String username;
  final List<String> genres;
  final String dateTime;
  final String location;
  final Function() onPressed; // Card onPressed action
  final List<IconData> icons; // Make icons variable for different cards
  final Function() onLocationPressed; // Function for location button press

  EventCard({
    Key? key,
    this.image,
    required this.title,
    required this.username,
    required this.genres,
    required this.dateTime,
    required this.location,
    required this.onPressed,
    required this.icons, // Icons passed as parameter
    required this.onLocationPressed, // Location button press function
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  int _currentIndex = 0;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _startIconSwitch(); // Automatically start the icon switching when the component is initialized
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks when the widget is removed
    super.dispose();
  }

  void _startIconSwitch() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.icons.length; // Cycle through the passed icons list
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed, // Make the card clickable
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Palette.secondary_bg,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.image != null ? FileImage(widget.image!) : null,
                  child: widget.image == null
                      ? ClipOval(
                    child: Image.asset(
                      'assets/images/image 9.png',
                      fit: BoxFit.cover,
                    ),
                  )
                      : null,
                ),
                SizedBox(width: 20),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        widget.username,
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(widget.genres.length * 2 - 1, (index) {
                if (index.isEven) {
                  return Text(
                    widget.genres[index ~/ 2],
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '•',
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                }
              }),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.dateTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: WidgetStateColor.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.location,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(),
                Container(),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: IconButton(
                    key: ValueKey<int>(_currentIndex),
                    icon: Icon(widget.icons[_currentIndex], size: 30, color: Colors.white),
                    onPressed: () {}, // Action on icon press
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class NotificationCard extends StatelessWidget {
  final String notificationText;
  final String timeSent;

  NotificationCard({
    required this.notificationText,
    required this.timeSent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Palette.secondary_bg,  // Use the background color provided
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notificationText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              timeSent,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

