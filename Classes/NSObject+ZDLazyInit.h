//
//  NSObject+ZDLazyInit.h
//  ZDProxy
//
//  Created by 符现超 on 16/1/7.
//  Copyright © 2016年 Fate.D.Bourne. All rights reserved.
//  http://andyarvanitis.com/lazy-initialization-for-objective-c/

#import <Foundation/Foundation.h>

@interface NSObject (ZDLazyInit)

+ (instancetype)lazy;

@end
