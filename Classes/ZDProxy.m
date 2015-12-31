//
//  ZDProxy.m
//  ZDProxy
//
//  Created by 符现超 on 15/12/10.
//  Copyright © 2015年 Fate.D.Bourne. All rights reserved.
//

#import "ZDProxy.h"

@interface ZDProxy ()

@property (nonatomic, strong) NSPointerArray *weakPointerTargets;

@end


@implementation ZDProxy

#pragma mark -



#pragma mark - Setter

- (void)setDelegateTargets:(NSArray *)delegateTargets
{
    self.weakPointerTargets = [NSPointerArray weakObjectsPointerArray];
    for (id delegate in delegateTargets) {
        [self.weakPointerTargets addPointer:(__bridge void *)delegate];
    }
}

#pragma mark - Getter

#pragma mark - Proxy

//给方法签名(签名成功后才能进行转发)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:sel];
    if (!methodSignature) {
        for (id target in self.weakPointerTargets) {
            NSMethodSignature *sig = [target methodSignatureForSelector:sel];
            if (sig) {
                methodSignature = sig;
                break;
            }
        }
    }
    
    return methodSignature;
}

//转发消息
- (void)forwardInvocation:(NSInvocation *)invocation
{
    for (id target in self.weakPointerTargets) {
        if ([target respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:target];
        }
    }
}

#pragma mark - Response

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    for (id target in self.weakPointerTargets) {
        if ([target respondsToSelector:aSelector]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    if ([super conformsToProtocol:aProtocol]) {
        return YES;
    }
    
    for (id target in self.weakPointerTargets) {
        if ([target conformsToProtocol:aProtocol]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Private Method

- (id)p_firstResponderToSelector:(SEL)aSelector
{
    for (id delegate in self.weakPointerTargets) {
        if ([delegate respondsToSelector:aSelector]) {
            return delegate;
        }
    }
    return nil;
}

- (id)p_firstConformedToProtocol:(Protocol *)protocol
{
    for (id delegate in self.weakPointerTargets) {
        if ([delegate conformsToProtocol:protocol]) {
            return delegate;
        }
    }
    return nil;
}

@end

//#pragma mark -








