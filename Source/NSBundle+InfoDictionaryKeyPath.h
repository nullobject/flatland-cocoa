//
//  NSBundle+InfoDictionaryKeyPath.h
//  Flatland
//
//  Created by Josh Bassett on 30/07/13.
//  Copyright (c) 2013 Ferocia. All rights reserved.
//

@interface NSBundle (InfoDictionaryKeyPath)

- (id)objectForInfoDictionaryKeyPath:(NSString *)keyPath;

@end
