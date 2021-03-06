//
//  BattleScene.m
//  Flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BattleScene.h"
#import "Collidable.h"
#import "Core.h"
#import "NSArray+FP.h"
#import "Player.h"
#import "PlayerOverlayNode.h"
#import "SKColor+Relative.h"
#import "World.h"

@implementation BattleScene

- (id)initWithWorld:(World *)world size:(CGSize)size {
  if (self = [super initWithSize:size]) {
    _world = world;

    self.backgroundColor = [SKColor colorWithRGB:0x123456];
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);

    [self addWalls];
  }

  return self;
}

- (void)didSimulatePhysics {
  // Update the player overlay positions.
  [_world.players enumerateKeysAndObjectsUsingBlock:^(NSUUID *uuid, Player *player, BOOL *stop) {
    player.playerOverlayNode.position = player.position;
  }];
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
  SKNode *node = contact.bodyA.node;

  if ([node respondsToSelector:@selector(didCollideWith:)]) {
    [(id <Collidable>)node didCollideWith:contact.bodyB];
  }

  node = contact.bodyB.node;

  if ([node respondsToSelector:@selector(didCollideWith:)]) {
    [(id <Collidable>)node didCollideWith:contact.bodyA];
  }
}

#pragma mark - Private

- (void)addWalls {
  [self addCollisionWallAtPoint:CGPointMake(0.0f, 0.0f) withWidth:self.frame.size.width height:1.0f];
  [self addCollisionWallAtPoint:CGPointMake(0.0f, 0.0f) withWidth:1.0f height:self.frame.size.height];
  [self addCollisionWallAtPoint:CGPointMake(0.0f, self.frame.size.height) withWidth:self.frame.size.width height:1.0f];
  [self addCollisionWallAtPoint:CGPointMake(self.frame.size.width, 0.0f) withWidth:1.0f height:self.frame.size.height];
}

- (void)addCollisionWallAtPoint:(CGPoint)point
                      withWidth:(CGFloat)width
                         height:(CGFloat)height {
  CGRect rect = CGRectMake(0, 0, width, height);
  SKNode *wallNode = [SKNode node];
  wallNode.name = @"wall";
  wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
  wallNode.position = CGPointMake(point.x + rect.size.width * 0.5, point.y + rect.size.height * 0.5);
  wallNode.physicsBody.dynamic = NO;
  wallNode.physicsBody.friction = 0.2f;
  wallNode.physicsBody.categoryBitMask = ColliderTypeWall;
  wallNode.physicsBody.collisionBitMask = ColliderTypeEntity | ColliderTypeBullet;
  wallNode.physicsBody.collisionBitMask = ColliderTypeBullet;
  [self addChild:wallNode];
}

@end
