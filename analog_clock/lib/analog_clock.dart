// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:analog_clock/date_widget.dart';
import 'package:analog_clock/secound_hand.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'clock_dial.dart';
import 'hour_hand.dart';
import 'minute_hand.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);
  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: Color(0xFF239B56), // Hour hand.
            highlightColor: Color(0xFF239B56), // Minute hand.
            accentColor: Color(0xFFE67E22), // Second hand.
            backgroundColor: Color(0xFFECF0F1),
            textSelectionColor: Color(0xFF148F77),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFFEFCFC), // Hour hand.
            highlightColor: Color(0xFFFEFCFC), // Minute hand.
            accentColor: Color(0xFFD83512), // Second hand.
            backgroundColor: Color(0xFF3C4043),
            textSelectionColor: Color(0xFFFEFCFC),
          );

    final time = DateFormat.Hms().format(DateTime.now());

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: CustomPaint(
                  painter: ClockDial(customTheme: customTheme),
                ),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      Colors.blueGrey[400],
                      Colors.blueGrey[600],
                      Colors.blueGrey[700],
                      Colors.blueGrey[800],
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 140),
              child: DateWidget(),
            ),
            HourHand(
              color: customTheme.highlightColor,
              thickness: 6,
              size: 0.8,
              angleRadians:
                  2 * math.pi * ((_now.hour / 12) + (_now.minute / 720)),
            ),
            MinuteHand(
              color: customTheme.highlightColor,
              thickness: 6,
              size: 0.8,
              angleRadians:
                  2 * math.pi * ((_now.minute + (_now.second / 60)) / 60),
            ),
            SecondHand(
              color: customTheme.accentColor,
              thickness: 2,
              size: 0.9,
              angleRadians: _now.second * radiansPerTick,
            ),
            Positioned(
              top: 0,
              left: 4,
              child: SvgPicture.asset('assets/cloudy-day-1.svg'),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: DefaultTextStyle(
                  style: TextStyle(
                      color: customTheme.primaryColor,
                      fontWeight: FontWeight.bold),
                  child: Text(_temperature)),
            )
          ],
        ),
      ),
    );
  }
}
