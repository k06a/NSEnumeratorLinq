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
- (NSEnumerator *)where_i:(BOOL (^)(id, NSInteger))predicate;
- (NSEnumerator *)select:(id (^)(id))predicate;
- (NSEnumerator *)select_i:(id (^)(id, NSInteger))predicate;
- (NSEnumerator *)distinct;
- (NSEnumerator *)distinct:(id (^)(id))func;

- (NSEnumerator *)skip:(NSInteger)count;
- (NSEnumerator *)take:(NSInteger)count;
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
```

###Set Methods
```
- (NSEnumerator *)concat:(NSEnumerator *)enumerator;
```

###Export methods
```
- (NSArray *)toArray;
- (NSSet *)toSet;
- (NSDictionary *)toDictionary;
```
---
Written with [Mou](http://mouapp.com) - The missing Markdown editor for web developers