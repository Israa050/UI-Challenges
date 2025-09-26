import 'package:flutter/material.dart';

class AnimationChain extends StatefulWidget {
  const AnimationChain({super.key});

  @override
  State<AnimationChain> createState() => _AnimationChainState();
}

class _AnimationChainState extends State<AnimationChain>
    with TickerProviderStateMixin {
  late AnimationController _controllerDot1;
  late AnimationController _controllerDot2;
  late AnimationController _controllerDot3;

  late Animation<double> _scaleDot1;
  late Animation<double> _scaleDot2;
  late Animation<double> _scaleDot3;

  late Animation<double> _opacityDot1;
  late Animation<double> _opacityDot2;
  late Animation<double> _opacityDot3;

  static const _animationDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _controllerDot1 = _createController();
    _controllerDot2 = _createController();
    _controllerDot3 = _createController();

    // Create animations
    _scaleDot1 = _createScaleAnimation(_controllerDot1);
    _opacityDot1 = _createOpacityAnimation(_controllerDot1);

    _scaleDot2 = _createScaleAnimation(_controllerDot2);
    _opacityDot2 = _createOpacityAnimation(_controllerDot2);

    _scaleDot3 = _createScaleAnimation(_controllerDot3);
    _opacityDot3 = _createOpacityAnimation(_controllerDot3);

    // Add listeners
    _scaleDot1.addStatusListener(_onDot1Completed);
    _scaleDot2.addStatusListener(_onDot2Completed);
    _scaleDot3.addStatusListener(_onDot3Completed);

    // Start the first animation
    _controllerDot1.forward();
  }

  AnimationController _createController() {
    return AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
  }

  Animation<double> _createScaleAnimation(AnimationController controller) {
    return Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  Animation<double> _createOpacityAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  void _onDot1Completed(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controllerDot2.forward();
    }
  }

  void _onDot2Completed(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controllerDot3.forward();
    }
  }

  void _onDot3Completed(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controllerDot1.reset();
      _controllerDot2.reset();
      _controllerDot3.reset();
      _controllerDot1.forward();
    }
  }

  @override
  void dispose() {
    // Remove listeners first
    _scaleDot1.removeStatusListener(_onDot1Completed);
    _scaleDot2.removeStatusListener(_onDot2Completed);
    _scaleDot3.removeStatusListener(_onDot3Completed);

    // Dispose controllers
    _controllerDot1.dispose();
    _controllerDot2.dispose();
    _controllerDot3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Sequential Loading Dots'), centerTitle: true),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedDot(_scaleDot1, _opacityDot1),
            const SizedBox(width: 15),
            _buildAnimatedDot(_scaleDot2, _opacityDot2),
            const SizedBox(width: 15),
            _buildAnimatedDot(_scaleDot3, _opacityDot3),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDot(
      Animation<double> scale, Animation<double> opacity) {
    return FadeTransition(
      opacity: opacity,
      child: ScaleTransition(
        scale: scale,
        child: _buildDot(Colors.blue, 20, 20),
      ),
    );
  }

  Widget _buildDot(Color color, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
