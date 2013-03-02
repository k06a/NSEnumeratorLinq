//
//  NSEnumerator+Linq.m
//  NSEnumeratorLinq
//
//  Created by Anton Bukov on 13.01.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "NSEnumerator+Linq.h"

////////////////////////////////////////////////////////////////////////////////////////////////
// private class

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

- (id)aggregate:(id (^)(id,id))func
{
    id result = nil;
    for (id object in self)
        result = result ? func(result, object) : object;
    return result;
}

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

- (BOOL)contains:(id)object
{
    return [self any:PREDICATE(id a, [a isEqual:object])];
}

- (BOOL)containsObject:(id)object
{
    return [self any:PREDICATE(id a, a == object)];
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

- (id)max
{
    return [self aggregate:^id(id a, id b) {
        return ([a compare:b] <= 0) ? a : b;
    }];
}

- (id)max:(id (^)(id))func
{
    return [self aggregate:^id(id a, id b) {
        return ([func(a) compare:func(b)] <= 0) ? a : b;
    }];
}

- (id)min
{
    return [self aggregate:^id(id a, id b) {
        return ([a compare:b] >= 0) ? a : b;
    }];
}

- (id)min:(id (^)(id))func
{
    return [self aggregate:^id(id a, id b) {
        return ([func(a) compare:func(b)] >= 0) ? a : b;
    }];
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
{
    return [self join:secondEnumerator firstSelector:firstSelector secondSelector:secondSelector resultSelector:^id(id a, id b) {
        return [NSKeyValuePair pairWithKey:a value:b];
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

- (NSEnumerator *)groupJoin:(NSEnumerator *)secondEnumerator
              firstSelector:(id<NSCopying> (^)(id))firstSelector
             secondSelector:(id<NSCopying> (^)(id))secondSelector;
{
    NSDictionary * lookup = [secondEnumerator toLookup:secondSelector];
    return [self select:FUNC(NSEnumerator *, id a, [NSKeyValuePair pairWithKey:a value:lookup[firstSelector(a)]])];
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

- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSKeyValuePair * pair in self)
        [dict setObject:pair.value forKey:pair.key];
    return dict;
}

- (NSMutableDictionary *)toDictionary:(id<NSCopying> (^)(id))keySelector
{
    return [[self select:TRANSFORM(id a, [NSKeyValuePair pairWithKey:keySelector(a) value:a])] toDictionary];
}

- (NSMutableDictionary *)toLookup:(id<NSCopying> (^)(id))keySelector
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

#pragma mark - IO Methods

+ (NSEnumerator *)readLines:(NSString *)path
{
    return [NSEnumerator readLines:path encoding:NSUTF8StringEncoding];
}

+ (NSEnumerator *)readLines:(NSString *)path
                   encoding:(NSStringEncoding)encoding
{
    __block NSInputStream * stream = [NSInputStream inputStreamWithFileAtPath:path];
    [stream open];
    if (![stream hasBytesAvailable])
        return nil;
    __block NSMutableData * data = [[NSMutableData alloc] init];
    
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:nil nextObject:^id(NSEnumerator * en) {
        int pos;
        while (YES)
        {
            if (data.length > 0)
            {
                pos = strcspn(data.bytes, "\r\n"); //[NSCharacterSet newlineCharacterSet]
                if (pos < data.length)
                    break;
            }
            
            uint8_t buffer[1024];
            NSInteger length = [stream read:buffer maxLength:1024];
            if (length > 0)
                [data appendBytes:buffer length:length];
            else
            {
                if (data.length == 0)
                {
                    [stream close];
                    stream = nil;
                    data = nil;
                    return nil;
                }
                
                pos = data.length;
                [data appendBytes:"\n" length:1];
                break;
            }
        }
        
        char chr1 = ((char *)data.bytes)[pos];
        char chr2 = (pos + 1 < data.length) ? ((char *)data.bytes)[pos] : 0;
        BOOL needOneMoreByte = (chr1 == '\r' && chr2 == '\n');
        
        [data replaceBytesInRange:NSMakeRange(pos, 1 + (needOneMoreByte?1:0)) withBytes:""];
        NSString * str = [NSString stringWithCString:data.bytes encoding:encoding];
        [data replaceBytesInRange:NSMakeRange(0, pos + 1 + (needOneMoreByte?1:0)) withBytes:NULL length:0];
        return str;
    }];
}

@end
