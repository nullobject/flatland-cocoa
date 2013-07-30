//
//  PlayerSpawnActionTests.m
//  Flatland
//
//  Created by Josh Bassett on 19/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GameError.h"
#import "OCMock.h"
#import "Player.h"
#import "PlayerSpawnAction.h"

@interface PlayerSpawnActionTests : XCTestCase
@end

@implementation PlayerSpawnActionTests {
  PlayerAction *_playerAction;
  id _player;
}

- (void)setUp {
  [super setUp];
  _player = [OCMockObject mockForClass:Player.class];
  _playerAction = [[PlayerSpawnAction alloc] initWithOptions:@{}];
}

- (void)tearDown {
  _playerAction = nil;
  _player = nil;
  [super tearDown];
}

- (void)testCost {
  expect(_playerAction.cost).to.equal(0);
}

- (void)testApplyToPlayer {
  [[_player expect] spawn:0];
  [_playerAction applyToPlayer:_player];
}

- (void)testValidateReturnsNoErrorWhenPlayerIsDead {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO]] isAlive];
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO]] isSpawning];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beTruthy();
  expect(error).to.beNil();
}

- (void)testValidateReturnsErrorWhenPlayerIsAlive {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isAlive];
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO ]] isSpawning];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beFalsy();
  expect(error.code).to.equal(GameErrorPlayerAlreadySpawned);
}

- (void)testValidateReturnsErrorWhenPlayerIsSpawning {
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:NO ]] isAlive];
  [[[_player stub] andReturnValue:[NSNumber numberWithBool:YES]] isSpawning];

  GameError *error;
  BOOL result = [_playerAction validateForPlayer:_player error:&error];

  expect(result).to.beFalsy();
  expect(error.code).to.equal(GameErrorPlayerAlreadySpawning);
}

@end
