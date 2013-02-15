//
//  NSKeyValuePair.h
//  NSEnumeratorLinq
//
//  Created by Антон Буков on 15.02.13.
//  Copyright (c) 2013 Happy Nation Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSKeyValuePair : NSObject

@property (nonatomic) id key;
@property (nonatomic) id value;

+ (id)pairWithKey:(id)key value:(id)value;
- (id)initWithKey:(id)key value:(id)value;

@end
