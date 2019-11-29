//
//  main.m
//  Debug
//
//  Created by kakiYen on 2019/7/16.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
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
        
        char value[] = "Hello, World!";
        Rvalue rvalue;
        rvalue = value;
    }
    return 0;
}
