//
//  Helloworld.m
//  Debug
//
//  Created by kakiYen on 2019/8/14.
//

#import <objc/message.h>
#import "HelloWorld.h"

#pragma mark - HelloWorld

@implementation HelloWorld

+ (void)load{
    
}

- (void)dealloc{}

//+ (void)helloWorld{
//    unsigned int count = 0;
//    Method *method = class_copyMethodList(self.class, &count);
//    for (unsigned int i = 0; i < count; i++) {
//        NSLog(@"%s",(char *)method_getName(method[i]));
//    }
//}

//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    IMP imp = class_getMethodImplementation(object_getClass(HelloWorld.class), @selector(helloWorld));
//    class_addMethod(self, sel, imp, "v@:");
//    return YES;
//}

@end

#pragma mark - GoodByeWorld

@implementation GoodByeWorld

- (void)dealloc{}

/*
 由+、-决定self或super是实例对象还是类对象
 */
- (void)goodByeWorld{
    Class superClass = class_getSuperclass(self.class);
    /*
     判断是否实现对象方法
     */
//    if ([self.class instancesRespondToSelector:@selector(helloWorld)]) {
        id (*msgSend)(id, SEL) = (typeof(msgSend))objc_msgSend;
        msgSend(self.class, @selector(helloWorld));
//        msgSend(self, @selector(helloWorld));
    
//        struct objc_super objcSuper = {self.class, object_getClass(superClass)};
        struct objc_super objcSuper = {self.class, object_getClass(superClass.class)};
        id (*msgSendSuper)(struct objc_super *, SEL) = (typeof(msgSendSuper))objc_msgSendSuper;
        msgSendSuper(&objcSuper, @selector(helloWorld));
//    }
}

@end
