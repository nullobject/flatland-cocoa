//
//  PlayerAction.h
//  Flatland
//
//  Created by Josh Bassett on 2/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : uint8_t {
  PlayerActionTypeSpawn,
  PlayerActionTypeSuicide,
  PlayerActionTypeIdle,
  PlayerActionTypeMove,
  PlayerActionTypeTurn,
  PlayerActionTypeAttack
} PlayerActionType;

@class Player;

// Represents an action submitted by a player.
@interface PlayerAction : NSObject

@property (nonatomic, readonly) PlayerActionType type;
@property (nonatomic, readonly, strong) NSDictionary *options;
@property (nonatomic, readonly) CGFloat cost;

- (id)initWithType:(PlayerActionType)type andOptions:(NSDictionary *)options;

- (void)applyToPlayer:(Player *)player;

+ (id)playerActionWithType:(PlayerActionType)type andOptions:(NSDictionary *)options;

@end