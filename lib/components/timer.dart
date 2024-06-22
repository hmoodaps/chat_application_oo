import 'dart:async';

import 'package:flutter/material.dart';
class MyTimer extends StatefulWidget {
   final VoidCallback onStopRecording;

  const MyTimer({super.key, required this.onStopRecording});

  @override
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _stopTimer() {
    _timer.cancel();
    widget.onStopRecording();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _formatTime(_seconds),
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: _stopTimer,
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
