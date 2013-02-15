//
//  NSEnumeratorLinq.m
//  NSEnumeratorLinq
//
//  Created by Антон Буков on 13.01.13.
//  Copyright (c) 2013 Happy Nation Project. All rights reserved.
//

#import "NSEnumerator+Linq.h"

////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSEnumeratorWrapper : NSEnumerator
@end
@implementation NSEnumeratorWrapper {
    NSEnumerator * _enumerator;
    id(^_func)(NSEnumerator *);
}
- (id)initWithEnumarator:(NSEnumerator *)enumerator andFunc:(id(^)(NSEnumerator *))func {
    if (self = [super init]) {
        _enumerator = enumerator;
        _func = func;
    }
    return self;
}
- (id)nextObject {
    return _func(_enumerator);
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSDictionary (KeyValueEnumerator)
- (NSEnumerator *)keyValueEnumerator;
@end
@implementation NSDictionary (KeyValueEnumerator)
- (NSEnumerator *)keyValueEnumerator
{
    NSEnumerator * keyEnumerator = [self keyEnumerator];
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:nil andFunc:^id(NSEnumerator * fakeEnumerator) {
        id key = [keyEnumerator nextObject];
        if (key == nil) return nil;
        id value = [self objectForKey:key];
        return [NSKeyValuePair pairWithKey:key value:value];
    }];
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSEnumerator (Linq)

- (NSEnumerator *)where:(BOOL (^)(id object))predicate
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        id result;
        while (result = [enumerator nextObject])
            if (predicate(result))
                return result;
        return nil;
    }];
}

- (NSEnumerator *)where_i:(BOOL (^)(id, NSInteger))predicate
{
    __block NSInteger index = 0;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        id result;
        while (result = [enumerator nextObject])
            if (predicate(result,index++))
                return result;
        return nil;
    }];
}

- (NSEnumerator *)select:(id (^)(id))func
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        id result = [enumerator nextObject];
        if (result)
            return func(result);
        return nil;
    }];
}

- (NSEnumerator *)select_i:(id (^)(id, NSInteger))func
{
    __block NSInteger index = 0;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        id result = [enumerator nextObject];
        if (result)
            return func(result,index++);
        return nil;
    }];
}

- (NSEnumerator *)distinct
{
    return [self distinct:^id(id object) {
        return object;
    }];
}

- (NSEnumerator *)distinct:(id (^)(id))func
{
    __block NSMutableSet * set = [NSMutableSet set];
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        id object;
        while (object = [enumerator nextObject])
        {
            id value = func(object);
            if (![set member:value])
            {
                [set addObject:value];
                return object;
            }
        };
        set = nil;
        return nil;
    }];
}

- (NSEnumerator *)skip:(NSInteger)count
{
    for (int i = 0; i < count; i++)
        if (![self nextObject])
            break;
    return self;
}

- (NSEnumerator *)take:(NSInteger)count
{
    __block int index = 0;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        if (index >= count)
            return nil;
        index++;
        return [enumerator nextObject];
    }];
}

#pragma mark - Aggregators

- (BOOL)all
{
    return [self all:^BOOL(id object) {
        return object != nil;
    }];
}

- (BOOL)all:(BOOL (^)(id))predicate
{
    for (id object in self)
        if (!predicate(object))
            return NO;
    return YES;
}

- (BOOL)any
{
    return [self any:^BOOL(id object) {
        return object != nil;
    }];
}

- (BOOL)any:(BOOL (^)(id))predicate
{
    for (id object in self)
        if (predicate(object))
            return YES;
    return NO;
}

- (NSInteger)count
{
    NSInteger count = 0;
    for (id object in self)
        count++;
    return count;
}

- (NSInteger)count:(BOOL (^)(id))predicate
{
    return [[self where:predicate] count];
}

#pragma mark - Single Object Returners

- (id)elementAt:(NSInteger)index
{
    for (int i = 0; i < index; i++)
        if (![self nextObject])
            return nil;
    return [self nextObject];
}

#pragma mark - Enumerator Operators

- (NSEnumerator *)concat:(NSEnumerator *)enumerator
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * selfEnumerator) {
        id object = [selfEnumerator nextObject];
        if (object) return object;
        return [enumerator nextObject];
    }];
}

@end
