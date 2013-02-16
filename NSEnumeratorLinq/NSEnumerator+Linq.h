//
//  NSEnumeratorLinq.h
//  NSEnumeratorLinq
//
//  Created by Антон Буков on 13.01.13.
//  Copyright (c) 2013 Happy Nation Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSKeyValuePair.h"

@interface NSEnumerator (Linq)

- (NSEnumerator *)where:(BOOL (^)(id))predicate;
- (NSEnumerator *)where_i:(BOOL (^)(id,int))predicate;
- (NSEnumerator *)select:(id (^)(id))predicate;
- (NSEnumerator *)select_i:(id (^)(id,int))predicate;
- (NSEnumerator *)distinct;
- (NSEnumerator *)distinct:(id (^)(id))func;

- (NSEnumerator *)skip:(NSInteger)count;
- (NSEnumerator *)take:(NSInteger)count;

#pragma mark - Aggregators

- (BOOL)all;
- (BOOL)all:(BOOL (^)(id))predicate;
- (BOOL)any;
- (BOOL)any:(BOOL (^)(id))predicate;
- (NSInteger)count;
- (NSInteger)count:(BOOL (^)(id))predicate;

#pragma mark - Single Object Returners

- (id)elementAt:(NSInteger)index;

#pragma mark - Set Methods

- (NSEnumerator *)concat:(NSEnumerator *)enumerator;

#pragma mark - Export methods

- (NSArray *)toArray;
- (NSSet *)toSet;
- (NSDictionary *)toDictionary;

@end
