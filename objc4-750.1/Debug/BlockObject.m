//
//  BolckObject.m
//  Debug
//
//  Created by kakiYen on 2019/12/2.
//

#import "BlockObject.h"

typedef struct Temp__BlockObject__shareBlock_block_desc_0 Temp__BlockObject__shareBlock_block_desc_0;

typedef struct Temp__BlockObject__shareBlock_block_impl_0 Temp__BlockObject__shareBlock_block_impl_0;

typedef struct Temp__Block_byref_operation_0 Temp__Block_byref_operation_0;

typedef struct Temp__block_impl Temp__block_impl;

typedef struct Operation {
    int operation;
}Operation;

struct Temp__block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct Temp__Block_byref_operation_0 {
    void *__isa;
    Temp__Block_byref_operation_0 *__forwarding;
    int __flags;
    int __size;
    int operation;
};

struct Temp__BlockObject__shareBlock_block_impl_0 {
    Temp__block_impl impl;
    Temp__BlockObject__shareBlock_block_desc_0* Desc;
    BlockObject *__strong tempObject;
    BlockObject *const __strong self;
    NSString *__strong name;
    NSString *__strong country;
    Temp__Block_byref_operation_0 *operation; // by ref
};

struct Temp__BlockObject__shareBlock_block_desc_0 {
    size_t reserved;
    size_t Block_size;    //block impl的大小
};

static int Golden_Globe = 6;

#pragma mark -

@interface BlockObject ()
@property (nonatomic) int age;

@end

@implementation BlockObject

- (void)shareBlock{
    /*
     ***************** Block 类型*****************
     NSGlobalBlock[数据常量区] : 全局块，未引用任何外部局部变量[局部静态变量、全局变量除外]。
     NSMallocBlock[堆区] : 堆块，引用任何外部局部变量[局部静态变量、全局变量除外]。
     NSStackBlock[栈区] : 栈块，引用任何外部局部变量[局部静态变量、全局变量除外]。
     
     ⚠️ARC模式下:
     NSStackBlock 默认都会-(id)copy方法，拷贝到 堆区，且将 isa 指针修改为 NSMallocBlock，
                并将引用的外部变量增加引用计数[如果是通过地址传递的]
     NSGlobalBlock 调用 -(id)copy方法 没有反应，因为本身存在数据常量区，整个程序结束才会释放。
     NSMallocBlock 调用 -(id)copy方法，会增加引用计数。
     */
    void(^mallocBlock)(void) = self.mallocBlock;
    
    NSLog(@"-------------------------------------------------");
    void (^globalBlock)(void) = ^{
        NSLog(@"%s", __FUNCTION__);
    };
    
    NSLog(@"%@",[globalBlock class]);
    NSLog(@"%@",[mallocBlock class]);
    NSLog(@"%@",[^{
        NSLog(@"%d",self.age);
    } class]);
    
    NSLog(@"-------------------------------------------------");
    
    Temp__BlockObject__shareBlock_block_impl_0 *block_impl = (__bridge Temp__BlockObject__shareBlock_block_impl_0 *)mallocBlock;
    ((void (*)(Temp__block_impl *))((Temp__block_impl *)block_impl)->FuncPtr)((Temp__block_impl *)block_impl);
}

/*
 1、定义在栈中的变量，超过作用域时，会被系统自动回收，需主动拷贝一份内容至堆中。
 2、定义为局部静态变量，由于变量的内容是保存在内存中的静态区，内容会一直存在，所以可以通过地址传递达到目的。
 3、定位为全局变量，由于全局变量可以的任意作用域访问，所以无需做任何操作。
 */
- (void(^)(void))mallocBlock{
    __block int operation = 7;  //值传递
    NSLog(@"block befor %p", &operation);
    static int caree = 18;  //地址传递
    NSString *name = @"Messi";  //地址传递
    NSString *country = @"Argentina";   //地址传递
    void (^mallocBlock)(void) = nil;
    @autoreleasepool {
        BlockObject *tempObject = [[BlockObject alloc] init];
        mallocBlock = ^{
            operation = 10;
            NSLog(@"%@",tempObject);
            NSLog(@"%d : %d : %@ : %@ : %d",self.age, caree, name, country, operation);
            NSLog(@"%p : %p : %p : %p : %p : %p",&self->_age, &caree, name, country, &Golden_Globe, &operation);
        };
    }
    NSLog(@"block after %p", &operation);
    
    _age = 15;
    caree = 5;
    NSLog(@"%d : %d : %@ : %@ : %d",self.age, caree, name, country, operation);
    NSLog(@"%p : %p : %p : %p : %p : %p",&_age, &caree, name, country, &Golden_Globe, &operation);
    return mallocBlock;
}

@end
