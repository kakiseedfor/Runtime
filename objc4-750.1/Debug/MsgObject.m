//
//  MsgObject.m
//  Debug
//
//  Created by kakiYen on 2019/11/29.
//

#import "MsgObject.h"

@interface TempObject : NSObject
@property (weak, nonatomic) MsgObject *msgObject;

@end

@implementation TempObject

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);// 若 msgObject正在释放，objc_loadWeakRetained是获取不了对象。
}

@end

#pragma mark -

@interface MsgObject ()
@property (strong, nonatomic) TempObject *tempObject;

@end

@implementation MsgObject

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tempObject = [[TempObject alloc] init];
        _tempObject.msgObject = self;
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

#pragma mark -

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
