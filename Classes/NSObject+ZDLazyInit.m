//
//  NSObject+ZDLazyInit.m
//  ZDProxy
//
//  Created by 符现超 on 16/1/7.
//  Copyright © 2016年 Zero.D.Bourne. All rights reserved.
//

#import "NSObject+ZDLazyInit.h"

#if !__has_feature(objc_arc)
  #error ARC must be enabled for this source file (but clients can use MRC).
#endif

@interface ZDLazyProxy : NSProxy

@end

@implementation ZDLazyProxy
{
	id _object;
	Class _objectClass;
	NSInvocation *_initInvocation;
}

- (instancetype)initWithClass:(Class)class
{
	_objectClass = class;
	return self;
}

- (void)instantiateObject
{
	_object = [_objectClass alloc];

	if (_initInvocation == nil) { // allow SomeClass.lazy (no explicit init)
		_object = [_object init];
	}
	else {
		[_initInvocation invokeWithTarget:_object];
		[_initInvocation getReturnValue:&_object];
		_initInvocation = nil;
	}
}

- (id)forwardingTargetForSelector:(SEL)selector
{
	if (_object == nil) { // once set, fast forwarding is in effect
		if (![NSStringFromSelector(selector) hasPrefix:@"init"]) {
			[self instantiateObject];
		}
	}
	return _object;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature *signature =
		[_objectClass instanceMethodSignatureForSelector:selector];
	return signature;
}

// If we got here, it had to be from an init method
- (void)forwardInvocation:(NSInvocation *)invocation
{
	_initInvocation = invocation;
	[_initInvocation setTarget:nil]; // not needed, and we don't want to retain
	[_initInvocation retainArguments];
	// For the immediate init(With...) call, return the proxy itself
	[_initInvocation setReturnValue:(void *)&self];
}

//----------------------------------------------------------------------------
// Implemented by NSProxy, so we need to forward these manually
//----------------------------------------------------------------------------

- (Class)class
{
	if (_object == nil) {
		[self instantiateObject];
	}
	return [_object class];
}

- (Class)superclass
{
	if (_object == nil) {
		[self instantiateObject];
	}
	return [_object superclass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
	if (self->_object == nil) {
		[self instantiateObject];
	}
	return [self->_object conformsToProtocol:aProtocol];
}

- (NSString *)description
{
	if (self->_object == nil) {
		[self instantiateObject];
	}
	return [self->_object description];
}

- (NSUInteger)hash
{
	if (self->_object == nil) {
		[self instantiateObject];
	}
	return [self->_object hash];
}

- (BOOL)isEqual:(id)obj
{
	if (self->_object == nil) {
		[self instantiateObject];
	}
	return [self->_object isEqual:obj];
}

- (BOOL)isKindOfClass:(Class)aClass
{
	if (self->_object == nil) {
		[self instantiateObject];
	}
	return [self->_object isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass
{
	if (self->_object == nil) {
		[self instantiateObject];
	}
	return [self->_object isMemberOfClass:aClass];
}

- (BOOL)respondsToSelector:(SEL)selector
{
	if (self->_object == nil) {
		[self instantiateObject];
	}
	return [self->_object respondsToSelector:selector];
}

@end

#pragma mark - Categrory

@implementation NSObject (ZDLazyInit)

+ (instancetype)lazy
{
    return (id)[ZDLazyProxy.alloc initWithClass:[self class]];
}

@end
