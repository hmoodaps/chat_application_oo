import 'dart:math';
import 'package:flutter/material.dart';

class ExplodeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;
  final VoidCallback onComplete;

  const ExplodeText({
    super.key,
    required this.text,
    required this.style,
    required this.duration,
    required this.onComplete,
  });

  @override
  _ExplodeTextState createState() => _ExplodeTextState();
}

class _ExplodeTextState extends State<ExplodeText> with TickerProviderStateMixin {
  bool _exploded = false;
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete();
        }
      });
    _generateParticles();
    Future.delayed(widget.duration, () {
      _startExplosion();
    });
  }

  void _generateParticles() {
    _particles = [];
    for (int i = 0; i < 100; i++) {
      _particles.add(Particle(
        x: _random.nextDouble() * 2 - 1,
        y: _random.nextDouble() * 2 - 1,
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
        controller: _controller,
      ));
    }
  }

  void _startExplosion() {
    setState(() {
      _exploded = true;
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _exploded
          ? Stack(
        children: _particles.map((particle) => particle.build(context)).toList(),
      )
          : Text(widget.text, style: widget.style),
    );
  }
}

class Particle {
  final double x;
  final double y;
  final Color color;
  final AnimationController controller;

  Particle({
    required this.x,
    required this.y,
    required this.color,
    required this.controller,
  });

  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(x * controller.value * 100, y * controller.value * 100),
          child: FadeTransition(
            opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        );
      },
    );
  }
}
