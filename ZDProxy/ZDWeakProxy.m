//
//  ZDForwardProxy.m
//  ZDProxy
//
//  Created by 符现超 on 15/12/11.
//  Copyright © 2015年 Fate.D.Bourne. All rights reserved.
//

#import "ZDWeakProxy.h"
#import <objc/runtime.h>

@interface ZDWeakProxy ()

@property (nonatomic, strong) Class realDelegateClass;
@property (nonatomic, weak) id realDelegate;

@end

@implementation ZDWeakProxy

+ (id)forwardToProxy:(id)realDelegate associatedObject:(id)object
{
	NSAssert(realDelegate, @"Trying to forward to a nil object");
	NSAssert(object, @"Trying associate forwarder to a nil object");

	// creat proxy to do the forwarding
	ZDWeakProxy *forwarder = [ZDWeakProxy alloc];
	forwarder.realDelegate = realDelegate;
	forwarder.realDelegateClass = [realDelegate class];

	// We need to keep this proxy object around for the lifetime of the associated object.
	// To do this we associate the proxy with the object using the address of the created proxy
	// object as the unique key here. When object goes away so will the forwarder.
	objc_setAssociatedObject(object, (__bridge const void *)(forwarder), forwarder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	return forwarder;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
	if (self.realDelegate) {
		return [self.realDelegate methodSignatureForSelector:sel];
	}
	else {
		return [self.realDelegateClass instanceMethodSignatureForSelector:sel];
	}
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
	// If we still have the real delegate around then forward it on, otherwise drop it.
	if (self.realDelegate) {
		[invocation setTarget:self.realDelegate];
		[invocation invoke];
	}
}

@end
