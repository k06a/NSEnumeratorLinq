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

@implementation NSEnumerator (Linq)

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

- (NSEnumerator *)concat:(NSEnumerator *)enumerator
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * selfEnumerator) {
        id object = [selfEnumerator nextObject];
        if (object) return object;
        return [enumerator nextObject];
    }];
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

- (NSEnumerator *)distinct:(id (^)(id))func
{
    __block NSMutableSet * set = [NSMutableSet set];
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        id object = nil;
        do
        {
            object = [enumerator nextObject];
            id value = func(object);
            if (object && ![set member:value])
            {
                [set addObject:value];
                return object;
            }
        } while (object);
        set = nil;
        return nil;
    }];
}

- (id)elementAt:(NSInteger)index
{
    for (int i = 0; i < index; i++)
        [self nextObject];
    return [self nextObject];
}

- (NSEnumerator *)distinct
{
    return [self distinct:^id(id object) {
        return object;
    }];
}

- (NSEnumerator *)select:(id (^)(id))func
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        id result = [enumerator nextObject];
        if (!result) return nil;
        return func(result);
    }];
}

- (NSEnumerator *)select_i:(id (^)(id, NSInteger))func
{
    __block NSInteger index = -1;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        index++;
        id result = [enumerator nextObject];
        if (!result) return nil;
        return func(result,index);
    }];
}

- (NSEnumerator *)skip:(NSInteger)count
{
    for (int i = 0; i < count; i++)
        [self nextObject];
    return self;
}

- (NSEnumerator *)where:(BOOL (^)(id object))predicate
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        id result = nil;
        do
            result = [enumerator nextObject];
        while (result && !predicate(result));
        return result;
    }];
}

- (NSEnumerator *)where_i:(BOOL (^)(id, NSInteger))predicate
{
    __block NSInteger index = -1;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        id result = nil;
        do
        {
            result = [enumerator nextObject];
            index++;
        } while (result && !predicate(result,index));
        return result;
    }];
}

@end
