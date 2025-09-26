import 'package:flutter/material.dart';

class PhysicsPlayground extends StatefulWidget {
  const PhysicsPlayground({super.key});

  @override
  State<PhysicsPlayground> createState() => _PhysicsPlaygroundState();
}

class _PhysicsPlaygroundState extends State<PhysicsPlayground> {
  bool _isRedBallDropped = false;
  bool _isGreenBallDropped = false;
  bool _isBlueBallDropped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics Playground'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// Draggables Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDraggableBall(Colors.red),
              _buildDraggableBall(Colors.blue),
              _buildDraggableBall(Colors.green),
            ],
          ),

          /// Drag Targets Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDragTarget(
                color: Colors.red,
                isBallDropped: _isRedBallDropped,
                onBallAccepted: () => setState(() {
                  _isRedBallDropped = true;
                }),
              ),
              _buildDragTarget(
                color: Colors.blue,
                isBallDropped: _isBlueBallDropped,
                onBallAccepted: () => setState(() {
                  _isBlueBallDropped = true;
                }),
              ),
              _buildDragTarget(
                color: Colors.green,
                isBallDropped: _isGreenBallDropped,
                onBallAccepted: () => setState(() {
                  _isGreenBallDropped = true;
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBall(Color color, {double size = 60}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }

  Widget _buildDraggableBall(Color color) {
    return Draggable<Color>(
      data: color,
      feedback: _buildBall(color),
      childWhenDragging: _buildBall(color.withValues(alpha: 0.5)),
      child: _buildBall(color),
    );
  }

  Widget _buildDragTarget({
    required Color color,
    required bool isBallDropped,
    required VoidCallback onBallAccepted,
  }) {
    return DragTarget<Color>(
      onAcceptWithDetails: (details) {
        if (details.data == color) {
          onBallAccepted();
        }
      },
      builder: (context, candidateData, rejectedData) {
        return _buildBox(
          color,
          highlight: candidateData.isNotEmpty,
          hasBall: isBallDropped,
        );
      },
    );
  }

  Widget _buildBox(
    Color color, {
    bool highlight = false,
    bool hasBall = false,
  }) {
    return Container(
      height: 100,
      width: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hasBall
            ? color
            : color.withValues(alpha: highlight ? 0.2 : 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 3),
      ),
      child: highlight
          ? const Text(
              '↓',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : hasBall
              ? const Text(
                  "✓",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const SizedBox.shrink(),
    );
  }
}
