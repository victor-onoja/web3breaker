import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:web3breaker/src/web3_breaker.dart';

import 'components.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<Web3Breaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]);

  final Vector2 velocity;
  final double difficultyModifier;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  // @override
  // void onCollisionStart(
  //     Set<Vector2> intersectionPoints, PositionComponent other) {
  //   super.onCollisionStart(intersectionPoints, other);
  //   if (other is PlayArea) {
  //     if (intersectionPoints.first.y <= 0) {
  //       velocity.y = -velocity.y;
  //     } else if (intersectionPoints.first.x <= 0) {
  //       velocity.x = -velocity.x;
  //     } else if (intersectionPoints.first.x >= game.width) {
  //       velocity.x = -velocity.x;
  //     } else if (intersectionPoints.first.y >= game.height) {
  //       add(RemoveEffect(
  //           delay: 0.35,
  //           onComplete: () {
  //             game.playState = PlayState.gameOver;
  //           }));
  //     } else if (other is Bat) {
  //       velocity.y = -velocity.y;
  //       velocity.x = velocity.x +
  //           (position.x - other.position.x) / other.size.x * game.width * 0.3;
  //     } else if (other is Brick) {
  //       if (position.y < other.position.y - other.size.y / 2) {
  //         velocity.y = -velocity.y;
  //       } else if (position.y > other.position.y + other.size.y / 2) {
  //         velocity.y = -velocity.y;
  //       } else if (position.x < other.position.x) {
  //         velocity.x = -velocity.x;
  //       } else if (position.x > other.position.x) {
  //         velocity.x = -velocity.x;
  //       }
  //       velocity.setFrom(velocity * difficultyModifier);
  //     } else {
  //       debugPrint('collision with $other');
  //     }
  //   } else {
  //     debugPrint('collision with $other');
  //   }
  // }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayArea) {
      final point = intersectionPoints.first;
      if (point.y <= 0) {
        velocity.y = -velocity.y;
      } else if (point.x <= 0) {
        velocity.x = -velocity.x;
      } else if (point.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (point.y >= game.height) {
        add(RemoveEffect(
            delay: 0.35,
            onComplete: () {
              game.playState = PlayState.gameOver;
            }));
      }
    } else if (other is Bat) {
      velocity.y = -velocity.y.abs(); // Ensure the ball always bounces upward
      // Add some horizontal velocity based on where the ball hits the bat
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {
      // Determine which side of the brick was hit
      final brickCenter = other.position;
      final ballCenter = position;
      final collisionPoint = intersectionPoints.first;

      // Calculate relative position of collision
      final relativeY = collisionPoint.y - brickCenter.y;
      final relativeX = collisionPoint.x - brickCenter.x;

      // Determine if collision is more vertical or horizontal
      if (ballCenter.y < brickCenter.y && relativeY.abs() > relativeX.abs()) {
        velocity.y = -velocity.y.abs(); // Top collision
      } else if (ballCenter.y > brickCenter.y &&
          relativeY.abs() > relativeX.abs()) {
        velocity.y = velocity.y.abs(); // Bottom collision
      } else if (ballCenter.x < brickCenter.x) {
        velocity.x = -velocity.x.abs(); // Left collision
      } else {
        velocity.x = velocity.x.abs(); // Right collision
      }

      velocity.setFrom(velocity * difficultyModifier);
    }
  }
}
