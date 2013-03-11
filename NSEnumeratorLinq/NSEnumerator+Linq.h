//
//  NSEnumerator+Linq.h
//  NSEnumeratorLinq
//
//  Created by Anton Bukov on 13.01.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSKeyValuePair.h"

#define FUNC(RET, A, BODY) ^RET(A){return (BODY);}
#define ACTION(A, BODY) FUNC(void, A, BODY)
#define TRANSFORM(A, BODY) FUNC(id, A, BODY)
#define PREDICATE(A, BODY) FUNC(BOOL, A, BODY)

#define FUNC_2(RET, A, B, BODY) ^RET(A, B){return (BODY);}
#define ACTION_2(A, B, BODY) FUNC_2(void, A, B, BODY)
#define TRANSFORM_2(A, B, BODY) FUNC_2(id, A, B, BODY)
#define PREDICATE_2(A, B, BODY) FUNC_2(BOOL, A, B, BODY)

// NSDictionary+KeyValueEnumerator

@interface NSDictionary (KeyValueEnumerator)
- (NSEnumerator *)keyValueEnumerator;
@end

// NSString+Linq

@interface NSString (Linq)
+ (id)stringByJoin:(NSEnumerator *)unichars
     withSeparator:(NSString *)separator;
- (NSEnumerator *)enumerateCharacters;
- (NSEnumerator *)enumerateComponentsSeparatedByString:(NSString *)separator;
- (NSEnumerator *)enumerateComponentsSeparatedByString:(NSString *)separator
                                               options:(NSStringCompareOptions)options;
@end

// NSEnumerator+Linq

@interface NSEnumerator (Linq)

- (NSEnumerator *)where:(BOOL (^)(id))predicate;
- (NSEnumerator *)where_i:(BOOL (^)(id,int))predicate;
- (NSEnumerator *)select:(id (^)(id))predicate;
- (NSEnumerator *)select_i:(id (^)(id,int))predicate;
- (NSEnumerator *)distinct;
- (NSEnumerator *)distinct:(id<NSCopying> (^)(id))keySelector;

- (NSEnumerator *)skip:(NSInteger)count;
- (NSEnumerator *)skipWhile:(BOOL (^)(id))predicate;
- (NSEnumerator *)take:(NSInteger)count;
- (NSEnumerator *)takeWhile:(BOOL (^)(id))predicate;

- (NSEnumerator *)groupBy:(id<NSCopying> (^)(id))keySelector;
- (NSEnumerator *)splitBy:(id<NSCopying> (^)(id))keySelector;
- (NSEnumerator *)selectMany:(NSEnumerator * (^)(id))func;

#pragma mark - Aggregators

- (id)aggregate:(id (^)(id accumulator,id item))func;
- (BOOL)all;
- (BOOL)all:(BOOL (^)(id))predicate;
- (BOOL)any;
- (BOOL)any:(BOOL (^)(id))predicate;
- (BOOL)contains:(id)object;
- (BOOL)containsObject:(id)object;
- (NSInteger)count;
- (NSInteger)count:(BOOL (^)(id))predicate;
- (id)max;
- (id)max:(id (^)(id))func;
- (id)min;
- (id)min:(id (^)(id))func;

#pragma mark - Single Object Returners

- (id)elementAt:(NSInteger)index;
- (id)firstOrDefault;
- (id)firstOrDefault:(BOOL (^)(id))predicate;
- (id)lastOrDefault;
- (id)lastOrDefault:(BOOL (^)(id))predicate;

#pragma mark - Set Methods

- (NSEnumerator *)concat:(NSEnumerator *)secondEnumerator;
- (NSEnumerator *)union:(NSEnumerator *)secondEnumerator;
- (NSEnumerator *)intersect:(NSEnumerator *)secondEnumerator;
- (NSEnumerator *)except:(NSEnumerator *)secondEnumerator;

- (NSEnumerator *)zip:(NSEnumerator *)secondEnumerator
                 with:(id (^)(id,id))func;

- (NSEnumerator *)join:(NSEnumerator *)secondEnumerator
         firstSelector:(id<NSCopying> (^)(id))firstSelector
        secondSelector:(id<NSCopying> (^)(id))secondSelector;

- (NSEnumerator *)join:(NSEnumerator *)secondEnumerator
         firstSelector:(id<NSCopying> (^)(id))firstSelector
        secondSelector:(id<NSCopying> (^)(id))secondSelector
        resultSelector:(id (^)(id,id))resultSelector;

- (NSEnumerator *)groupJoin:(NSEnumerator *)secondEnumerator
              firstSelector:(id<NSCopying> (^)(id))firstSelector
             secondSelector:(id<NSCopying> (^)(id))secondSelector;

#pragma mark - Export methods

- (NSArray *)toArray;
- (NSSet *)toSet;
- (NSMutableDictionary *)toDictionary;
- (NSMutableDictionary *)toDictionary:(id<NSCopying> (^)(id))keySelector;
- (NSMutableDictionary *)toLookup:(id<NSCopying> (^)(id))keySelector;

#pragma - Generation Methods

+ (NSEnumerator *)range:(int)start count:(int)count;
+ (NSEnumerator *)repeat:(id)item count:(int)count;
+ (NSEnumerator *)empty;

#pragma mark - IO Methods

+ (NSEnumerator *)readBytes:(NSString *)path;
+ (NSEnumerator *)readLines:(NSString *)path;

@end
