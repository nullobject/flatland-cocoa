//
//  EntityTests.m
//  flatlandTests
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Entity.h"

@interface EntityTests : XCTestCase
@end

@implementation EntityTests {
  Entity *_entity;
}

- (void)setUp {
  [super setUp];
  _entity = [[Entity alloc] init];
}

- (void)tearDown {
  _entity = nil;
  [super tearDown];
}

- (void)testIdleSetsState {
  [_entity idle];
  XCTAssertEquals(_entity.state, EntityStateIdle);
}

- (void)testIdleIncreasesEnergy {
  _entity.energy = 0;
  [_entity idle];
  XCTAssertEquals(_entity.energy, (CGFloat)10);
}

- (void)testEnergyIsClamped {
  _entity.energy = -10;
  XCTAssertEquals(_entity.energy, (CGFloat)0);

  _entity.energy = 110;
  XCTAssertEquals(_entity.energy, (CGFloat)100);
}

- (void)testMoveSetsState {
  [_entity moveBy:1];
  XCTAssertEquals(_entity.state, EntityStateMoving);
}

- (void)testMoveDecreasesEnergy {
  [_entity moveBy:1.0];
  XCTAssertEquals(_entity.energy, (CGFloat)80);

  [_entity moveBy:-0.5];
  XCTAssertEquals(_entity.energy, (CGFloat)70);
}

- (void)testTurnSetsState {
  [_entity turnBy:1.0];
  XCTAssertEquals(_entity.state, EntityStateTurning);
}

- (void)testTurnDecreasesEnergy {
  [_entity turnBy:1.0];
  XCTAssertEquals(_entity.energy, (CGFloat)80);

  [_entity turnBy:-0.5];
  XCTAssertEquals(_entity.energy, (CGFloat)70);
}

@end
