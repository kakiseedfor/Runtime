//
//  SMsgObject.m
//  Debug
//
//  Created by kakiYen on 2019/12/2.
//

#import "SMsgObject.h"

static void ResolveMethod(id object, SEL sel){
    NSLog(@"%s : %s",object_getClassName(object),sel_getName(sel));
}

@implementation SMsgObject

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    BOOL should = NO;
    if (strcmp(sel_getName(sel), "instanceResolveMethod") == 0) {
        should = class_addMethod(self, sel, (IMP)ResolveMethod, "v@:");
    }else{
        should = [super resolveInstanceMethod:sel];
    }
    return should;
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    BOOL should = NO;
    if (strcmp(sel_getName(sel), "classResolveMethod") == 0) {
        should = class_addMethod(object_getClass(self.class), sel, (IMP)ResolveMethod, "v@:");
    }else{
        should = [super resolveClassMethod:sel];
    }
    return should;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    if (strcmp(sel_getName(invocation.selector), "instanceInvocationMethod") == 0) {
        invocation.selector = @selector(invocationMethod);
        [invocation invokeWithTarget:self];
    }else{
        [super forwardInvocation:invocation];
    }
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

+ (void)forwardInvocation:(NSInvocation *)invocation{
    if (strcmp(sel_getName(invocation.selector), "classInvocationMethod") == 0){
        invocation.selector = @selector(classMethod);
        [invocation invokeWithTarget:self];
    }else{
        [super forwardInvocation:invocation];
    }
}

- (void)invocationMethod{
    NSLog(@"%@ : %s",self.className,__FUNCTION__);
}

+ (void)classMethod{
    NSLog(@"%@ : %s",self.className,__FUNCTION__);
}

@end