import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final Duration currentPosition;
  final Duration totalDuration;
  final Function(Duration) onSeek;

  const ProgressBar({
    required this.currentPosition,
    required this.totalDuration,
    required this.onSeek,
    super.key,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double _sliderValue = 0;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _updateSliderValue();
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSliding) {
      _updateSliderValue();
    }
  }

  void _updateSliderValue() {
    setState(() {
      _sliderValue = widget.totalDuration.inMilliseconds > 0
          ? widget.currentPosition.inMilliseconds /
                widget.totalDuration.inMilliseconds
          : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _sliderValue.clamp(0.0, 1.0),
          onChanged: (newValue) {
            setState(() {
              _isSliding = true;
              _sliderValue = newValue;
            });
          },
          onChangeEnd: (newValue) {
            final newPosition = Duration(
              seconds: (newValue * widget.totalDuration.inSeconds).toInt(),
            );
            widget.onSeek(newPosition);
            setState(() {
              _isSliding = false;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(widget.currentPosition),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                _formatDuration(widget.totalDuration),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
