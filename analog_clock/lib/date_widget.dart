import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var day = '${now.day}';
    var year = DateFormat.MMM().format(now);

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Colors.white),
          color: Color.fromARGB(40, 0, 0, 0)),
      child: Center(
        child: DefaultTextStyle(
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text(day), Text(year)],
            )),
      ),
    );
  }
}
