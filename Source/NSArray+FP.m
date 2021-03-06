//
//  NSArray+FP.m
//  Flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "NSArray+FP.h"

@implementation NSArray (FP)

- (NSArray *)map:(MapBlock)block {
  NSMutableArray *resultArray = [NSMutableArray new];
  for (id object in self) {
    [resultArray addObject:block(object)];
  }
  return resultArray;
}

- (id)head {
  return [self objectAtIndex:0];
}

- (NSArray *)tail {
  NSRange tailRange;
  tailRange.location = 1;
  tailRange.length = [self count] - 1;
  return [self subarrayWithRange:tailRange];
}

- (id)find:(BOOL (^)(id object, NSUInteger index, BOOL *stop))predicate {
  NSUInteger index = [self indexOfObjectPassingTest:predicate];

  if (index != NSNotFound)
    return [self objectAtIndex:index];
  else
    return nil;
}

@end
