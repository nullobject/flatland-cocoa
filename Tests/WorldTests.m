//
//  WorldTests.m
//  Flatland
//
//  Created by Josh Bassett on 20/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <XCTest/XCTest.h>

#import "GameError.h"
#import "OCMock.h"
#import "Player.h"
#import "PlayerAction.h"
#import "World.h"

@interface World (Tests)

@property (nonatomic) WorldNode *worldNode;

@end

@interface WorldTests : XCTestCase
@end

@implementation WorldTests {
  World *_world;
}

- (void)setUp {
  [super setUp];
  _world = [[World alloc] init];
}

- (void)tearDown {
  _world = nil;
  [super tearDown];
}

- (void)testSetsPlayers {
  XCTAssertNotNil(_world.players);
}

- (void)testSetsWorldNode {
  XCTAssertNotNil(_world.worldNode);
}

#pragma mark - Tick

- (void)testTickIncrementsAge {
  XCTAssertEquals(_world.age, (NSUInteger)0);
  [_world tick];
  XCTAssertEquals(_world.age, (NSUInteger)1);
}

- (void)testTickTicksPlayers {
  id player = [OCMockObject mockForClass:Player.class];

  NSUUID *uuid = [NSUUID UUID];
  [(NSMutableDictionary *)_world.players setObject:player forKey:uuid];

  [[player expect] tick];
  [_world tick];
  [player verify];
}

#pragma mark - EnqueueAction

- (void)testEnqueueActionEnqueuesActionForPlayer {
  id player = [OCMockObject mockForClass:Player.class];
  id action = [OCMockObject mockForClass:PlayerAction.class];

  NSUUID *uuid = [NSUUID UUID];
  [(NSMutableDictionary *)_world.players setObject:player forKey:uuid];

  [[player expect] enqueueAction:action error:nil];
  [_world enqueueAction:action forPlayer:uuid error:nil];
  [player verify];
}

#pragma mark - Callbacks

- (void)testPlayerDidSpawn {
  id worldNode  = [OCMockObject mockForClass:WorldNode.class];
  id player     = [OCMockObject mockForClass:Player.class];
  id playerNode = [OCMockObject niceMockForClass:PlayerNode.class];

  _world.worldNode = worldNode;
  [[[player stub] andReturn:playerNode] playerNode];

  [[worldNode expect] addChild:playerNode];
  [_world playerDidSpawn:player];
  [worldNode verify];
}

- (void)testPlayerDidDie {
  id player     = [OCMockObject mockForClass:Player.class];
  id playerNode = [OCMockObject niceMockForClass:PlayerNode.class];

  [[[player stub] andReturn:playerNode] playerNode];

  [[playerNode expect] removeFromParent];
  [_world playerDidDie:player];
  [playerNode verify];
}

- (void)testPlayerDidShootBullet {
  id worldNode  = [OCMockObject mockForClass:SKNode.class];
  id player     = [OCMockObject mockForClass:Player.class];
  id playerNode = [OCMockObject mockForClass:SKNode.class];
  id bulletNode = [OCMockObject niceMockForClass:SKNode.class];

  _world.worldNode = worldNode;
  [[[player stub] andReturn:playerNode] playerNode];

  [[worldNode expect] addChild:bulletNode];
  [_world player:player didShootBullet:bulletNode];
  [worldNode verify];
}

#pragma mark - Serializable

- (void)testAsJSONIncludesAge {
  id expected = [NSNumber numberWithUnsignedInteger:0];
  XCTAssertEqualObjects([[_world asJSON] objectForKey:@"age"], expected);
}

- (void)testAsJSONIncludesPlayers {
  id expected = @[];
  XCTAssertEqualObjects([[_world asJSON] objectForKey:@"players"], expected);
}

@end