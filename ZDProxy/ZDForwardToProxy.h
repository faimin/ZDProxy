//
//  ZDForwardProxy.h
//  ZDProxy
//
//  Created by 符现超 on 15/12/11.
//  Copyright © 2015年 Fate.D.Bourne. All rights reserved.
//  https://github.com/intuit/WeakForwarder

#import <Foundation/Foundation.h>

@interface ZDForwardToProxy : NSProxy

+ (id)forwardToProxy:(id)realDelegate associatedObject:(id)object;

@end
