//
//  SpawnPlayerTests.m
//  Flatland
//
//  Created by Josh Bassett on 22/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AcceptanceTestCase.h"

@interface PlayerSpawnTests : AcceptanceTestCase
@end

@implementation PlayerSpawnTests

- (void)testSpawnPlayer {
  NSUUID *playerUUID = [NSUUID UUID];
  NSDictionary *response = [self runAction:@"spawn" forPlayer:playerUUID parameters:nil timeout:5];
  NSDictionary *playerState = [self playerStateForPlayer:playerUUID withResponse:response];

  expect([playerState objectForKey:@"state"]).to.equal(@"resting");
}

- (void)testSpawnPlayerWhenPlayerIsAlive {
  NSUUID *playerUUID = [NSUUID UUID];

  [self runAction:@"spawn" forPlayer:playerUUID parameters:nil timeout:5];

  NSDictionary *response = [self runAction:@"spawn" forPlayer:playerUUID parameters:nil timeout:5];

  expect([response objectForKey:@"code"]).to.equal(5);
  expect([response objectForKey:@"error"]).to.equal(@"Player has already spawned");
}

@end