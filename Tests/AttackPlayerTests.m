//
//  AttackPlayerTests.m
//  Flatland
//
//  Created by Josh Bassett on 30/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AcceptanceTestCase.h"
#import "Core.h"

@interface AttackPlayerTests : AcceptanceTestCase
@end

@implementation AttackPlayerTests

- (void)testAttackPlayer {
  NSUUID *playerUUID = [NSUUID UUID];

  [self doAction:@"spawn" forPlayer:playerUUID parameters:nil timeout:5];

  NSDictionary *response = [self doAction:@"attack" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];
  NSDictionary *playerState = [self playerStateForPlayer:playerUUID withResponse:response];

  expect([playerState objectForKey:@"state"]).to.equal(@"attacking");
  expect([playerState objectForKey:@"energy"]).to.equal(80);
}

- (void)testPlayerKillEnemy {
  NSUUID *playerUUID = [NSUUID UUID];
  NSUUID *enemyUUID = [NSUUID UUID];

  [self player:playerUUID faceEnemy:enemyUUID];
  [self player:playerUUID killEnemy:enemyUUID];
}

- (void)testAttackPlayerWhenPlayerIsDead {
  NSUUID *playerUUID = [NSUUID UUID];
  NSDictionary *response = [self doAction:@"attack" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];

  expect([response objectForKey:@"code"]).to.equal(4);
  expect([response objectForKey:@"error"]).to.equal(@"Player has not spawned");
}

- (void)player:(NSUUID *)playerUUID faceEnemy:(NSUUID *)enemyUUID {
  NSDictionary *response;
  CGPoint a, b;

  response = [self doAction:@"spawn" forPlayer:playerUUID parameters:nil timeout:5];
  NSDictionary *playerState = [self playerStateForPlayer:playerUUID withResponse:response];

  response = [self doAction:@"spawn" forPlayer:enemyUUID parameters:nil timeout:5];
  NSDictionary *enemyState = [self playerStateForPlayer:enemyUUID withResponse:response];

  PointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)[enemyState objectForKey:@"position"], &a);
  PointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)[playerState objectForKey:@"position"], &b);

  CGFloat angle = POLAR_ADJUST(AngleBetweenPoints(a, b));
  CGFloat amount = NORMALIZE_ANGLE(angle);

  [self doAction:@"turn" forPlayer:playerUUID parameters:@{@"amount": [NSNumber numberWithFloat:amount]} timeout:3];
}

- (void)player:(NSUUID *)playerUUID killEnemy:(NSUUID *)enemyUUID {
  NSDictionary *response;
  BOOL alive = YES;

  while (alive) {
    response = [self doAction:@"attack" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];

    if ([response objectForKey:@"error"]) {
      [self doAction:@"rest" forPlayer:playerUUID parameters:@{@"amount": @1} timeout:3];
    } else {
      NSDictionary *enemyState = [self playerStateForPlayer:enemyUUID withResponse:response];
      alive = [[enemyState objectForKey:@"health"] floatValue] > 0;
    }
  }

  NSDictionary *playerState = [self playerStateForPlayer:playerUUID withResponse:response];
  expect([[playerState objectForKey:@"kills"] integerValue]).to.equal(1);
}

@end
