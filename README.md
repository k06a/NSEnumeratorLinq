NSEnumeratorLinq
================

Just imagine the power of LINQ on iOS and OS X platforms.

Example with filtering, transforming and another filtering array:
``` objective-c
NSArray * arr = @[@1,@2,@3,@4,@5,@6,@7,@8];
NSArray * subarr = [[[[[arr objectEnumerator]                                // 1,2,3,4,5,6,7,8
                    where:^(id a){return [a intValue]%2 == 1}]               // 1,3,5,7
                    select:^(id a){return @([a intValue]*2)}]                // 2,6,10,14
                    where:^(id a){return [a intValue]>2 && [a intValue]<12}] // 6,10
                    allObjects];
```

Main objective is to implement all of these methods:
http://msdn.microsoft.com/en-us/library/system.linq.enumerable_methods.aspx