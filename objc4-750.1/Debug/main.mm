//
//  main.m
//  Debug
//
//  Created by kakiYen on 2019/7/16.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import "BlockObject.h"
#import "MsgObject.h"
#import "Rvalue.hpp"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        MsgObject *object = [[MsgObject alloc] init];
        void (*TempMsg)(Class, SEL) = (typeof(TempMsg))objc_msgSend;
        TempMsg(object, @selector(instanceResolveMethod));
        TempMsg(MsgObject.class, @selector(classResolveMethod));
        
        TempMsg(object, @selector(instanceInvocationMethod));
        TempMsg(MsgObject.class, @selector(classInvocationMethod));
        
        NSLog(@"-------------------------------------------------");
        
        objc_super iSuperObj = {
            object,
            MsgObject.class
        };
        void (*SuperTempMsg)(objc_super *, SEL) = (typeof(SuperTempMsg))objc_msgSendSuper;
        SuperTempMsg(&iSuperObj, @selector(instanceResolveMethod));
        SuperTempMsg(&iSuperObj, @selector(instanceInvocationMethod));
        
        objc_super CSuperObj = {
            object.class,
            object_getClass(MsgObject.class)
        };
        SuperTempMsg(&CSuperObj, @selector(classResolveMethod));
        SuperTempMsg(&CSuperObj, @selector(classInvocationMethod));
        
        NSLog(@"-------------------------------------------------");
        
        BlockObject *blockObject = [[BlockObject alloc] init];
        [blockObject shareBlock];
        
        NSLog(@"-------------------------------------------------");
        
        char value[] = "Hello, World!";
        Rvalue rvalue;
        rvalue = value;
    }
    return 0;
}
