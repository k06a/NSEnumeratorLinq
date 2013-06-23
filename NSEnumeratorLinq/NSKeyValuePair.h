//
//  NSKeyValuePair.h
//  NSEnumeratorLinq
//
//  Created by Anton Bukov on 15.02.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSKeyValuePair : NSObject

@property (nonatomic) id key;
@property (nonatomic) id value;

- (id)kvKey;
- (id)kvValue;

+ (id)pairWithKey:(id)key value:(id)value;
- (id)initWithKey:(id)key value:(id)value;

- (NSString *)description;

@end
