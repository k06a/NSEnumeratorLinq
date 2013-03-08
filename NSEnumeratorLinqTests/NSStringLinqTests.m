//
//  NSStringLinqTests.m
//  NSEnumeratorLinq
//
//  Created by Антон Буков on 06.03.13.
//  Copyright (c) 2013 Happy Nation Project. All rights reserved.
//

#import "NSEnumerator+Linq.h"
#import "NSStringLinqTests.h"

@implementation NSStringLinqTests

- (void)testEnumerateComponentsSeparatedByString
{
    NSString * str = @"Helloabcworldabcxyz";
    NSArray * ans = [str componentsSeparatedByString:@"abc"];
    NSEnumerator * res = [str enumerateComponentsSeparatedByString:@"abc"];
    STAssertEqualObjects(ans, [res allObjects], @"Components separated by string");
}

- (void)testEnumerateComponentsSeparatedByString3Empty
{
    NSString * str = @"abcabc";
    NSArray * ans = [str componentsSeparatedByString:@"abc"];
    NSEnumerator * res = [str enumerateComponentsSeparatedByString:@"abc"];
    STAssertEqualObjects(ans, [res allObjects], @"Components separated by string");
}

@end
