//
//  Server.m
//  flatland
//
//  Created by Josh Bassett on 23/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "RouteResponse+AsyncJSON.h"
#import "Server.h"

NSUInteger kDefaultPort = 8000;
NSString *kXPlayer  = @"X-Player";
NSString *kServer   = @"Server";
NSString *kFlatland = @"Flatland/1.0";

@implementation Server {
  NSMutableDictionary *_playerResponses;
}

- (Server *)init {
  if (self = [super init]) {
    _playerResponses = [[NSMutableDictionary alloc] init];
    [self setPort:kDefaultPort];
    [self setDefaultHeader:kServer value:kFlatland];
    [self setupRoutes];
  }

  return self;
}

- (void)update {
  // Call the player response blocks.
  [_playerResponses enumerateKeysAndObjectsUsingBlock:^(NSUUID *uuid, void (^block)(void), BOOL *stop) {
    block();
  }];

  // Remove all the player responses.
  [_playerResponses removeAllObjects];
}

#pragma - Private methods

// TODO: The responses should be completed with a world view for the player.
- (void)setupRoutes {
	[self put:@"/idle" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    [response beginAsyncJSONResponse];
    void (^block)(void) = ^{
      [response endAsyncJSONResponse:[_delegate server:self didIdlePlayer:uuid withOptions:options]];
    };
    [_playerResponses setObject:block forKey:uuid];
	}];

	[self put:@"/spawn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    [response beginAsyncJSONResponse];
    void (^block)(void) = ^{
      [response endAsyncJSONResponse:[_delegate server:self didSpawnPlayer:uuid withOptions:options]];
    };
    [_playerResponses setObject:block forKey:uuid];
	}];

	[self put:@"/move" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    [response beginAsyncJSONResponse];
    void (^block)(void) = ^{
      [response endAsyncJSONResponse:[_delegate server:self didMovePlayer:uuid withOptions:options]];
    };
    [_playerResponses setObject:block forKey:uuid];
	}];

	[self put:@"/turn" withBlock:^(RouteRequest *request, RouteResponse *response) {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[request header:kXPlayer]];
    NSError *error;
    NSDictionary *options = [NSJSONSerialization JSONObjectWithData:request.body options:kNilOptions error:&error];
    [response beginAsyncJSONResponse];
    void (^block)(void) = ^{
      [response endAsyncJSONResponse:[_delegate server:self didTurnPlayer:uuid withOptions:options]];
    };
    [_playerResponses setObject:block forKey:uuid];
	}];
}

@end
