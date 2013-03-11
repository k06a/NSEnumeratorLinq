//
//  NSKeyValuePair.m
//  NSEnumeratorLinq
//
//  Created by Anton Bukov on 15.02.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"(key: %@ value: %@)",self.key,self.value,nil];
}

@end
