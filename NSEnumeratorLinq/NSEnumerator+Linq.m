//
//  NSEnumerator+Linq.m
//  NSEnumerator+Linq
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
    id (^_nextObject)(NSEnumerator *);
}
- (id)initWithEnumarator:(NSEnumerator *)enumerator nextObject:(id (^)(NSEnumerator *))nextObject {
    if (self = [super init]) {
        _enumerator = enumerator;
        _nextObject = nextObject;
    }
    return self;
}
- (id)nextObject {
    return _nextObject(_enumerator);
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
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:nil nextObject:^id(NSEnumerator * fakeEnumerator) {
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
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
        id result;
        while (result = [enumerator nextObject])
            if (predicate(result))
                return result;
        return nil;
    }];
}

- (NSEnumerator *)where_i:(BOOL (^)(id,int))predicate
{
    __block NSInteger index = 0;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
        id result;
        while (result = [enumerator nextObject])
            if (predicate(result,index++))
                return result;
        return nil;
    }];
}

- (NSEnumerator *)select:(id (^)(id))func
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
        id result = [enumerator nextObject];
        if (result)
            return func(result);
        return nil;
    }];
}

- (NSEnumerator *)select_i:(id (^)(id,int))func
{
    __block NSInteger index = 0;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
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

- (NSEnumerator *)distinct:(id<NSCopying> (^)(id))func
{
    __block NSMutableSet * set = [NSMutableSet set];
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
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

- (NSEnumerator *)skipWhile:(BOOL (^)(id))predicate;
{
    id object;
    do
        object = [self nextObject];
    while (object && predicate(object));
    return self;
}

- (NSEnumerator *)take:(NSInteger)count
{
    __block int index = 0;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
        if (index >= count)
            return nil;
        index++;
        return [enumerator nextObject];
    }];
}

- (NSEnumerator *)takeWhile:(BOOL (^)(id))predicate;
{
    __block BOOL finished = NO;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
        if (finished)
            return nil;
        id object = [enumerator nextObject];
        if (!predicate(object))
            finished = YES;
        return finished ? nil : object;
    }];
}

- (NSEnumerator *)groupBy:(id<NSCopying> (^)(id))keySelector
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    id object;
    while (object = [self nextObject])
    {
        id key = keySelector(object);
        NSMutableArray * value = [dict objectForKey:key];
        if (!value)
        {
            value = [NSMutableArray array];
            [dict setObject:value forKey:key];
        }
        [value addObject:object];
    };

    return [dict keyValueEnumerator];
}

- (NSEnumerator *)selectMany:(NSEnumerator * (^)(id))func
{
    __block NSEnumerator * item = nil;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
        id object = [item nextObject];
        if (!object)
        {
            item = [enumerator nextObject];
            object = [item nextObject];
        }
        return object;
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

- (id)firstOrDefault
{
    return [self nextObject];
}

- (id)firstOrDefault:(BOOL (^)(id))predicate
{
    return [[self where:predicate] firstOrDefault];
}

- (id)lastOrDefault
{
    id object;
    id preObject = nil;
    while (object = [self nextObject])
        preObject = object;
    return preObject;
}

- (id)lastOrDefault:(BOOL (^)(id))predicate
{
    return [[self where:predicate] lastOrDefault];
}

#pragma mark - Set Methods

- (NSEnumerator *)concat:(NSEnumerator *)secondEnumerator
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
        id object = [enumerator nextObject];
        if (object) return object;
        return [secondEnumerator nextObject];
    }];
}

- (NSEnumerator *)union:(NSEnumerator *)secondEnumerator
{
    return [[self concat:secondEnumerator] distinct];
}

- (NSEnumerator *)intersect:(NSEnumerator *)secondEnumerator
{
    __block NSMutableSet * set = [NSMutableSet set];
    for (id object in secondEnumerator)
        [set addObject:object];
    
    return [self where:^BOOL(id object) {
        return [set member:object] != nil;
    }];
}

- (NSEnumerator *)except:(NSEnumerator *)secondEnumerator
{
    __block NSMutableSet * set = [NSMutableSet set];
    for (id object in secondEnumerator)
        [set addObject:object];
    
    return [self where:^BOOL(id object) {
        return [set member:object] == nil;
    }];
}

- (NSEnumerator *)zip:(NSEnumerator *)secondEnumerator with:(id (^)(id,id))func
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
        id object1 = [enumerator nextObject];
        id object2 = [secondEnumerator nextObject];
        if (object1 || object2)
            return func(object1,object2);
        return nil;
    }];
}

- (NSEnumerator *)join:(NSEnumerator *)secondEnumerator
         firstSelector:(id<NSCopying> (^)(id))firstSelector
        secondSelector:(id<NSCopying> (^)(id))secondSelector
        resultSelector:(id (^)(id,id))resultSelector
{
    NSDictionary * lookup = [secondEnumerator toLookup:secondSelector];
    return [self selectMany:FUNC(NSEnumerator *, id a, resultSelector(a, lookup[firstSelector(a)]))];
}

#pragma mark - Export methods

- (NSArray *)toArray
{
    return [self allObjects];
}

- (NSSet *)toSet
{
    return [NSSet setWithArray:[self allObjects]];
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSKeyValuePair * pair in self)
        [dict setObject:pair.value forKey:pair.key];
    return dict;
}

- (NSDictionary *)toDictionary:(id<NSCopying> (^)(id))keySelector
{
    return [[self select:TRANSFORM(id a, [NSKeyValuePair pairWithKey:keySelector(a) value:a])] toDictionary];
}

- (NSDictionary *)toLookup:(id<NSCopying> (^)(id))keySelector
{
    return [[self groupBy:keySelector] toDictionary];
}

#pragma - Generation Methods

+ (NSEnumerator *)range:(int)start count:(int)count
{
    __block int index = start;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:nil nextObject:^id(NSEnumerator * enumerator) {
        if (index < start + count)
            return @(index++);
        return nil;
    }];
}

+ (NSEnumerator *)repeat:(id)object count:(int)count
{
    __block int index = 0;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:nil nextObject:^id(NSEnumerator * enumerator) {
        if (index < count)
            return object;
        return nil;
    }];
}

+ (NSEnumerator *)empty
{
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:nil nextObject:^id(NSEnumerator * enumerator) {
        return nil;
    }];
}

@end
