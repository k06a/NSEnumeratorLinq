#NSEnumeratorLinq

Just imagine the power of LINQ on iOS and OS X platforms.

##Stop talking, show me the code…

Example with filtering, transforming and another filtering array:

```
NSArray * arr = @[@1,@2,@3,@4,@5,@6,@7,@8];
NSArray * subarr = [[[[[arr objectEnumerator]                                // 1,2,3,4,5,6,7,8
                    where:^(id a){return [a intValue]%2 == 1}]               // 1,3,5,7
                    select:^(id a){return @([a intValue]*2)}]                // 2,6,10,14
                    where:^(id a){return [a intValue]>2 && [a intValue]<12}] // 6,10
                    allObjects];
```

##Main Objective

Main objective is to implement all of these methods:
http://msdn.microsoft.com/en-us/library/system.linq.enumerable_methods.aspx

##Implemented Features

###Main Methods
```
- (NSEnumerator *)where:(BOOL (^)(id))predicate;
- (NSEnumerator *)where_i:(BOOL (^)(id,int))predicate;
- (NSEnumerator *)select:(id (^)(id))predicate;
- (NSEnumerator *)select_i:(id (^)(id,int))predicate;
- (NSEnumerator *)distinct;
- (NSEnumerator *)distinct:(id<NSCopying> (^)(id))func;

- (NSEnumerator *)skip:(NSInteger)count;
- (NSEnumerator *)skipWhile:(BOOL (^)(id))predicate;
- (NSEnumerator *)take:(NSInteger)count;
- (NSEnumerator *)takeWhile:(BOOL (^)(id))predicate;

- (NSEnumerator *)groupBy:(id<NSCopying> (^)(id))keySelector;
- (NSEnumerator *)splitBy:(id<NSCopying> (^)(id))keySelector;
- (NSEnumerator *)selectMany:(NSEnumerator * (^)(id))func;

- (NSEnumerator *)orderBy:(id (^)(id))func
               comparator:(NSComparisonResult(^)(id obj1, id obj2))objectComparator;
- (NSEnumerator *)orderByDescending:(id (^)(id))func
                         comparator:(NSComparisonResult(^)(id obj1, id obj2))objectComparator;
- (NSEnumerator *)orderBy:(id (^)(id))func;
- (NSEnumerator *)orderByDescending:(id (^)(id))func;
```

###Aggregators
```
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
```

###Single Object Returners
```
- (id)elementAt:(NSInteger)index;
- (id)firstOrDefault;
- (id)firstOrDefault:(BOOL (^)(id))predicate;
- (id)lastOrDefault;
- (id)lastOrDefault:(BOOL (^)(id))predicate;
```

###Set Methods
```
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
```

###Export methods
```
- (NSArray *)toArray;
- (NSSet *)toSet;
- (NSDictionary *)toDictionary;
- (NSDictionary *)toDictionary:(id<NSCopying> (^)(id))keySelector;
- (NSDictionary *)toLookup:(id<NSCopying> (^)(id))keySelector;
```

###Generation Methods
```
+ (NSEnumerator *)range:(int)start count:(int)count;
+ (NSEnumerator *)repeat:(id)item count:(int)count;
+ (NSEnumerator *)empty;
```

###I/O Methods
```
+ (NSEnumerator *)readBytes:(NSString *)path;
+ (NSEnumerator *)readLines:(NSString *)path;
```

###NSString Category Methods
```
+ (id)stringByJoin:(NSEnumerator *)unichars
     withSeparator:(NSString *)separator;
- (NSEnumerator *)enumerateCharacters;
- (NSEnumerator *)enumerateComponentsSeparatedByString:(NSString *)separator
                                               options:(NSStringCompareOptions)options;
- (NSEnumerator *)enumerateComponentsSeparatedByString:(NSString *)separator;
```

---
Written with [Mou](http://mouapp.com) - The missing Markdown editor for web developers