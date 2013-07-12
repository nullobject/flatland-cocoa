//
//  Game.h
//  flatland
//
//  Created by Josh Bassett on 24/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Server.h"
#import "World.h"

@interface Game : NSObject <ServerDelegate>

@property (nonatomic, readonly, strong) Server *server;
@property (nonatomic, readonly, strong) World *world;

// Ticks the world.
- (void)tick;

@end
