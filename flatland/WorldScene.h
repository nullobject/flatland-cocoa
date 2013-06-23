//
//  MyScene.h
//  flatland
//

//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Serializable.h"

@interface WorldScene : SKScene <Serializable>

// Spawns a player with the given UUID.
- (void)spawn:(NSUUID *)UUID;

// Moves the player with the given UUID forwards.
- (void)forward:(NSUUID *)UUID;

// Moves the player with the given UUID backwards.
- (void)reverse:(NSUUID *)UUID;

- (NSData *)toJSON;

@end
