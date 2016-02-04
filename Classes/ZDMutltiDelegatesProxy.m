//
//  ZDMutltiDelegatesProxy.m
//  ZDProxy
//
//  Created by 符现超 on 15/12/11.
//  Copyright © 2015年 Zero.D.Bourne. All rights reserved.
//

#import "ZDMutltiDelegatesProxy.h"

@interface ZDMutltiDelegatesProxy ()

@property (nonatomic, strong) NSPointerArray *mutableWeakDelegates;

@end


@implementation ZDMutltiDelegatesProxy

- (instancetype)initWithDelegates:(NSArray *)aDelegates
{
    self.delegateTargets = aDelegates;
    return self;
}

- (void)addDelegate:(id)aDelegate
{
    NSParameterAssert(aDelegate);
    
    [self.mutableWeakDelegates addPointer:(void *)aDelegate];
}

- (void)removeDelegate:(id)aDelegate
{
    NSParameterAssert(aDelegate);
    NSUInteger index = 0;
    for (id delegate in self.mutableWeakDelegates) {
        if (delegate == aDelegate) {
            [self.mutableWeakDelegates removePointerAtIndex:index];
        }
        index++;
    }
}


#pragma mark - Message Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    id firstRespoder = [self firstResponderToSelector:selector];
    if (firstRespoder) {
        return [firstRespoder methodSignatureForSelector:selector];
    }
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [self firstResponderToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    // If the invoked method return void I can safely call all the delegates
    // otherwise I just invoke it on the first delegate that
    // respond to the given selector
    if (invocation.methodSignature.methodReturnLength == 0) {
        for (id delegate in self.mutableWeakDelegates) {
            if ([delegate respondsToSelector:invocation.selector]) {
                [invocation invokeWithTarget:delegate];
            }
        }
    } else {
        id firstResponder = [self firstResponderToSelector:invocation.selector];
        [invocation invokeWithTarget:firstResponder];
    }

}

#pragma mark - Private Method

- (id)firstResponderToSelector:(SEL)aSelector
{
    for (id delegate in self.mutableWeakDelegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return delegate;
        }
    }
    return nil;
}

#pragma mark - Property

- (NSPointerArray *)mutableWeakDelegates
{
    if (!_mutableWeakDelegates) {
        _mutableWeakDelegates = [NSPointerArray weakObjectsPointerArray];
    }
    return _mutableWeakDelegates;
}

- (void)setDelegateTargets:(NSArray *)delegateTargets
{
    [delegateTargets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.mutableWeakDelegates addPointer:(void *)obj];
    }];
}

- (NSArray *)delegateTargets
{
    return self.mutableWeakDelegates.allObjects;
}

@end
