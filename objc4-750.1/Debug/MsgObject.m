//
//  MsgObject.m
//  Debug
//
//  Created by kakiYen on 2019/11/29.
//

#import "MsgObject.h"

@implementation MsgObject

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
