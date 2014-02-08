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

- (NSEnumerator *)where:(BOOL (^)(id object))predicate;
- (NSEnumerator *)where_i:(BOOL (^)(id object,NSInteger index))predicate;
- (NSEnumerator *)select:(id (^)(id object))func;
- (NSEnumerator *)select_i:(id (^)(id object,NSInteger index))func;
- (NSEnumerator *)select_parallel:(id (^)(id object))func;
- (NSEnumerator *)select_parallel:(id (^)(id object))func priority:(long)priority;
- (NSEnumerator *)distinct;
- (NSEnumerator *)distinct:(id<NSCopying> (^)(id object))keySelector;
- (NSEnumerator *)ofType:(Class) type;

- (NSEnumerator *)skip:(NSInteger)count;
- (NSEnumerator *)skipWhile:(BOOL (^)(id object))predicate;
- (NSEnumerator *)take:(NSInteger)count;
- (NSEnumerator *)takeWhile:(BOOL (^)(id object))predicate;

- (NSEnumerator *)groupBy:(id<NSCopying> (^)(id object))keySelector;
- (NSEnumerator *)splitBy:(id<NSCopying> (^)(id object))keySelector;
- (NSEnumerator *)selectMany:(NSEnumerator * (^)(id object))func;

- (NSEnumerator *)orderBy:(id (^)(id object))func
               comparator:(NSComparisonResult (^)(id obj1, id obj2))objectComparator;
- (NSEnumerator *)orderByDescending:(id (^)(id object))func
                         comparator:(NSComparisonResult (^)(id obj1, id obj2))objectComparator;
- (NSEnumerator *)orderBy:(id (^)(id object))func;
- (NSEnumerator *)orderByDescending:(id (^)(id object))func;

#pragma mark - Aggregators

- (id)aggregate:(id (^)(id accumulator,id object))func initValue:(id)value;
- (BOOL)all;
- (BOOL)all:(BOOL (^)(id object))predicate;
- (BOOL)any;
- (BOOL)any:(BOOL (^)(id object))predicate;
- (BOOL)none;
- (BOOL)none:(BOOL (^)(id object))predicate;
- (BOOL)contains:(id)object;
- (BOOL)containsObject:(id)object;
- (NSInteger)count;
- (NSInteger)count:(BOOL (^)(id))predicate;

- (id)elect:(id (^)(id obj1,id obj2))func;
- (id)max;
- (id)max:(id (^)(id object))func;
- (id)min;
- (id)min:(id (^)(id object))func;
- (double)sum;
- (double)average;

- (BOOL)sequenceEqual:(NSEnumerator *)other;
- (BOOL)sequenceEqual:(NSEnumerator *) other
       withComparator:(BOOL (^)(id obj1, id obj2))equalityComparator;


#pragma mark - Single Object Returners

- (id)elementAt:(NSInteger)index;
- (id)firstOrDefault;
- (id)firstOrDefault:(BOOL (^)(id object))predicate;
- (id)lastOrDefault;
- (id)lastOrDefault:(BOOL (^)(id object))predicate;

#pragma mark - Set Methods

- (NSEnumerator *)concat:(NSEnumerator *)secondEnumerator;
- (NSEnumerator *)concatOne:(id)one;
- (NSEnumerator *)union:(NSEnumerator *)secondEnumerator;
- (NSEnumerator *)intersect:(NSEnumerator *)secondEnumerator;
- (NSEnumerator *)except:(NSEnumerator *)secondEnumerator;

- (NSEnumerator *)zip:(NSEnumerator *)secondEnumerator
                 with:(id (^)(id obj1,id obj2))func;

- (NSEnumerator *)join:(NSEnumerator *)secondEnumerator
         firstSelector:(id<NSCopying> (^)(id object))firstSelector
        secondSelector:(id<NSCopying> (^)(id object))secondSelector;

- (NSEnumerator *)join:(NSEnumerator *)secondEnumerator
         firstSelector:(id<NSCopying> (^)(id object))firstSelector
        secondSelector:(id<NSCopying> (^)(id object))secondSelector
        resultSelector:(id (^)(id,id))resultSelector;

- (NSEnumerator *)groupJoin:(NSEnumerator *)secondEnumerator
              firstSelector:(id<NSCopying> (^)(id object))firstSelector
             secondSelector:(id<NSCopying> (^)(id object))secondSelector;

#pragma mark - Export methods

- (NSArray *)toArray;
- (NSSet *)toSet;
- (NSMutableDictionary *)toDictionary;
- (NSMutableDictionary *)toDictionary:(id<NSCopying> (^)(id object))keySelector;
- (NSMutableDictionary *)toLookup:(id<NSCopying> (^)(id object))keySelector;

#pragma - Generation Methods

+ (NSEnumerator *)range:(NSInteger)start count:(NSInteger)count;
+ (NSEnumerator *)repeat:(id)item count:(NSInteger)count;
+ (NSEnumerator *)empty;

#pragma mark - IO Methods

+ (NSEnumerator *)readBytes:(NSString *)path;
+ (NSEnumerator *)readLines:(NSString *)path;

@end
