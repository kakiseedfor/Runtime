//
//  MsgObject.m
//  Debug
//
//  Created by kakiYen on 2019/11/29.
//

#import "MsgObject.h"

/*
 class_getInstanceVariable 配合 object_getIvar获取成员变量内存空间；
 self.varliable 系统默认实现是直接通过 _varliable 返回的；
 _varliable 直接保存着成员变量内存空间。
 */
@interface MsgObject ()
@property (strong, nonatomic) NSString *varliable;

@end

@implementation MsgObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.varliable = @"MsgObject";
    }
    return self;
}

/*
 实现 +load 方法，不影响编译器编译之后就已加载进类对象方法列表中。
 */
+ (void)load{

}

- (void)helloWorld{

}

+ (void)helloWorld{
    
}

@end

@implementation MsgObject (Catagory)

/*
 实现 +load 方法，将影响该类对象将延迟加载类别方法，否则在编译器编译之后就已加载进类对象方法列表中。
 */
+ (void)load{

}

- (void)helloWorld{
    
}

+ (void)helloWorld{
    
}

@end
