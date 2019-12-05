//
//  BolckObject.m
//  Debug
//
//  Created by kakiYen on 2019/12/2.
//

#import "BlockObject.h"

typedef struct Temp__BlockObject__shareBlock_block_desc_0 Temp__BlockObject__shareBlock_block_desc_0;

typedef struct Temp__BlockObject__shareBlock_block_impl_0 Temp__BlockObject__shareBlock_block_impl_0;

typedef struct Temp__Block_byref_tempObject_1 Temp__Block_byref_tempObject_1;

typedef struct Temp__Block_byref_operation_0 Temp__Block_byref_operation_0;

typedef struct Temp__block_impl Temp__block_impl;

typedef struct Operation {
    int operation;
}Operation;

/*
 size = 8 + 4 + 4 + 8
 */
struct Temp__block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

/*
 size = 8 + 8 + 4 + 4 + 4 + [地址对齐 +4]
 */
struct Temp__Block_byref_operation_0 {
    void *__isa;
    Temp__Block_byref_operation_0 *__forwarding;
    int __flags;
    int __size;
    int operation;
};

/*
 size = 8 + 8 + 4 + 4 + 8 + 8 + 8
 */
struct Temp__Block_byref_tempObject_1 {
    void *__isa;
    Temp__Block_byref_tempObject_1 *__forwarding;
    int __flags;
    int __size;
    void (*Temp__Block_byref_id_object_copy)(void*, void*);
    void (*Temp__Block_byref_id_object_dispose)(void*);
    id tempObject;
};

/*
 size = 24 + 8 + 8 + 8 + 8 + 8 + 8
 */
struct Temp__BlockObject__shareBlock_block_impl_0 {
    Temp__block_impl impl;
    Temp__BlockObject__shareBlock_block_desc_0* Desc;
    BlockObject *const __strong self;
    NSString *__strong name;
    NSString *__strong country;
    Temp__Block_byref_operation_0 *blockoperation; // by ref
    Temp__Block_byref_tempObject_1 *tempObject; // by ref
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
     
     ⚠️MRC模式下:
     NSStackBlock、NSGlobalBlock、NSMallocBlock三种类型默认都不会调用 -(id)copy 方法，
     调用了 -(id)copy 方法，被__block 修饰的变量并没有被拷贝，即内部没有调用 Temp__Block_byref_id_object_copy 类似这个方法。
     
     ⚠️ARC模式下:
     NSStackBlock 默认都会-(id)copy方法，拷贝到 堆区，且将 isa 指针修改为 NSMallocBlock，
                并将引用的外部变量增加引用计数[如果是通过地址传递的]
     NSGlobalBlock 调用 -(id)copy方法 没有反应，因为本身存在数据常量区，整个程序结束才会释放。
     NSMallocBlock 调用 -(id)copy方法，会增加引用计数。
     
     调用 -(id)copy方法的各种情况：
     1、作为函数参数传递的时候。
     2、定义的block赋值到某个变量[非__weak]。
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
        __block BlockObject *tempObject = [[BlockObject alloc] init];
        mallocBlock = ^{
            operation = 10;
            NSLog(@"tempObject : %@", tempObject);
            NSLog(@"%d : %d : %@ : %@ : %d",self.age, caree, name, country, operation);
            NSLog(@"%p : %p : %p : %p : %p : %p",&self->_age, &caree, name, country, &Golden_Globe, &operation);
        };  //ARC模式下会调用 -(id)copy 方法后赋值给变量。[类似定义普通对象的变量后，调用 -(id)retain]
        
        /*
         ARC下，这里开始，所有被 block 捕获的变量已被拷贝的堆区中[有些变量本身就在堆中创建，所以只会拷贝指针]，
         无论是后续的操作还是在块中的操作的变量，都是操作拷贝的堆中的内容。
         */
    }
    NSLog(@"block after %p", &operation);   //operation->__forwarding 指向堆中的内容，所以修改的是堆中的内容。
    
    _age = 15;
    caree = 5;
    NSLog(@"%d : %d : %@ : %@ : %d",self.age, caree, name, country, operation);
    NSLog(@"%p : %p : %p : %p : %p : %p",&_age, &caree, name, country, &Golden_Globe, &operation);
    return mallocBlock;
}

@end
