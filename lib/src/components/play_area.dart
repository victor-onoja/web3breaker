import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:web3breaker/src/web3_breaker.dart';

class PlayArea extends RectangleComponent with HasGameReference<Web3Breaker> {
  PlayArea()
      : super(
            paint: Paint()..color = const Color(0xfff2e8cf),
            children: [RectangleHitbox()]);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
