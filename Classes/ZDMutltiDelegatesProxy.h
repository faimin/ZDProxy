//
//  ZDMutltiDelegatesProxy.h
//  ZDProxy
//
//  Created by 符现超 on 15/12/11.
//  Copyright © 2015年 Fate.D.Bourne. All rights reserved.
//  https://github.com/lukabernardi/LBDelegateMatrioska
//  https://github.com/malcommac/DMMultiDelegatesProxy

#import <Foundation/Foundation.h>

@interface ZDMutltiDelegatesProxy : NSProxy

@property (nonatomic, strong) IBOutletCollection(id) NSArray *delegateTargets;
//@property (nonatomic, weak  ) id mainDelegate;

- (instancetype)initWithDelegates:(NSArray *)aDelegates;

- (void)addDelegate:(id)aDelegate;

- (void)removeDelegate:(id)aDelegate;

@end

