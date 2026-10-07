import 'package:flutter/material.dart';

class TypewriterHint extends StatefulWidget {
  const TypewriterHint({
    super.key,
    required this.prefix,
    required this.texts,
    required this.currentIndex,
    required this.style,
  });

  final String prefix;
  final List<String> texts;
  final int currentIndex;
  final TextStyle style;

  @override
  State<TypewriterHint> createState() => _TypewriterHintState();
}

class _TypewriterHintState extends State<TypewriterHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Speed of typing
    );
    _setupAnimation();
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant TypewriterHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex ||
        oldWidget.texts != widget.texts) {
      _controller.reset();
      _setupAnimation();
      _controller.forward();
    }
  }

  void _setupAnimation() {
    final currentText = widget.texts.isEmpty ? '' : widget.texts[widget.currentIndex];
    _characterCount = StepTween(begin: 0, end: currentText.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.texts.isEmpty) return const SizedBox();
    
    final currentText = widget.texts[widget.currentIndex];

    return AnimatedBuilder(
      animation: _characterCount,
      builder: (context, child) {
        String visibleString = currentText.substring(0, _characterCount.value);
        return Text(
          '${widget.prefix}$visibleString\'',
          style: widget.style,
        );
      },
    );
  }
}
