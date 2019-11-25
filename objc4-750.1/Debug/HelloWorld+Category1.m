//
//  HelloWorld+Category1.m
//  Debug
//
//  Created by kakiYen on 2019/8/14.
//

#import "HelloWorld+Category1.h"
#import <objc/message.h>

/*
 若分类实现 +load 方法，则在在编译的时候会被标记为非懒加载分类；
 为非懒加载时，分类的方法是在read_image加载至全局的unattachedCategories哈希表中，当类对象实例化的时，再从该哈希表加载进类对象。
 为懒加载时，分类的方法在编译阶段就加载进只读的 class_ro_t->baseMethodList 里面。
 */
@implementation HelloWorld (Category1)

+ (void)helloWorld{
    unsigned int count = 0;
    Method *method = class_copyMethodList(NSObject.class, &count);
    for (unsigned int i = 0; i < count; i++) {
        NSLog(@"method name : %s",(char *)method_getName(method[i]));
    }
}

- (void)tempFunc{
    NSLog(@"tempFunc");
}

@end
