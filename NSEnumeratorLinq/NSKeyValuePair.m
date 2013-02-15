//
//  NSKeyValuePair.m
//  NSEnumeratorLinq
//
//  Created by Антон Буков on 15.02.13.
//  Copyright (c) 2013 Happy Nation Project. All rights reserved.
//

#import "NSKeyValuePair.h"

@implementation NSKeyValuePair

@synthesize key = _key;
@synthesize value = _value;

+ (id)pairWithKey:(id)key value:(id)value
{
    return [[NSKeyValuePair alloc] initWithKey:key value:value];
}

- (id)initWithKey:(id)key value:(id)value
{
    if (self = [super init])
    {
        self.key = key;
        self.value = value;
    }
    return self;
}

@end
