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
- (NSEnumerator *)where:(BOOL (^)(id object))predicate;
- (NSEnumerator *)where_i:(BOOL (^)(id object,int index))predicate;
- (NSEnumerator *)select:(id (^)(id object))predicate;
- (NSEnumerator *)select_i:(id (^)(id object,int index))predicate;
- (NSEnumerator *)select_parallel:(id (^)(id object))func;
- (NSEnumerator *)select_parallel:(id (^)(id object))func
                         priority:(long)priority;
- (NSEnumerator *)distinct;
- (NSEnumerator *)distinct:(id<NSCopying> (^)(id object))func;
- (NSEnumerator *)ofType:(Class) type;

- (NSEnumerator *)skip:(NSInteger)count;
- (NSEnumerator *)skipWhile:(BOOL (^)(id object))predicate;
- (NSEnumerator *)take:(NSInteger)count;
- (NSEnumerator *)takeWhile:(BOOL (^)(id object))predicate;

- (NSEnumerator *)groupBy:(id<NSCopying> (^)(id object))keySelector;
- (NSEnumerator *)splitBy:(id<NSCopying> (^)(id object))keySelector;
- (NSEnumerator *)selectMany:(NSEnumerator * (^)(id object))func;

- (NSEnumerator *)orderBy:(id (^)(id object))func
               comparator:(NSComparisonResult(^)(id obj1, id obj2))objectComparator;
- (NSEnumerator *)orderByDescending:(id (^)(id object))func
                         comparator:(NSComparisonResult(^)(id obj1, id obj2))objectComparator;
- (NSEnumerator *)orderBy:(id (^)(id object))func;
- (NSEnumerator *)orderByDescending:(id (^)(id object))func;
```

###Aggregators
```
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
- (NSInteger)count:(BOOL (^)(id object))predicate;
- (id)elect:(id (^)(id obj1,id obj2))func;
- (id)max;
- (id)max:(id (^)(id object))func;
- (id)min;
- (id)min:(id (^)(id object))func;
- (double)sum;
- (double)average;
- (BOOL)sequenceEqual:(NSEnumerator *)other;
- (BOOL)sequenceEqual:(NSEnumerator *) other
       withComparator:(BOOL(^)(id obj1, id obj2))equalityComparator;
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
```

###Export methods
```
- (NSArray *)toArray;
- (NSSet *)toSet;
- (NSDictionary *)toDictionary;
- (NSDictionary *)toDictionary:(id<NSCopying> (^)(id object))keySelector;
- (NSDictionary *)toLookup:(id<NSCopying> (^)(id object))keySelector;
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