import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tickle_game/game/sound_manager.dart';

class LottiePlayer extends StatefulWidget {
  final String animationPath;
  final VoidCallback? onComplete;

  const LottiePlayer({super.key, required this.animationPath, this.onComplete});

  @override
  State<LottiePlayer> createState() => _LottiePlayerState();
}

class _LottiePlayerState extends State<LottiePlayer> {
  @override
  void initState() {
    super.initState();
    SoundManager().playVictory();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.animationPath,
      fit: BoxFit.contain,
      repeat: false,
      onLoaded: (composition) {
        Future.delayed(composition.duration, () {
          widget.onComplete?.call();
        });
      },
    );
  }
}
