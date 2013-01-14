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

- (NSEnumerator *)concat:(NSEnumerator *)enumerator
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * selfEnumerator) {
        id result = [selfEnumerator nextObject];
        if (result) return result;
        return [enumerator nextObject];
    }];
}

- (NSInteger)count
{
    NSInteger count = 0;
    while ([self nextObject])
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
        id result = nil;
        do
        {
            result = [enumerator nextObject];
            id value = func(result);
            if (result && ![set member:value])
            {
                [set addObject:value];
                return result;
            }
        } while (result);
        set = nil;
        return nil;
    }];
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
    __block NSInteger skipCount = count;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self andFunc:^id(NSEnumerator * enumerator) {
        for (; skipCount > 0; skipCount--)
            [enumerator nextObject];
        return [enumerator nextObject];
    }];
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
