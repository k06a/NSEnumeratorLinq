//
//  NSEnumeratorLinqTests.m
//  NSEnumeratorLinqTests
//
//  Created by Антон Буков on 13.01.13.
//  Copyright (c) 2013 Happy Nation Project. All rights reserved.
//

#import "NSEnumerator+Linq.h"
#import "NSEnumeratorLinqTests.h"

@implementation NSEnumerator (ToSet)
- (NSSet *)toSetForTest
{
    return [NSSet setWithArray:[self allObjects]];
}
@end

@implementation NSEnumeratorLinqTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCount
{
    NSArray * arr0 = @[];
    NSArray * arr1 = @[@1];
    NSArray * arr2 = @[@1,@2];
    NSArray * arr3 = @[@1,@2,@3];
    NSArray * arr4 = @[@1,@2,@3,@4];
    NSArray * arr5 = @[@1,@2,@3,@4,@5];
    
    STAssertEquals(0, [[arr0 objectEnumerator] count], @"Empty array");
    STAssertEquals(1, [[arr1 objectEnumerator] count], @"Array of size 1");
    STAssertEquals(2, [[arr2 objectEnumerator] count], @"Array of size 2");
    STAssertEquals(3, [[arr3 objectEnumerator] count], @"Array of size 3");
    STAssertEquals(4, [[arr4 objectEnumerator] count], @"Array of size 4");
    STAssertEquals(5, [[arr5 objectEnumerator] count], @"Array of size 5");
}

- (void)testDistinctWithArg
{
    NSSet * set0 = [NSSet setWithArray:@[]];
    NSSet * set1 = [NSSet setWithArray:@[@1]];
    NSSet * set2 = [NSSet setWithArray:@[@2]];
    NSSet * set3 = [NSSet setWithArray:@[@1,@2]];
    
    NSArray * arr0 = @[];
    NSArray * arr1 = @[@1];
    NSArray * arr2 = @[@1,@2];
    NSArray * arr3 = @[@1,@2,@3];
    NSArray * arr4 = @[@1,@3,@5,@7];
    NSArray * arr5 = @[@2,@4,@8,@10];
    
    id(^func)(id) = ^(id a){return @([a intValue]%2);};
    STAssertEqualObjects(set0, [[[arr0 objectEnumerator] distinct:func] toSetForTest], @"Empty array");
    STAssertEqualObjects(set1, [[[arr1 objectEnumerator] distinct:func] toSetForTest], @"Array of size 1");
    STAssertEqualObjects(set3, [[[arr2 objectEnumerator] distinct:func] toSetForTest], @"Array of size 2");
    STAssertEqualObjects(set3, [[[arr3 objectEnumerator] distinct:func] toSetForTest], @"Array of size 3");
    STAssertEqualObjects(set1, [[[arr4 objectEnumerator] distinct:func] toSetForTest], @"Array of size 4");
    STAssertEqualObjects(set2, [[[arr5 objectEnumerator] distinct:func] toSetForTest], @"Array of size 5");
}

- (void)testDistinct
{
    NSSet * set0 = [NSSet setWithArray:@[]];
    NSSet * set1 = [NSSet setWithArray:@[@1]];
    NSSet * set2 = [NSSet setWithArray:@[@1,@2]];
    
    NSArray * arr0 = @[];
    NSArray * arr1 = @[@1];
    NSArray * arr2 = @[@1,@2];
    NSArray * arr3 = @[@1,@1,@2];
    NSArray * arr4 = @[@1,@1,@2,@2];
    NSArray * arr5 = @[@1,@1,@2,@1,@2];
    
    STAssertEqualObjects(set0, [NSSet setWithArray:[[[arr0 objectEnumerator] distinct] allObjects]], @"Empty array");
    STAssertEqualObjects(set1, [NSSet setWithArray:[[[arr1 objectEnumerator] distinct] allObjects]], @"Array of size 1");
    STAssertEqualObjects(set2, [NSSet setWithArray:[[[arr2 objectEnumerator] distinct] allObjects]], @"Array of size 2");
    STAssertEqualObjects(set2, [NSSet setWithArray:[[[arr3 objectEnumerator] distinct] allObjects]], @"Array of size 3");
    STAssertEqualObjects(set2, [NSSet setWithArray:[[[arr4 objectEnumerator] distinct] allObjects]], @"Array of size 4");
    STAssertEqualObjects(set2, [NSSet setWithArray:[[[arr5 objectEnumerator] distinct] allObjects]], @"Array of size 5");
}

- (void)testSelect
{
    NSArray * arr0 = @[];
    NSArray * arr1 = @[@1];
    NSArray * arr2 = @[@1,@2];
    NSArray * arr3 = @[@1,@2,@3];
    NSArray * arr4 = @[@1,@2,@3,@4];
    NSArray * arr5 = @[@1,@2,@3,@4,@5];

    NSArray * ans0 = @[];
    NSArray * ans1 = @[@3];
    NSArray * ans2 = @[@3,@5];
    NSArray * ans3 = @[@3,@5,@7];
    NSArray * ans4 = @[@3,@5,@7,@9];
    NSArray * ans5 = @[@3,@5,@7,@9,@11];
    
    id(^transform)(id) = ^(id a){return @([a intValue]*2 + 1);};
    STAssertEqualObjects(ans0, [[[arr0 objectEnumerator] select:transform] allObjects], @"Empty array");
    STAssertEqualObjects(ans1, [[[arr1 objectEnumerator] select:transform] allObjects], @"Array of size 1");
    STAssertEqualObjects(ans2, [[[arr2 objectEnumerator] select:transform] allObjects], @"Array of size 2");
    STAssertEqualObjects(ans3, [[[arr3 objectEnumerator] select:transform] allObjects], @"Array of size 3");
    STAssertEqualObjects(ans4, [[[arr4 objectEnumerator] select:transform] allObjects], @"Array of size 4");
    STAssertEqualObjects(ans5, [[[arr5 objectEnumerator] select:transform] allObjects], @"Array of size 5");
}

- (void)testSelect_i
{
    NSArray * arr0 = @[];
    NSArray * arr1 = @[@1];
    NSArray * arr2 = @[@1,@2];
    NSArray * arr3 = @[@1,@2,@3];
    NSArray * arr4 = @[@1,@2,@3,@4];
    NSArray * arr5 = @[@1,@2,@3,@4,@5];
    
    NSArray * ans0 = @[];
    NSArray * ans1 = @[@0];
    NSArray * ans2 = @[@0,@2];
    NSArray * ans3 = @[@0,@2,@12];
    NSArray * ans4 = @[@0,@2,@12,@36];
    NSArray * ans5 = @[@0,@2,@12,@36,@80];
    
    id(^transform)(id,NSInteger) = ^(id a,NSInteger i){return @(i*i*[a intValue]);};
    STAssertEqualObjects(ans0, [[[arr0 objectEnumerator] select_i:transform] allObjects], @"Empty array");
    STAssertEqualObjects(ans1, [[[arr1 objectEnumerator] select_i:transform] allObjects], @"Array of size 1");
    STAssertEqualObjects(ans2, [[[arr2 objectEnumerator] select_i:transform] allObjects], @"Array of size 2");
    STAssertEqualObjects(ans3, [[[arr3 objectEnumerator] select_i:transform] allObjects], @"Array of size 3");
    STAssertEqualObjects(ans4, [[[arr4 objectEnumerator] select_i:transform] allObjects], @"Array of size 4");
    STAssertEqualObjects(ans5, [[[arr5 objectEnumerator] select_i:transform] allObjects], @"Array of size 5");
}

@end
