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

- (NSEnumerator *)groupBy:(id<NSCopying> (^)(id))func;
- (NSEnumerator *)selectMany:(NSEnumerator * (^)(id))func;
```

###Aggregators
```
- (BOOL)all;
- (BOOL)all:(BOOL (^)(id))predicate;
- (BOOL)any;
- (BOOL)any:(BOOL (^)(id))predicate;
- (NSInteger)count;
- (NSInteger)count:(BOOL (^)(id))predicate;
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
- (NSEnumerator *)concat:(NSEnumerator *)enumerator;
- (NSEnumerator *)union:(NSEnumerator *)secondEnumerator;
- (NSEnumerator *)intersect:(NSEnumerator *)secondEnumerator;
- (NSEnumerator *)except:(NSEnumerator *)secondEnumerator;
- (NSEnumerator *)zip:(NSEnumerator *)secondEnumerator with:(id (^)(id,id))func;
```

###Export methods
```
- (NSArray *)toArray;
- (NSSet *)toSet;
- (NSDictionary *)toDictionary;
```


###Generation Methods
```
+ (NSEnumerator *)range:(int)start count:(int)count;
+ (NSEnumerator *)repeat:(id)item count:(int)count;
+ (NSEnumerator *)empty;
```
---
Written with [Mou](http://mouapp.com) - The missing Markdown editor for web developers