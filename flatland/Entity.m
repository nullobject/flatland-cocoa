//
//  Player.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "Entity.h"

// Entity movement speed in metres per second.
const CGFloat kMovementSpeed = 100.0f;

// Entity rotation speed in radians per second.
const CGFloat kRotationSpeed = M_2PI;

@implementation Entity

- (Entity *)init {
  if (self = [super initWithImageNamed:@"Spaceship"]) {
    _state = EntityStateIdle;
    
    self.name = [[NSUUID UUID] UUIDString];

    self.scale = 0.25f;

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.mass = 1.0f;
    self.physicsBody.restitution = 0.2f;
  }

  return self;
}

- (void)idle {
  _state = EntityStateIdle;
}

- (void)moveBy:(CGFloat)amount {
  _state = EntityStateMoving;

  CGFloat clampedAmount = NORMALIZE(amount),
          x = -sinf(self.zRotation) * clampedAmount * kMovementSpeed,
          y =  cosf(self.zRotation) * clampedAmount * kMovementSpeed;

  // Calculate the time it takes to move the given distance.
  NSTimeInterval duration = (DISTANCE(x, y) * clampedAmount) / kMovementSpeed;

  [self runAction:[SKAction moveByX:x y:y duration:duration]];
}

- (void)turnBy:(CGFloat)amount {
  _state = EntityStateTurning;

  CGFloat clampedAmount = NORMALIZE(amount),
          angle = clampedAmount * kRotationSpeed;
  NSTimeInterval duration = (M_2PI * clampedAmount) / kRotationSpeed;

  [self runAction:[SKAction rotateByAngle:angle duration:duration]];
}

- (NSDictionary *)asJSON {
  return @{@"id":       self.name,
           @"state":    [self entityStateAsString:self.state],
           @"position": [self pointAsDictionary:self.position],
           @"rotation": [NSNumber numberWithFloat:self.zRotation]};
}

#pragma mark - Private methods

- (NSString *)entityStateAsString:(EntityState) state {
  switch (state) {
    case EntityStateAttacking: return @"attacking";
    case EntityStateMoving:    return @"moving";
    case EntityStateTurning:   return @"turning";
    default:                   return @"idle";
  }
}

- (NSDictionary *)pointAsDictionary:(CGPoint)point {
  return @{@"x": [NSNumber numberWithFloat:point.x],
           @"y": [NSNumber numberWithFloat:point.y]};
}

@end
